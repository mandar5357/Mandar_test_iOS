
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFSphinxAPIClient.h"
#import "JSONResponseSerializerWithData.h"
#import "AppDelegate.h"
#import "APIConstants.h"
@interface AFSphinxAPIClient ()

@property (nonatomic, strong) AFJSONRequestSerializer<AFURLRequestSerialization>* jsonRequestSerializer;

@end

@implementation AFSphinxAPIClient

#pragma mark - AFNetworking overrides

+ (instancetype)sharedClient
{
  
    static AFSphinxAPIClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFSphinxAPIClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_HTTP_URL]];
    });
  
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL*)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        JSONResponseSerializerWithData<AFURLResponseSerialization>* responseSerializer = [JSONResponseSerializerWithData serializer];
        //responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 199)];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", nil];
        self.responseSerializer = responseSerializer;

        // limiting open connections
        self.operationQueue.maxConcurrentOperationCount = 30;

        // About pinning http://www.doubleencore.com/2013/03/ssl-pinning-for-increased-app-security/
        // We chose not to pin at this time in order to avoid app updates on certificate expiry
        AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
#ifdef DEBUG
        // set this to allow Charles connection monitoring
        securityPolicy.allowInvalidCertificates = YES;
#endif
        [self setSecurityPolicy:securityPolicy];

        [self addEncodingToRequestSerializer:self.requestSerializer encoding:@"gzip"];

        [self initJSONRequestSerializer];
        [self addEncodingToRequestSerializer:_jsonRequestSerializer encoding:@"gzip"];
    }
    return self;
}

- (void)initJSONRequestSerializer
{
    if (!_jsonRequestSerializer)
        _jsonRequestSerializer = [AFJSONRequestSerializer serializer];
}

- (void)addEncodingToRequestSerializer:(AFHTTPRequestSerializer*)requestSerializer encoding:(NSString*)encoding
{
    NSMutableArray* encodings = [[requestSerializer.HTTPRequestHeaders[@"Accept-Encoding"] componentsSeparatedByString:@","] mutableCopy];
    if (!encodings) {
        encodings = [NSMutableArray array];
    }
    [encodings addObject:encoding];
    [requestSerializer setValue:[encodings componentsJoinedByString:@","] forHTTPHeaderField:@"Accept-Encoding"];
    
    //set version and app loacle in header
  //  [requestSerializer setValue:APP_VERSION forHTTPHeaderField:@"app_version"];
    //[requestSerializer setValue:APP_LOCALE forHTTPHeaderField:@"app_locale"];
    
   // NSLog(@"APP_LOCALE %@",APP_LOCALE);
}

- (AFHTTPRequestOperation*)HTTPRequestOperationWithRequest:(NSURLRequest*)request
                                                   success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                                                   failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSMutableURLRequest* mutableRequest = [request mutableCopy];
   if ([UIAppDelegate isInternetAvailable]) {
        mutableRequest.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    else {
        mutableRequest.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
    }

    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    NSHTTPURLResponse* response = (NSHTTPURLResponse*)cachedResponse.response;

    if (response) {
        NSString* etag = response.allHeaderFields[@"Etag"];
        if (etag) {
            [mutableRequest setValue:etag forHTTPHeaderField:@"If-None-Match"];
        }

        NSString* lm = response.allHeaderFields[@"Last-Modified"];
        if (lm) {
            [mutableRequest setValue:etag forHTTPHeaderField:@"If-Modified-Since"];
        }
    }

    AFHTTPRequestOperation* operation = [super HTTPRequestOperationWithRequest:[mutableRequest copy]
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            // Some API errors are returned with a 200
            
                success(operation, responseObject);
           
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            // Check for 304 Not Modified
            if (operation.response.statusCode == 304 && response) {
                NSError* jsonerror = nil;
                id responseObject = [self.responseSerializer responseObjectForResponse:response
                                                                                  data:cachedResponse.data
                                                                                 error:&jsonerror];
                if (jsonerror) {
                    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:operation.request];
                    SSError* merror = [SSError errorWithOperation:operation
                                                                         error:jsonerror];
                    failure(operation, [merror errorWithMediError]);
                }
                else {
                    success(operation, responseObject);
                }
            }
            else {
                NSDictionary* errorDict = [error userInfo][JSONResponseSerializerWithDataKey];
                if (errorDict) {
                    // Completed and parsed JSON responses from server, including 400s and 500s
                    SSError* merror = [SSError errorWithDict:errorDict
                                                                operation:operation
                                                                    error:error];
                    if ([merror errorType] == SSErrorTypeUnauthorized) {
                        [self handleUnauthorizedAndReplayOperation:operation success:success failure:failure];
                    }
                    else {
                        [merror showAlertIfNeeded];
                        failure(operation, [merror errorWithMediError]);
                    }
                }
                else {
                    // Broken connections, cancelled operations, timeouts, invalid JSON etc.
                    SSError* merror = [SSError errorWithOperation:operation
                                                                         error:error];
                    if ([merror errorType] != SSErrorTypeConnectionCancelled) {
                        [merror showAlertIfNeeded];
                        error = [merror errorWithMediError];
                        failure(operation, error);
                    }
                }
            }
        }];

    [operation setRedirectResponseBlock:^NSURLRequest*(NSURLConnection* connection, NSURLRequest* request, NSURLResponse* redirectResponse) {

        //VVLog(@"redirectResponse %@ %@",redirectResponse,[request URL]);
        //VVLog(@"request %@",request);

        if (redirectResponse) {
            NSMutableURLRequest* redirectRequest = [connection.originalRequest mutableCopy];
            [redirectRequest setURL:[request URL]];

            // [[UIApplication sharedApplication] openURL:[request URL]];
            return redirectRequest;
        }

        return request;
    }];

    /*
    // prevent an operation without an access token from ever being dispatched
    
    // This currently interfers with the script fetching the Mixpanel events
    // We'll accept a few failed connections on update. These will be replayed with the proper token

    if (![self isSignedOperation:operation]) {
        [self handleUnauthorizedAndReplayOperation:operation success:success failure:failure];
        return nil;
    }
    */

    return operation;
}

