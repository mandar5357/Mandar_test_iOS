

#import "MTLModelModified.h"
#import "AFHTTPRequestOperation.h"

typedef NS_ENUM(NSInteger, SSErrorType) {
    // API errors

    SSErrorTypeUndefined = 0,
    SSErrorTypeVerifyAccount,
    SSErrorTypeUnknown,
    SSErrorTypeBadRequest,
    SSErrorTypeUnauthorized,
    SSErrorTypeForbidden,
    SSErrorTypeNotFound,
    SSErrorTypeConflict,
    SSErrorTypeEmailPasswordExist,
    SSErrorTypeUserDoesNotExist,
    SSErrorTypeServerError,
    SSErrorTypeServerUnavailable,
    SSErrorTypeAppVersionNotSupported,
    SSErrorTypeConnectionCancelled,
    SSErrorTypeConnectionError,
    SSErrorTypeNoNetwork,
    SSErrorTypeJSONParserError,
    SSErrorTypeDataModelError,
    SSErrorTypeRestrictedUser,
    SSErrorTypeBlacklistedUser,
    SSErrorTypeLikeBeforeUnlike,
    SSErrorTypeContentFilter,
    SSErrorTypeInvalidFacebookToken,
    // AOuth errors
    SSErrorTypeOAuthGeneralError,    
    SSErrorTypeUserCredentialsIncorrect,
    SSErrorTypeInvalidRefreshToken,
    SSErrorTypeInvalidRequest,
    SSErrorTypeEmailValidationError
};

typedef NS_ENUM(NSInteger, SSErrorResolutionType) {
    SSErrorResolutionTypeShowAlertAndContinue = 1,
    SSErrorResolutionTypeHandleInApp,
    SSErrorResolutionTypeRequestUpgradeAndBlock,
    SSErrorResolutionTypeForceLogin
};

static NSString * const kSSErrorObjectKey = @"SSErrorObjectKey";

@interface SSError : MTLModelModified


@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSString* from;
@property (nonatomic, strong) NSError* nserror;
@property (nonatomic, strong) AFHTTPRequestOperation *operation;
@property (nonatomic) SSErrorType errorType;

- (id)initWithMessage:(NSString*)msg code:(NSString*)code from:(NSString*)from errorType:(SSErrorType)errorType;
- (id)initWithOperation:(AFHTTPRequestOperation*)operation error:(NSError*)error;

+ (SSError*)errorWithDict:(NSDictionary*)dict;
+ (SSError*)errorWithDict:(NSDictionary*)dict
                    operation:(AFHTTPRequestOperation*)operation
                        error:(NSError*)error;
+ (SSError*)errorWithOperation:(AFHTTPRequestOperation*)operation error:(NSError*)error;

+ (SSError*)dataModelErrorFrom:(id)fromInstance;
+ (SSError*)OAuthError:(id)fromInstance;
- (SSErrorResolutionType)errorResolutionType;
- (NSError*)errorWithMediError;
- (NSString*)localizedMessage;
- (NSString*)localizedTitle;
- (NSDictionary*)properties;


- (void)showAlertIfNeeded;
+(NSString*)getErrorMessage:(NSError*)error;
@end
