//
//  CabsRestAPI.h
//  CabWala
//
//  Created by Sphinx Solution Pvt Ltd on 12/18/15.
//  Copyright © 2015 ananadmahajan. All rights reserved.
//

#import "BaseRestAPI.h"

@interface CabsRestAPI : BaseRestAPI
- (AFHTTPRequestOperation*)GETAction:(APIRestAction)action
                             success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)GETAction:(APIRestAction)action
                           doctor_id:(NSString*)doctor_id
                             success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)POSTAction:(APIRestAction)action
                              success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)POSTAction:(APIRestAction)task
            constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                              success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

@end
