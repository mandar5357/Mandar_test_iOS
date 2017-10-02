//


#import <Foundation/Foundation.h>
#import "BaseAPI.h"



@interface BaseRestAPI : BaseAPI

- (AFHTTPRequestOperation*)GETAction:(APIRestAction)action
                             success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)POSTAction:(APIRestAction)action
                              success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation *)POSTAction:(APIRestAction)task
             constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation*)PUTAction:(APIRestAction)action
                             success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)DELETEAction:(APIRestAction)action
                                success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;


- (void)setupPropertiesForTask:(APIRestAction)action;
@end
