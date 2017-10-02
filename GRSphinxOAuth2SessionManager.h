



#import "GROAuth2SessionManager.h"
#import "SSError.h"
extern NSString* const kAuthPersistenceKey;
static NSString* const kClientID = @"v@r|!t@chM@b!le";
static NSString* const kClientSecret = @"!#%vrt@$^@!";

@interface GRSphinxOAuth2SessionManager : GROAuth2SessionManager

- (void)authenticateUsingUserClientUUIDWithUuid:(NSString*)uid
                                        user_id:(NSNumber*)user_id
                                        success:(void (^)(AFOAuthCredential*))success
                                        failure:(void (^)(NSError*))failure;

- (void)authenticateUsingExternalWithParams:(NSDictionary*)params
                                    success:(void (^)(AFOAuthCredential*))success
                                    failure:(void (^)(NSError*))failure;

- (void)authenticateUsingOAuthWithRefreshToken:(NSString*)refreshToken
                                       success:(void (^)(AFOAuthCredential* credential))success
                                       failure:(void (^)(NSError* error))failure;

- (void)authenticateUsingOAuthWithUsername:(NSString*)username
                                  password:(NSString*)password
                                   success:(void (^)(AFOAuthCredential* credential))success
                                   failure:(void (^)(NSError* error))failure;

- (void)refreshOauthToken:(AFOAuthCredential*)credential
                  success:(void (^)(AFOAuthCredential*))success
                  failure:(void (^)(NSError*))failure;

- (void)handleUnauthorizedAndReplayOperation:(AFHTTPRequestOperation*)operation
                                   success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)setAuthorizationHeaderWithString:(NSString*)str;
- (BOOL)isSignedOperation:(AFHTTPRequestOperation*)operation;
- (void)clearOAuthAccessToken;
- (void)clearAuthorizationHeader;
- (NSString*)getOldCredential;
- (NSString*)getOAuthAccessToken;
- (void)storeOldCredentialWithCredential:(AFOAuthCredential*)credential;
- (void)rollbackCredenticals;
- (BOOL)hasUserIdButNotAuthenticated;
- (BOOL)isAuthenticated;
-(AFOAuthCredential*)setAccessTokenAsPersistWithResponse:(NSDictionary*)responseObject;
@end
