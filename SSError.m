

#import "SSError.h"
#import "AFSphinxAPIClient.h"
#import "AppDelegate.h"
@interface SSError ()

@property (nonatomic) BOOL errorShown;

@end

@implementation SSError

#pragma mark - Class convenience constructors

+ (SSError*)dataModelErrorFrom:(id)fromInstance
{
    return [[SSError alloc] initWithMessage:@"Datamodel could not be created from dictionary"
                                           code:nil
                                           from:NSStringFromClass([fromInstance class])
                                      errorType:SSErrorTypeDataModelError];
}

+ (SSError*)OAuthError:(id)fromInstance
{
    return [[SSError alloc] initWithMessage:@"Authentication failed because we're missing both token and UID"
                                           code:nil
                                           from:NSStringFromClass([fromInstance class])
                                      errorType:SSErrorTypeOAuthGeneralError];
}

+ (SSError*)errorWithDict:(NSDictionary*)dict
{
    NSError* error;
    SSError* err = [MTLJSONAdapter modelOfClass:SSError.class fromJSONDictionary:dict error:&error];
    if (error) {
        //VVLog(@"JSON: %@, \n\n Error: %@", dict, error);
        return nil;
    }
    //VVLog(@"JSON: %@, Error: %@", dict, err);

    return err;
}

+ (SSError*)errorWithDict:(NSDictionary*)dict
                    operation:(AFHTTPRequestOperation*)operation
                        error:(NSError*)error
{
    SSError* err = [self errorWithDict:dict];
    if (!err) {
        err = [self errorWithOperation:operation error:error];
    }

    if (err) {
        err.nserror = error;
        err.operation = operation;
        err.errorType = [err errorTypeFromState];
        err.errorShown = NO;
    }
    return err;
}

+ (SSError*)errorWithOperation:(AFHTTPRequestOperation*)operation error:(NSError*)error
{
    return [[SSError alloc] initWithOperation:operation error:error];
}

- (NSError*)errorWithMediError
{
    NSMutableDictionary* tmp = [NSMutableDictionary new];
    tmp[kSSErrorObjectKey] = self;

    NSError* newError;

    if (_nserror) {
        [tmp addEntriesFromDictionary:_nserror.userInfo];
        newError = [NSError errorWithDomain:_nserror.domain code:_nserror.code userInfo:tmp];
    }
    else {
        newError = [NSError errorWithDomain:@"" code:0 userInfo:tmp];
    }

    return newError;
}

#pragma mark - Initializers

- (id)initWithMessage:(NSString*)msg code:(NSString*)code from:(NSString*)from errorType:(SSErrorType)errorType
{
    self = [super init];
    if (self) {
        _errorType = errorType;
        self.message = msg;
        _code = code;
        _from = from;
        _errorShown = NO;
    }
    return self;
}

