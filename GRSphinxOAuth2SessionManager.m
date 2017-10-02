

#import "GRSphinxOAuth2SessionManager.h"
#import "JSONResponseSerializerWithData.h"
#import "AppDelegate.h"



NSString* const kGROAuthUserClientUUIDGrantType = @"user_client_uuid";
NSString* const kGROAuthExternalGrantType = @"external";
static NSString* const kTokenPath = @"token";
NSString* const kAuthPersistenceKey = @"GROAuth2SessionManagerAuthKey";
NSString* const kAuthOldPersistenceKey = @"OldGROAuth2SessionManagerAuthKey";

@interface GRSphinxOAuth2SessionManager ()

@property (readwrite, nonatomic) NSString* secret;
@property (nonatomic, strong) NSOperationQueue* authenticationQueue;
@property (nonatomic, strong) dispatch_queue_t unauthorizedOperationQueue;

@end

@implementation GRSphinxOAuth2SessionManager

- (id)initWithBaseURL:(NSURL*)url
{
    self = [super initWithBaseURL:url clientID:kClientID secret:kClientSecret];
    if (self) {
        
        
        AFOAuthCredential* credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kAuthPersistenceKey];
        if (credential) {
            [self setAuthorizationHeaderWithCredential:credential];
        }

        _authenticationQueue = [[NSOperationQueue alloc] init];
        _authenticationQueue.maxConcurrentOperationCount = 1;

        _unauthorizedOperationQueue = dispatch_queue_create("com.vointi.oauth.unauthorized", NULL);
    }
    return self;
}

#pragma mark - OAuth methods

- (void)authenticateUsingOAuthWithPath:(NSString*)path
                            parameters:(NSDictionary*)parameters
                               success:(void (^)(AFOAuthCredential*))success
                               failure:(void (^)(NSError*))failure
{
    NSMutableDictionary* mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    //[mutableParameters setObject:[self clientID] forKey:@"client_id"];
   // [mutableParameters setValue:[self secret] forKey:@"client_secret"];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", kClientID, kClientSecret];
   // NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
   // NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    
    NSData *nsdata = [authStr
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"_____id %@",authStr);
    // Get NSString from NSData object in Base64
    NSString *authValue = [NSString stringWithFormat:@"Basic %@",[nsdata base64EncodedStringWithOptions:0]] ;
    
    
    
    parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];

    NSString* urlString;
    if ([self oAuthURL]) {
        urlString = [[NSURL URLWithString:path relativeToURL:[self oAuthURL]] absoluteString];
    } else {
        urlString = [[NSURL URLWithString:path relativeToURL:[self baseURL]] absoluteString];
    }

    NSError* error;
     NSMutableURLRequest* mutableRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:&error];
    [mutableRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    if (error) {
        failure(error);
        return;
    }

    mutableRequest.timeoutInterval = 30.0f;

    AFHTTPRequestOperation* requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
    [requestOperation setResponseSerializer:self.responseSerializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        if ([responseObject valueForKey:@"error"]) {
            // This is a success (e.g. 200) with an error inside. This should not happen.
            if (failure) {
                // TODO: Resolve the `error` field into a proper NSError object
                // http://tools.ietf.org/html/rfc6749#section-5.2
                failure(nil);
            }
            
            return;
        }
        
        NSString *refreshToken = [responseObject valueForKey:@"refresh_token"];
        if (refreshToken == nil || [refreshToken isEqual:[NSNull null]]) {
            refreshToken = [parameters valueForKey:@"refresh_token"];
        }
       AFOAuthCredential *credential= [self setAccessTokenAsPersistWithResponse:responseObject];
        
        if (success) {
            success(credential);
        }
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSDictionary *errorDict = [error userInfo][JSONResponseSerializerWithDataKey];
        if(errorDict) {
            SSError *merror = [SSError errorWithDict:errorDict
                                                        operation:operation
                                                            error:error];
            [merror showAlertIfNeeded];
            error = [merror errorWithMediError];
        }
        else {
            // Broken connections, cancelled operations, timeouts, invalid JSON etc.
            SSError *merror = [SSError errorWithOperation:operation
                                                                 error:error];
            if ([merror errorType] != SSErrorTypeConnectionCancelled) {
                [merror showAlertIfNeeded];
                error = [merror errorWithMediError];
            }
        }
        failure(error);
    }];

    [_authenticationQueue addOperation:requestOperation];
}