- (NSHTTPURLResponse*)cachedResponseFromRequest:(NSURLRequest*)request
{
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse) {
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)cachedResponse.response;
        return response;
    }
    else {
        return nil;
    }
}

- (AFHTTPRequestOperation*)PUT:(NSString*)URLString
                      bodyData:(NSData*)bodyData
                       success:(void (^)(AFHTTPRequestOperation*, id))success
                       failure:(void (^)(AFHTTPRequestOperation*, NSError*))failure
{
    NSError* error = nil;
    NSString* url = [[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString];
    NSMutableURLRequest* request = [self.requestSerializer requestWithMethod:@"PUT" URLString:url parameters:nil error:&error];
    [request setHTTPBody:bodyData];

    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    if (!error) {
        [self.operationQueue addOperation:operation];
    }
    else {
        failure(operation, error);
    }
    return operation;
}

- (AFHTTPRequestOperation*)PUT:(NSString*)URLString
                    parameters:(NSDictionary*)parameters
                       success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSError* error = nil;
    NSMutableURLRequest* request = [_jsonRequestSerializer requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:&error];
    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    if (!error) {
        [self.operationQueue addOperation:operation];
    }
    else {
        failure(operation, error);
    }
    return operation;
}

- (AFHTTPRequestOperation*)PATCH:(NSString*)URLString
                    parameters:(NSDictionary*)parameters
                       success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSError* error = nil;
    NSMutableURLRequest* request = [_jsonRequestSerializer requestWithMethod:@"PATCH" URLString:URLString parameters:parameters error:&error];
    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    if (!error) {
        [self.operationQueue addOperation:operation];
    }
    else {
        failure(operation, error);
    }
    return operation;
}

- (AFHTTPRequestOperation*)POST:(NSString*)URLString
                           json:(NSDictionary*)json
                        success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSError* error = nil;
    NSMutableURLRequest* request = [_jsonRequestSerializer requestWithMethod:@"POST" URLString:URLString parameters:json error:&error];

    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    if (!error) {
        [self.operationQueue addOperation:operation];
    }
    else {
        failure(operation, error);
    }
    return operation;
}

- (AFHTTPRequestOperation*)POST:(NSString*)URLString
                     parameters:(NSDictionary*)parameters
                    withTimeOut:(CGFloat)timeout
                        success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSError* error = nil;
    NSMutableURLRequest* request = [self.requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:parameters error:&error];
    request.timeoutInterval = timeout;

    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    if (!error) {
        [self.operationQueue addOperation:operation];
    }
    else {
        failure(operation, error);
    }
    return operation;
}


- (AFHTTPRequestOperation*)PUTRawJSON:(NSString*)URLString
                    parameters:(NSArray*)parameters
                       success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    NSError* error = nil;
    NSMutableURLRequest* request = [_jsonRequestSerializer requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:&error];
    AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    if (!error) {
        [self.operationQueue addOperation:operation];
    }
    else {
        failure(operation, error);
    }
    return operation;
}

#pragma mark - OAuth methods

- (void)setAuthorizationHeaderWithString:(NSString*)str
{
    [super setAuthorizationHeaderWithString:str];
    [self initJSONRequestSerializer];
    [_jsonRequestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
}
-(void)setClinicIdInHeader:(NSString*)clinic_id
{
    NSString *header_clinic_id =[self.requestSerializer valueForHTTPHeaderField:@"clinic_id"];
    NSLog(@"valueForHTTPHeaderField %@ %@",header_clinic_id,clinic_id);
    
    if(![header_clinic_id isEqualToString:clinic_id] && clinic_id!=nil)
    {
        NSLog(@"need to change clinic_id in header");
        [self.requestSerializer setValue:clinic_id forHTTPHeaderField:@"clinic_id"];
        [_jsonRequestSerializer setValue:clinic_id forHTTPHeaderField:@"clinic_id"];
    }
}
@end