- (id)initWithOperation:(AFHTTPRequestOperation*)operation error:(NSError*)error
{
    self = [super init];
    if (self) {
        _operation = operation;
        self.message = error.localizedDescription;
        _nserror = error;
        _errorShown = NO;

       
        _errorType = [self errorTypeFromState];
      

        if (_errorType == SSErrorTypeUnknown) {
            if (![(AppDelegate*) [[UIApplication sharedApplication] delegate] isInternetAvailable]) {
                _errorType = SSErrorTypeNoNetwork;
            }
            else if (error.code == 3840) {
                _errorType = SSErrorTypeJSONParserError;
            }
            else if (error.code == -999) {
                _errorType = SSErrorTypeConnectionCancelled;
            }
            else if (error.code == -1011) {
                _errorType = SSErrorTypeJSONParserError;
            }
            else if (error.code < -998 && error.code > -1099) {
                _errorType = SSErrorTypeConnectionError;
            }
        }
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString*)key
{
    if ([key isEqualToString:@"code"]) {
        _code = [NSString stringWithFormat:@"%@", value];
    }
    else {
        [super setValue:value forKey:key];
    }
}

#pragma mark - Error logic

- (SSErrorType)errorTypeFromState
{
    SSErrorType error;
    //VVLog(@"_operation.response.statusCode %ld  _code %@", (long)_operation.response.statusCode, _code);
    switch (_operation.response.statusCode) {
    // Yes, some API errors do have a 200 return code
    case 200:
        if ([_code isEqualToString:@"16-6"]) {
            //{"error":{"message":"User doesn't exist","code":"16-6"}}
            error = SSErrorTypeUserDoesNotExist;
        }
        else {
            error = SSErrorTypeUnknown;
        }
    case 400:
        if ([_code isEqualToString:@"1-6"] || [_code isEqualToString:@"1-5"]) {
            //{"error":{"message":"User with current email already registered","code":"1-6","from":"user_settings.php"}}
            error = SSErrorTypeEmailPasswordExist;
        }
        else if ([_code isEqualToString:@"28-3"]) {
            error = SSErrorTypeLikeBeforeUnlike;
        }
        else if ([_code isEqualToString:@"0"] && [_from isEqualToString:@"facebook_friends.php"]) {
            error = SSErrorTypeInvalidFacebookToken;
        }
        else if ([_code isEqualToString:@"1-1"]) {
            error = SSErrorTypeEmailValidationError;
        }
        else {
            error = SSErrorTypeBadRequest;
        }
        break;
    case 401:
        error = SSErrorTypeUnauthorized;
        break;
    case 403:
        if ([_code isEqualToString:@"1138"]) {
            error = SSErrorTypeAppVersionNotSupported;
        }
        else if ([_code isEqualToString:@"invalid_credentials"]) {
            error = SSErrorTypeUserCredentialsIncorrect;
        }
        else if ([_code isEqualToString:@"server_error"]) {
            error = SSErrorTypeServerError;
        }
        else if ([_code isEqualToString:@"temporarily_unavailable"]) {
            error = SSErrorTypeServerUnavailable;
        }
        else if ([_code isEqualToString:@"invalid_refresh"]) {
            error = SSErrorTypeInvalidRefreshToken;
        }
        else if ([_code isEqualToString:@"invalid_request"]) {
            error = SSErrorTypeInvalidRequest;
        }
        else if ([_code isEqualToString:@"37-8"]) {
            error = SSErrorTypeRestrictedUser;
        }
        else if ([_code isEqualToString:@"17"]) {
            error = SSErrorTypeBlacklistedUser;
        }
        else {
            error = SSErrorTypeForbidden;
        }
        break;
    case 404:
        error = SSErrorTypeNotFound;
        break;
    case 409:
        if ([_code isEqualToString:@"1-5"]) { //{"error":{"message":"Email\/Password exist","code":"1-5","from":"user_settings.php"}}
            error = SSErrorTypeEmailPasswordExist;
        }
        else {
            error = SSErrorTypeConflict;
        }
        break;
    case 500:
        error = SSErrorTypeServerError;
        break;
    case 503:
        error = SSErrorTypeServerUnavailable;
        break;
    case 504:
        error = SSErrorTypeServerUnavailable;
        break;
    default:
        error = SSErrorTypeUnknown;
        break;
    }
    return error;
}

- (SSErrorResolutionType)errorResolutionType
{
    SSErrorResolutionType resolutionType;
    switch (_errorType) {
    case SSErrorTypeBadRequest:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeUnauthorized:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeAppVersionNotSupported:
        resolutionType = SSErrorResolutionTypeRequestUpgradeAndBlock;
        break;
    case SSErrorTypeForbidden:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeNotFound:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeEmailPasswordExist:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeUserDoesNotExist:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeConflict:
        resolutionType = SSErrorResolutionTypeShowAlertAndContinue;
        break;
    case SSErrorTypeServerError:
        resolutionType = SSErrorResolutionTypeShowAlertAndContinue;
        break;
    case SSErrorTypeServerUnavailable:
        resolutionType = SSErrorResolutionTypeShowAlertAndContinue;
        break;
    case SSErrorTypeConnectionError:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeConnectionCancelled:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeNoNetwork:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeJSONParserError:
        resolutionType = SSErrorResolutionTypeShowAlertAndContinue;
        break;
    case SSErrorTypeDataModelError:
        resolutionType = SSErrorResolutionTypeShowAlertAndContinue;
        break;
    case SSErrorTypeOAuthGeneralError:
        resolutionType = SSErrorResolutionTypeForceLogin;
        break;
    case SSErrorTypeUserCredentialsIncorrect:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeInvalidRefreshToken:
        resolutionType = SSErrorResolutionTypeForceLogin;
        break;
    case SSErrorTypeInvalidRequest:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeRestrictedUser:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeBlacklistedUser:
        resolutionType = SSErrorResolutionTypeShowAlertAndContinue;
        break;
    case SSErrorTypeLikeBeforeUnlike:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeContentFilter:
        resolutionType = SSErrorResolutionTypeShowAlertAndContinue;
        break;
    case SSErrorTypeInvalidFacebookToken:
        resolutionType = SSErrorResolutionTypeHandleInApp;
        break;
    case SSErrorTypeEmailValidationError:
        resolutionType = SSErrorResolutionTypeShowAlertAndContinue;
        break;
            
    case SSErrorTypeVerifyAccount:
        resolutionType = SSErrorResolutionTypeShowAlertAndContinue;
            break;
    default:
        resolutionType = SSErrorResolutionTypeShowAlertAndContinue;
        break;
    }
    return resolutionType;
}

- (NSString*)localizedMessage
{

    NSString* localizedMessage;
    //if ([self.message isEmpty])
    {
      //  self.message = NSLocalizedString(@"error_message_generic", nil);
    }
    switch (self.errorType) {
    case SSErrorTypeBadRequest:
        localizedMessage = self.message;
        break;
   case SSErrorTypeVerifyAccount:
            localizedMessage = self.message;
            break;
    case SSErrorTypeUnauthorized:
        localizedMessage = NSLocalizedString(@"error_message_401", nil);
        break;
    case SSErrorTypeAppVersionNotSupported:
        localizedMessage = self.message;
        break;
    case SSErrorTypeForbidden:
        localizedMessage = self.message;
        break;
    case SSErrorTypeNotFound:
        localizedMessage = self.message;
        break;
    case SSErrorTypeEmailPasswordExist:
        localizedMessage = self.message;
        break;
    case SSErrorTypeUserDoesNotExist:
        localizedMessage = self.message;
        break;
    case SSErrorTypeConflict:
        localizedMessage = self.message;
        break;
    case SSErrorTypeServerError:
        localizedMessage = NSLocalizedString(@"error_message_500", nil);
        break;
    case SSErrorTypeServerUnavailable:
        localizedMessage = NSLocalizedString(@"error_message_503", nil);
        break;
    case SSErrorTypeConnectionError:
        localizedMessage = NSLocalizedString(@"error_message_connection_error", nil);
        break;
    case SSErrorTypeNoNetwork:
        localizedMessage = NSLocalizedString(@"error_message_no_network", nil);
        break;
    case SSErrorTypeJSONParserError:
        localizedMessage = NSLocalizedString(@"error_message_500", nil);
        break;
    case SSErrorTypeDataModelError:
        localizedMessage = NSLocalizedString(@"error_message_500", nil);
        break;
    case SSErrorTypeInvalidRefreshToken:
        localizedMessage = NSLocalizedString(@"error_message_401", nil);
        break;
    case SSErrorTypeOAuthGeneralError:
        localizedMessage = NSLocalizedString(@"error_message_500", nil);
        break;
    case SSErrorTypeContentFilter:
        localizedMessage = NSLocalizedString(@"error_behind_contentfilter", nil);
        break;
    case SSErrorTypeInvalidFacebookToken:
        localizedMessage = NSLocalizedString(@"error_invalid_facebook_token", nil);
        break;
    case SSErrorTypeEmailValidationError:
        localizedMessage = NSLocalizedString(@"invalid_email", nil);
        break;
    default:
        localizedMessage = self.message;
        break;
    }
    return localizedMessage;
}

- (NSString*)localizedTitle
{
    return NSLocalizedString(@"app_name", nil);
}

- (NSString*)debugDescription
{
    return [NSString stringWithFormat:@"Error: %@\nMessage: %@\nCode: %@\nFrom: %@", _nserror.localizedDescription, self.message, _code, _from];
}

- (NSDictionary*)properties
{
    NSMutableDictionary* props = [NSMutableDictionary new];
    [props addEntriesFromDictionary:@{
        @"server_code" : (_code ? _code : @""),
        @"server_message" : (self.message ? self.message : @""),
        @"from_script" : (_from ? _from : @"")
    }];
    if (_operation.response) {
        props[@"response"] = [_operation.response description];
        props[@"response_statuscode"] = [[NSNumber numberWithInteger:_operation.response.statusCode] stringValue];
        props[@"response_URL"] = [_operation.response.URL absoluteString];
    }
    if (_nserror) {
        props[@"description"] = _nserror.description;
        props[@"userinfo"] = (NSDictionary*)_nserror.userInfo.description;
    }
    props[@"user_message"] = [self localizedMessage];
    props[@"resolution_type"] = [self errorResolutionString];
    props[@"error_type"] = [self errorTypeString];
    return [props copy];
}

- (NSString*)errorResolutionString
{
    switch ([self errorResolutionType]) {
    case SSErrorResolutionTypeShowAlertAndContinue:
        return @"SSErrorResolutionTypeShowAlertAndContinue";
        break;
    case SSErrorResolutionTypeRequestUpgradeAndBlock:
        return @"SSErrorResolutionTypeRequestUpgradeAndBlock";
        break;
    case SSErrorResolutionTypeForceLogin:
        return @"SSErrorResolutionTypeForceLogin";
        break;
    default:
        return @"SSErrorResolutionTypeHandleInApp";
        break;
    }
}

- (NSString*)errorTypeString
{
    switch (self.errorType) {
    case SSErrorTypeUndefined:
        return @"SSErrorTypeUndefined";
        break;
    case SSErrorTypeUnknown:
        return @"SSErrorTypeUnknown";
        break;
    case SSErrorTypeBadRequest:
        return @"SSErrorTypeBadRequest";
        break;
    case SSErrorTypeUnauthorized:
        return @"SSErrorTypeUnauthorized";
        break;
    case SSErrorTypeForbidden:
        return @"SSErrorTypeForbidden";
        break;
    case SSErrorTypeNotFound:
        return @"SSErrorTypeNotFound";
        break;
    case SSErrorTypeConflict:
        return @"SSErrorTypeConflict";
        break;
    case SSErrorTypeEmailPasswordExist:
        return @"SSErrorTypeEmailPasswordExist";
        break;
    case SSErrorTypeUserDoesNotExist:
        return @"SSErrorTypeUserDoesNotExist";
        break;
    case SSErrorTypeServerError:
        return @"SSErrorTypeServerError";
        break;
    case SSErrorTypeServerUnavailable:
        return @"SSErrorTypeServerUnavailable";
        break;
    case SSErrorTypeAppVersionNotSupported:
        return @"SSErrorTypeAppVersionNotSupported";
        break;
    case SSErrorTypeConnectionCancelled:
        return @"SSErrorTypeConnectionCancelled";
        break;
    case SSErrorTypeConnectionError:
        return @"SSErrorTypeConnectionError";
        break;
    case SSErrorTypeNoNetwork:
        return @"SSErrorTypeNoNetwork";
        break;
    case SSErrorTypeJSONParserError:
        return @"SSErrorTypeJSONParserError";
        break;
    case SSErrorTypeDataModelError:
        return @"SSErrorTypeDataModelError";
        break;
    case SSErrorTypeRestrictedUser:
        return @"SSErrorTypeRestrictedUser";
        break;
    case SSErrorTypeBlacklistedUser:
        return @"SSErrorTypeBlacklistedUser";
        break;
    case SSErrorTypeLikeBeforeUnlike:
        return @"SSErrorTypeLikeBeforeUnlike";
        break;
    case SSErrorTypeOAuthGeneralError:
        return @"SSErrorTypeOAuthGeneralError";
        break;
    case SSErrorTypeUserCredentialsIncorrect:
        return @"SSErrorTypeUserCredentialsIncorrect";
        break;
    case SSErrorTypeInvalidRefreshToken:
        return @"SSErrorTypeInvalidRefreshToken";
        break;
    case SSErrorTypeInvalidRequest:
        return @"SSErrorTypeInvalidRequest";
        break;
    case SSErrorTypeContentFilter:
        return @"SSErrorTypeContentFilter";
        break;
    case SSErrorTypeEmailValidationError:
        return @"SSErrorTypeEmailValidationError";
        break;
    case SSErrorTypeInvalidFacebookToken:
        return @"SSErrorTypeInvalidFacebookToken";
        break;
    }
    return @"Type empty";
}

- (void)showAlertIfNeeded
{
    if (_errorShown)
        return;
    _errorShown = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        switch ([self errorResolutionType]) {
        case SSErrorResolutionTypeShowAlertAndContinue:
            [self showNormalAlert];
            break;
          default: {
#ifdef DEBUG
            if (_errorType != SSErrorTypeConnectionCancelled) {
                
                /*UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Debug info"
                                                                message:[self debugDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"ok_capital", nil)
                                                      otherButtonTitles:nil];
                [alert show];*/
            }
#endif
        } break;
        }
    });
    //VVLog(@"%@", [self debugDescription]);
}

- (void)showNormalAlert
{
/*
#ifdef DEBUG
    NSString* message = [NSString stringWithFormat:@"%@\n\nDebug info\n%@", [self localizedMessage], [self debugDescription]];
#else
    NSString* message = [self localizedMessage];
#endif
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[self localizedTitle] message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok_capital", nil) otherButtonTitles:nil];
    [alert show];*/
}
+(NSString*)getErrorMessage:(NSError*)error
{
    SSError *vverror = error.userInfo[kSSErrorObjectKey];
    return [vverror localizedMessage];
}

- (void)dealloc
{
    _nserror = nil;
}

@end