-(AFOAuthCredential*)setAccessTokenAsPersistWithResponse:(NSDictionary*)responseObject
{
     NSString *refreshToken = [responseObject valueForKey:@"refresh_token"];
   
    [self storeOldCredentialWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:kAuthPersistenceKey]];//store Old token
    
    
    AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:[responseObject valueForKey:@"access_token"] tokenType:[responseObject valueForKey:@"token_type"]];
    
    
    NSLog(@"new access token %@",credential.accessToken);
    
    NSDate *expireDate = [NSDate distantFuture];
    id expiresIn = [responseObject valueForKey:@"expires_in"];
    if (expiresIn != nil && ![expiresIn isEqual:[NSNull null]]) {
        expireDate = [NSDate dateWithTimeIntervalSinceNow:[expiresIn doubleValue]];
    }
    
    [credential setRefreshToken:refreshToken expiration:expireDate];
    
    [self setAuthorizationHeaderWithCredential:credential];
    [AFOAuthCredential storeCredential:credential withIdentifier:kAuthPersistenceKey];
    
    return credential;
}
- (void)setAuthorizationHeaderWithToken:(NSString*)token ofType:(NSString*)type
{
    // See http://tools.ietf.org/html/rfc6749#section-7.1
    if ([[type lowercaseString] isEqualToString:@"bearer"]) {
        [self setAuthorizationHeaderWithString:[self authorizationHeaderForToken:token]];
    }
}

- (void)clearAuthorizationHeader
{
    [self setAuthorizationHeaderWithString:nil];
}

- (void)setAuthorizationHeaderWithString:(NSString*)str
{
    [[self requestSerializer] setValue:str forHTTPHeaderField:@"Authorization"];
}

- (void)clearOAuthAccessToken
{
    [AFOAuthCredential deleteCredentialWithIdentifier:kAuthPersistenceKey];
}

- (void)authenticateUsingUserClientUUIDWithUuid:(NSString*)uid
                                        user_id:(NSNumber*)user_id
                                        success:(void (^)(AFOAuthCredential*))success
                                        failure:(void (^)(NSError*))failure
{
    NSMutableDictionary* mutableParameters = [NSMutableDictionary dictionary];
    [mutableParameters setObject:uid forKey:@"uuid"];
    [mutableParameters setObject:[user_id stringValue] forKey:@"user_id"];

    [mutableParameters setObject:kGROAuthUserClientUUIDGrantType forKey:@"grant_type"];

    NSDictionary* parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
    [self authenticateUsingOAuthWithPath:kTokenPath parameters:parameters success:success failure:failure];
}

- (void)authenticateUsingExternalWithParams:(NSDictionary*)params
                                    success:(void (^)(AFOAuthCredential*))success
                                    failure:(void (^)(NSError*))failure
{
    NSMutableDictionary* mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutableParameters setObject:kGROAuthExternalGrantType forKey:@"grant_type"];
    NSDictionary* parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
    [self authenticateUsingOAuthWithPath:kTokenPath parameters:parameters success:success failure:failure];
}

- (void)authenticateUsingOAuthWithRefreshToken:(NSString*)refreshToken
                                       success:(void (^)(AFOAuthCredential* credential))success
                                       failure:(void (^)(NSError* error))failure
{
    [self authenticateUsingOAuthWithPath:kTokenPath refreshToken:refreshToken success:success failure:failure];
}

