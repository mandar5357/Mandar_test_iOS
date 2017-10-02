//
//  BaseAPI.m
//  
//
//  Created by Admin on 17/07/14.
//
//

#import "BaseAPI.h"
#import <CMDQueryStringSerialization.h>
#import "AppManager.h"

#define keySecret @"C@bW@!@#$^&"
@interface BaseAPI ()

@end

@implementation BaseAPI

- (id)init
{
    self = [super init];
    if (self) {
        _urlParameters = [NSMutableDictionary new];
        _parameters = [NSMutableDictionary new];
        _baseUrl = BASE_HTTP_URL;
        _pathComponents = [NSMutableArray new];
        _timeout = 0.0f;
        _postBodyType = APIPostBodyTypeParameters;
       
     }
    return self;
}
- (id)initWithParams:(NSDictionary*)dict
{
    self = [self init];
    if (self) {
         [_parameters addEntriesFromDictionary:dict];
    }
    return self;
}
- (id)initWithParams:(NSDictionary*)dict
              action:(APIRestAction)action
            keyArray:(NSArray*)array

{
    self = [self init];
    if (self) {
        [self setSecretKeyWithAction:action keyArray:array];
        [_parameters addEntriesFromDictionary:dict];
    }
    return self;
}

- (id)initWithArray:(NSArray*)array
{
    self = [self init];
    if (self) {
        _arrayParmameters=array;
    }
    return self;
}

- (AFHTTPRequestOperation*)GETsuccess:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    // For GET move all urlParameters into parameters and let AFN deal with parameters in the url
    [_parameters addEntriesFromDictionary:_urlParameters];
    [_urlParameters removeAllObjects];
    
    
    return [[AFSphinxAPIClient sharedClient] GET:[self URLString] parameters:_parameters success:success failure:failure];
}

- (AFHTTPRequestOperation*)POSTsuccess:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    AFHTTPRequestOperation* result;
    NSString* urlString = [self URLString];
    if (_timeout > 0) {
        result = [[AFSphinxAPIClient sharedClient] POST:urlString parameters:_parameters withTimeOut:_timeout success:success failure:failure];
    } else {
        switch (_postBodyType) {
            case APIPostBodyTypeJSON:
                result = [[AFSphinxAPIClient sharedClient] POST:urlString json:_parameters success:success failure:failure];
                break;
            default:
                result = [[AFSphinxAPIClient sharedClient] POST:urlString parameters:_parameters success:success failure:failure];
                break;
        }
    }
    return result;
}

- (AFHTTPRequestOperation*)POSTconstructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                                                 success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    return [[AFSphinxAPIClient sharedClient] POST:[self URLString]
                                       parameters:_parameters
                        constructingBodyWithBlock:block
                                          success:success
                                          failure:failure];
}

- (AFHTTPRequestOperation*)PUTData:(NSData*)bodyData
                           success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    return [[AFSphinxAPIClient sharedClient] PUT:[self URLString]
                                        bodyData:bodyData
                                         success:success
                                         failure:failure];
}


- (AFHTTPRequestOperation*)PUTsuccess:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    AFHTTPRequestOperation* result;
    NSString* urlString = [self URLString];
    
    switch (_postBodyType) {
        case APIPostBodyTypeRawJSON:
            result = [[AFSphinxAPIClient sharedClient] PUTRawJSON:urlString parameters:_arrayParmameters success:success failure:failure];

            break;
        default:
            result = [[AFSphinxAPIClient sharedClient] PUT:urlString parameters:_parameters success:success failure:failure];

            break;
    }
    return result;
}

- (AFHTTPRequestOperation*)PATCHsuccess:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    AFHTTPRequestOperation* result;
    NSString* urlString = [self URLString];
    result = [[AFSphinxAPIClient sharedClient] PATCH:urlString parameters:_parameters success:success failure:failure];
    return result;
}


- (AFHTTPRequestOperation*)DELETEsuccess:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    AFHTTPRequestOperation* result;
    NSString* urlString = [self URLString];
    result = [[AFSphinxAPIClient sharedClient] DELETE:urlString parameters:_parameters success:success failure:failure];
    return result;
}


#pragma mark - Pagination

- (void)paginatePage:(NSInteger)page perPage:(NSInteger)perPage
{
    NSInteger startFrom = perPage * (page - 1);
    [self paginateStartFrom:startFrom limit:perPage];
}

- (void)paginateStartFrom:(NSInteger)startFrom limit:(NSInteger)limit
{
    _urlParameters[@"start_from"] = [NSNumber numberWithInteger:startFrom];
    _urlParameters[@"limit"] = [NSNumber numberWithInteger:limit];
}

- (void)paginateLimitStart:(NSInteger)start end:(NSInteger)end
{
    _urlParameters[@"limit_start"] = [NSNumber numberWithInteger:start];
    _urlParameters[@"limit_end"] = [NSNumber numberWithInteger:end];
}

-(void)sendLocationIdForMenu:(NSInteger)location_id
{
     _urlParameters[@"location_id"] = [NSNumber numberWithInteger:location_id];
}

-(void)sendMatchText:(NSString*)matchText withVintageId:(NSInteger)vintage_id
{
    _urlParameters[@"text"] = matchText;
    _urlParameters[@"vintage_id"] = [NSNumber numberWithInteger:vintage_id];
}

