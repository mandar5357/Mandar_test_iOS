//
//  BaseAPI.h
//  
//
//  Created by Admin on 17/07/14.
//
//

#import <Foundation/Foundation.h>
#import "AFSphinxAPIClient.h"
#import "SSError.h"

typedef NS_ENUM(NSInteger, APIPostBodyType) {
  APIPostBodyTypeParameters,
  APIPostBodyTypeJSON,
    APIPostBodyTypeRawJSON
};

typedef NS_ENUM(NSInteger, APIRestAction) {
    APIRestImportantPlacesList,
};

@interface BaseAPI : NSObject
@property (nonatomic) NSString* baseUrl;
@property (nonatomic) NSMutableDictionary* urlParameters;
@property (nonatomic) NSMutableDictionary* parameters;
@property (nonatomic) NSMutableArray* pathComponents;
@property (nonatomic) CGFloat timeout;
@property (nonatomic, readonly) SSError* error;
@property (nonatomic) APIPostBodyType postBodyType;
@property (nonatomic) NSArray* arrayParmameters;

- (AFHTTPRequestOperation*)GETsuccess:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)POSTsuccess:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)POSTconstructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                                                 success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)PUTsuccess:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)DELETEsuccess:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)PUTData:(NSData*)bodyData
                           success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (AFHTTPRequestOperation*)PATCHsuccess:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;


- (id)initWithParams:(NSDictionary*)dict
              action:(APIRestAction)action
            keyArray:(NSArray*)array;

- (id)initWithParams:(NSDictionary*)dict;
- (id)initWithArray:(NSArray*)array;
- (void)paginateStartFrom:(NSInteger)startFrom limit:(NSInteger)limit;
- (void)paginatePage:(NSInteger)page perPage:(NSInteger)perPage;
- (void)paginateLimitStart:(NSInteger)start end:(NSInteger)end;

- (void)sendLocationIdForMenu:(NSInteger)location_id;
- (void)sendMatchText:(NSString*)matchText withVintageId:(NSInteger)vintage_id ;
-(void)sendEditedComment:(NSString *)text;

@end