- (void)authenticateUsingOAuthWithUsername:(NSString*)username
                                  password:(NSString*)password
                                   success:(void (^)(AFOAuthCredential* credential))success
                                   failure:(void (^)(NSError* error))failure
{
    [self authenticateUsingOAuthWithPath:kTokenPath username:username password:password scope:nil success:success failure:failure];
}

#pragma mark - OAuth error handling

- (void)handleUnauthorizedAndReplayOperation:(AFHTTPRequestOperation*)operation
                                     success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSLog(@"Reauthenticate");

    // Run everything on a serial queue, no two failed operations can be resolved at the same time.
    // Adds to queue async but runs serially.
    dispatch_async(_unauthorizedOperationQueue, ^{
        AFOAuthCredential* credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kAuthPersistenceKey];

        if (credential && (![self isSignedOperation:operation] || ([self isSignedOperation:operation] && ![self hasCurrentToken:operation]))) {
            // Token has been renewed since the request was made. Let's reschedule with the new token.
            [self rescheduleOperation:operation withCredential:credential success:success failure:failure];
            return;
        }
        
        // The token on the operation is either the current one, missing or we don't have a token at all. We need to get a new token
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        [self refreshOauthToken:credential
                        success:^(AFOAuthCredential* credential) {
                            // Reschedule the same request for immediate execution with the new credentials
                            [self rescheduleOperationAtFrontOfQueue:operation withCredential:credential success:success failure:failure];
                            NSLog(@"Refresh was successful");
                            dispatch_semaphore_signal(semaphore);
                        }
                        failure:^(NSError* error) {
                            // Token refresh failed
                            SSError* merror = (SSError*)[error userInfo][kSSErrorObjectKey];
                            if (merror.errorResolutionType == SSErrorResolutionTypeForceLogin) {
                                [self.operationQueue cancelAllOperations];
                            }
                            [merror showAlertIfNeeded];
                            NSLog(@"Refresh failed");
                            dispatch_semaphore_signal(semaphore);
                        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
}

- (void)refreshOauthToken:(AFOAuthCredential*)credential
                  success:(void (^)(AFOAuthCredential*))success
                  failure:(void (^)(NSError*))failure
{
    if (credential && credential.refreshToken) {
        // We have credentials. Let's use them
        [self authenticateUsingOAuthWithPath:kTokenPath
                                refreshToken:credential.refreshToken
                                     success:success
                                     failure:failure];
    }
    /*
     // Closing uuid grant type API https://tickets.vivino.com/issues/12690

     else if ([self hasUserIdButNotAuthenticated]) {
        // We have a user with an existing Uuid. Most likely a pre 7.7.0 user
        [self authenticateUsingUserClientUUIDWithUuid:[Utility deviceUUID]
                                              user_id:[VVUserDefaults userId]
                                              success:^(AFOAuthCredential* credential) {
                                                      [UIAppDelegate registerDevice];
                                                      success(credential);
                                              }
                                              failure:failure];


    }     
     */
    else {
        // We have neither credentials nor uuid. Show an error and report to tracking for investigation
        // This could happen on signup before any uuid has been issued.
        SSError* merror = [SSError OAuthError:self];
        failure([merror errorWithMediError]);
    }
}

- (void)rescheduleOperation:(AFHTTPRequestOperation*)operation
             withCredential:(AFOAuthCredential*)credential
                    success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    [operation cancel];

    AFHTTPRequestOperation* retryOperation = [self signRequestOperation:operation withCredential:credential success:success failure:failure];
    [self.operationQueue addOperation:retryOperation];
}

- (void)rescheduleOperationAtFrontOfQueue:(AFHTTPRequestOperation*)operation
                           withCredential:(AFOAuthCredential*)credential
                                  success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    [operation cancel];
    AFHTTPRequestOperation* tmp = [self signRequestOperation:operation withCredential:credential success:success failure:failure];
    tmp.queuePriority = NSOperationQueuePriorityHigh;
    [self.operationQueue addOperation:tmp];
}

#pragma mark - Utility methods