-(void)sendEditedComment:(NSString *)text
{
    _urlParameters[@"text"] = text;
}

#pragma mark - Utility methods

- (NSString*)URLString
{
    NSMutableString* urlString = [NSMutableString stringWithString:_baseUrl];

    if ([_pathComponents count] > 0) {
        NSString* path = [NSString stringWithFormat:@"/%@", [_pathComponents componentsJoinedByString:@"/"]];
        [urlString appendString:path];
    }

    if ([_urlParameters count] > 0) {
        NSString* params = [CMDQueryStringSerialization queryStringWithDictionary:_urlParameters];
        [urlString appendString:[NSString stringWithFormat:@"?%@", params]];
    }

    //VVLog(@"%@", urlString);
    return [urlString copy];
}

-(void)setSecretKeyWithAction:(APIRestAction)action
                        keyArray:(NSArray*)array
{/*
  
  Base URL
   http://52.5.157.155/cabsv1/
  
  
  Secret Key (You just need to use this key for api generation dont send it in api request)
  C@bW@!@#$^&
  t
  TIMESTAMP
  
  k
  SEND KEY
  
  API NAME
  KEY GENERATE FORMULA
  RESPONSE IF KEY NOT MATCH
  
  appForgotPassword
  appForgotPassword501 + timestamp + mobile number + service Id + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  loginUser
  LoginUser502 + timestamp + mobile number + service Id + user id + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  otpUser
  otpUser503 + timestamp + mobile number + service Id + opt code + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  bookCar
  bookCar504 + timestamp + user id + service Id + latitude + longitude + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  updateCarStatus
  updateCarStatus505 + timestamp + Booking Id + Device Type + Secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  cancelBooking
  cancelBooking506 + timestamp + Booking Id + Device ID + Secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  getMyBooking
  getMyBooking507 + timestamp + user Id + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  getMyBookingDetails
  getMyBookingDetails508 + timestamp + booking id + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  appSignup
  appSignup509 + timestamp + user id + device id + service id + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  appSignupParameters
  appSignupParameters510 + timestamp + service id + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  applogin
  applogin511 + timestamp + mobile number + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  http://52.5.157.155/cabsv1/changeMobileNumber/
  userId = users unique id
  mobileNo = users mobile number
  k = md5(changeMobileNumber533 + mobile number + user id + timestamp + secret key)
  t = timestamp
  
  
  registerUser
  registerUser512 + timestamp + mobile number + social type + email + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  resendOTP
  resendOTP513  + timestamp + user Id + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  verifyRegistrationOtp
  verifyRegistrationOtp514  + timestamp + user Id + OTP code + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  checkSocialLogin
  checkSocialLogin515 + timestamp + social id + social type + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  connectUser
  connectUser516  + timestamp + mobile number + user Id + service Id + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  disconnectUser
  disconnectUser517   + timestamp +  user Id + service Id + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  getConnectStatus
  getConnectStatus518 + timestamp +  user Id + service Id + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  forgotPassword
  forgotPassword519 + timestamp + email + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  getImportantPlacesList
  getImportantPlacesList520 + timestamp + latitude + longitude + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  updateMyProfile
  updateMyProfile521 + timestamp + mobile number + user Id +  secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  changePassword
  changePassword522 + timestamp + password + user Id +  secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  feedback
  feedback523  + timestamp + message + user Id +  secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  searchTripByPriority
  searchTripByPriority524 + timestamp + ride type + priority Id + latitude + longitude  + user id + secret key
  {“status”:”error”,”message”:”Invalid Request”}
  
  
  userLogout
  userLogout527 + USER ID + TIMESTAMP + SECRET KEY
  {“status”:”error”,”message”:”Invalid Request”}
  
  CALL WHEN USER CLICK ON LOGOUT FROM APP.
  put this api on logout
  
  rideFeedback
  rideFeedback525 + bookingId + serviceId + userId + timestamp + secret key
  {“status”:”error”,”message”:”Invalid Request”}

  */
    
    NSString *urlSpecifiKey =[self getUrlSpecificKeyWithAction:action];
    
    if(![[AppManager sharedData] isEmpty:urlSpecifiKey])
    {
        long timestamp =(long)[[NSDate date] timeIntervalSince1970];
        NSLog(@"___ %@",urlSpecifiKey);
        
        NSMutableString *key =[NSMutableString new];
        
        [key appendString:urlSpecifiKey];
        
        for (NSString*str in array) {
            [key appendString:str];
        }
        [key appendFormat:@"%ld",(long)timestamp];
        
        [key appendString:keySecret];
        
        
        //add keys in url
        [self.parameters setObject:md5(key) forKey:@"k"];
        [self.parameters setObject:[NSString stringWithFormat:@"%ld",(long)timestamp] forKey:@"t"];
        
        NSLog(@"key___ %@",key);
    }
    [self.parameters setObject:API_VERSION forKey:@"api_version"];
    [self.parameters setObject:DEVICE_TYPE forKey:@"device_type"];
    [self.parameters setObject:USER_AGENT forKey:@"user_agent"];
    [self.parameters setObject:PLATFORM forKey:@"platform"];
    
  
}
-(NSString*)getUrlSpecificKeyWithAction:(APIRestAction)action
{
    NSString *urlKey=@"";
    if(action==APIRestImportantPlacesList)
    {
        urlKey=@"getImportantPlacesList520";
    }
    return urlKey;
}

@end
