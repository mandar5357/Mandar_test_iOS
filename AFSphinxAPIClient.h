// AFVivinoAPIClient.h
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

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <AFHTTPRequestOperationManager.h>
#import "GRSphinxOAuth2SessionManager.h"

extern NSString* const kAuthPersistenceKey;

@interface AFSphinxAPIClient : GRSphinxOAuth2SessionManager

+ (instancetype)sharedClient;

- (AFHTTPRequestOperation*)POST:(NSString*)URLString
                           json:(NSDictionary*)json
                        success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)POST:(NSString*)URLString
                     parameters:(NSDictionary*)parameters
                    withTimeOut:(CGFloat)timeout
                        success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation*)PUT:(NSString*)URLString
                      bodyData:(NSData*)bodyData
                       success:(void (^)(AFHTTPRequestOperation*, id))success
                       failure:(void (^)(AFHTTPRequestOperation*, NSError*))failure;

- (AFHTTPRequestOperation*)PUT:(NSString*)URLString
                    parameters:(NSDictionary*)parameters
                       success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)PATCH:(NSString*)URLString
                      parameters:(NSDictionary*)parameters
                         success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;


- (AFHTTPRequestOperation*)PUTRawJSON:(NSString*)URLString
                           parameters:(NSArray*)parameters
                              success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


-(void)setClinicIdInHeader:(NSString*)clinic_id;

@end
