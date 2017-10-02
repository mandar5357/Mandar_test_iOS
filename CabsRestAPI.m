//
//  CabsRestAPI.m
//  CabWala
//
//  Created by Sphinx Solution Pvt Ltd on 12/18/15.
//  Copyright © 2015 ananadmahajan. All rights reserved.
//

#import "CabsRestAPI.h"

@implementation CabsRestAPI

- (id)init
{
    self = [super init];
    if (self) {
        //[self.pathComponents addObject:@"cabs"];
    }
    return self;
}

- (AFHTTPRequestOperation*)GETAction:(APIRestAction)action
                             success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    [self setupPathComponents:action];
    return [super GETAction:action success:success failure:failure];
}
- (AFHTTPRequestOperation*)GETAction:(APIRestAction)action
                           doctor_id:(NSString*)doctor_id
                             success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    [self setupPathComponents:action];
    [self.pathComponents addObject:doctor_id];
    return [super GETAction:action success:success failure:failure];
}


- (AFHTTPRequestOperation*)POSTAction:(APIRestAction)action
                              success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    [self setupPathComponents:action];
    
    return [super POSTAction:action success:success failure:failure];
}
- (AFHTTPRequestOperation*)POSTAction:(APIRestAction)task
            constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                              success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;
{
    [self setupPathComponents:task];
    return [super POSTconstructingBodyWithBlock:block success:success failure:failure];
}
- (void)setupPathComponents:(APIRestAction)action
{
    NSArray *subPath;
    if(action==APIRestImportantPlacesList)
    {
        self.postBodyType = APIPostBodyTypeJSON;
        subPath=[NSArray arrayWithObjects:@"getImportantPlacesList",nil];
    }
    
    if(subPath.count)
        [self.pathComponents addObjectsFromArray:subPath];
}

- (void)setupPropertiesForTask:(APIRestAction)action
{
    NSArray *subPath=nil;
    if(subPath.count)
        [self.pathComponents addObjectsFromArray:subPath];
}
@end
