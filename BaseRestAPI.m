
#import "BaseRestAPI.h"

@implementation BaseRestAPI

- (id)init
{
    self = [super init];
    if (self) {
        super.baseUrl = BASE_HTTP_URL;
        [self.pathComponents removeObject:@"api"];
    }
    return self;
}

- (AFHTTPRequestOperation*)GETAction:(APIRestAction)action
                             success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    [self setupPropertiesForTask:action];
    return [super GETsuccess:success failure:failure];
}

- (AFHTTPRequestOperation*)POSTAction:(APIRestAction)action
                              success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    [self setupPropertiesForTask:action];
    return [super POSTsuccess:success failure:failure];
}

- (AFHTTPRequestOperation*)POSTAction:(APIRestAction)task
            constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                              success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;
{
    [self setupPropertiesForTask:task];
    return [super POSTconstructingBodyWithBlock:block success:success failure:failure];
}

- (AFHTTPRequestOperation*)PUTAction:(APIRestAction)action
                             success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    [self setupPropertiesForTask:action];
    return [super PUTsuccess:success failure:failure];
}

- (AFHTTPRequestOperation*)DELETEAction:(APIRestAction)action
                                success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    [self setupPropertiesForTask:action];
    return [super DELETEsuccess:success failure:failure];
 
}

- (void)setupPropertiesForTask:(APIRestAction)action
{
   // To be overridden in subclass
}
@end