- (AFHTTPRequestOperation*)signRequestOperation:(AFHTTPRequestOperation*)operation
                                 withCredential:(AFOAuthCredential*)credential
                                        success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSURLRequest* request = [self request:operation.request signedWithCredential:credential];
    AFHTTPRequestOperation* retryOperation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    return retryOperation;
}

- (BOOL)isSignedOperation:(AFHTTPRequestOperation*)operation
{
    return [self isSignedRequest:operation.request];
}

- (BOOL)isSignedRequest:(NSURLRequest*)request
{
    return [self authorizationHeaderForRequest:request] != nil;
}

- (NSString*)authorizationHeaderForOperation:(AFHTTPRequestOperation*)operation
{
    return [self authorizationHeaderForRequest:operation.request];
}

- (NSString*)authorizationHeaderForRequest:(NSURLRequest*)request
{
    return [request valueForHTTPHeaderField:@"Authorization"];
}

- (BOOL)hasCurrentToken:(AFHTTPRequestOperation*)operation
{
    AFOAuthCredential* credential= [AFOAuthCredential retrieveCredentialWithIdentifier:kAuthPersistenceKey];
    
    NSString *operationTokenString = [self authorizationHeaderForOperation:operation];
    NSString *credentialTokenString = [self authorizationHeaderForCredential:credential];
    return [operationTokenString isEqualToString:credentialTokenString];
}

- (NSURLRequest*)request:(NSURLRequest*)request signedWithCredential:(AFOAuthCredential*)credential
{
    return [self request:request signedWithToken:credential.accessToken];
}

- (NSURLRequest*)request:(NSURLRequest*)request signedWithToken:(NSString*)token
{
    NSMutableURLRequest* tmp = [request mutableCopy];
    [tmp setValue:[self authorizationHeaderForToken:token] forHTTPHeaderField:@"Authorization"];
    return [tmp copy];
}

- (NSString*)authorizationHeaderForCredential:(AFOAuthCredential*)credential {
    return [self authorizationHeaderForToken:credential.accessToken];
}

- (NSString*)authorizationHeaderForToken:(NSString*)token {
    return [NSString stringWithFormat:@"Bearer %@", token];
}

- (NSString*)getOldCredential
{
    AFOAuthCredential* previous_credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kAuthOldPersistenceKey];
    return previous_credential.accessToken;
}

- (NSString*)getOAuthAccessToken
{
    return [AFOAuthCredential retrieveCredentialWithIdentifier:kAuthPersistenceKey].accessToken;
}

- (void)storeOldCredentialWithCredential:(AFOAuthCredential*)credential
{
    [AFOAuthCredential storeCredential:credential withIdentifier:kAuthOldPersistenceKey];
}

- (BOOL)hasUserIdButNotAuthenticated
{
  //  return ([VVUserDefaults userId].integerValue > 0 && ![self getOAuthAccessToken]);
  return ( ![self getOAuthAccessToken]);
}

- (BOOL)isAuthenticated
{
    AFOAuthCredential *cred = [AFOAuthCredential retrieveCredentialWithIdentifier:kAuthPersistenceKey];
   // return ([VVUserDefaults userId].integerValue > 0 && cred && cred.refreshToken);
     return ( cred && cred.refreshToken);
}

-(void)rollbackCredenticals
{
    AFOAuthCredential* previous_credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kAuthOldPersistenceKey];
    
    AFOAuthCredential* new_credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kAuthPersistenceKey];
    
   NSLog(@"Old credential %@",previous_credential);
    
    NSLog(@"New credential %@",new_credential);
    
    [AFOAuthCredential storeCredential:previous_credential withIdentifier:kAuthPersistenceKey];
 
    NSLog(@"after rollback New credential %@",[AFOAuthCredential retrieveCredentialWithIdentifier:kAuthPersistenceKey]);
    
    [self setAuthorizationHeaderWithCredential:[AFOAuthCredential retrieveCredentialWithIdentifier:kAuthPersistenceKey]];
    
}

@end
