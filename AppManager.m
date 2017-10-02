//
//  AppManager.m
//  SeatAParty
//
//  Created by anand mahajan on 10/03/15.
//  Copyright (c) 2015 anand mahajan. All rights reserved.
//
#import "AppManager.h"
#import "Constants.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import "JVFloatLabeledTextField.h"
#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Place.h"
#import "APNRegistrationHelpers.h"
static NSString *kSecretKey =@"C@bW@!@#$^&";

@implementation AppManager
@synthesize activity,currentLatLong,currentLocation,loggedinUserId,loggedinUserImage,loggedinUserName,loggedinUserEmail,loggedinUserFirstName,loggedinUserLastName;
@synthesize dictEventDetail,lsParseUsers,userHometown,selectedPanel;

static AppManager *sharedInstance = nil;

+ (AppManager *) sharedData
{
     static AppManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
 dispatch_once(&oncePredicate, ^{
     if (sharedInstance == nil) {
         // create shared data
         sharedInstance = [[self alloc]init];
     }
 });

    return sharedInstance;
}

#pragma mark Alert view
-(void)showHintView:(NSString *)text
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:SSLocalizedString(@"app_name", nil) message:text delegate:self cancelButtonTitle:SSLocalizedString(@"btn_ok", nil) otherButtonTitles:nil];
    [alert show];
}


-(UILabel *)createLableOnNavigation:(NSString *)lblTitle
{
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20, 30, 44)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.text = lblTitle;
    navLabel.textColor = [UIColor whiteColor];
    navLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-Demi" size:16.0];
   // navLabel.textAlignment = NSTextAlig;
    //[navLabel sizeToFit];

    //self.navigationItem.titleView = navLabel;
    return navLabel;
}
NSString* md5(NSString* concat)
{
    const char* concat_str = [concat UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (CC_LONG)strlen(concat_str), result);
    NSMutableString* hash = [NSMutableString string];
    for (NSInteger i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
#pragma mark - Check Network Availability



-(BOOL)isNetwokAvailable
{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if(networkStatus == NotReachable)
    {
        [[AppManager sharedData] showHintView:SSLocalizedString(@"error_message_no_network", nil)];
        return  NO;

    }
    else
        return YES;
    
    return NO;
}

+ (NSString *) md5:( NSString *)concat
{
    const char *concat_str = [concat UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

//+(void)setUserData: (User *)obj
//{
//    SSLog(@"obj.userId = %@",obj.userId);
//    
//    [VVBaseUserDefaults setCurrentUserId:[obj.userId integerValue]];
//    [VVBaseUserDefaults setString:obj.name forKey:keyDefaultsUserName];
//    [VVBaseUserDefaults setString:obj.email forKey:keyDefaultsUserEmail];
//    if (obj.phone != NULL) {
//        [VVBaseUserDefaults setString:obj.phone forKey:keyDefaultsUserPhone];
//    }
//    if (obj.profileImage != NULL) {
//        [VVBaseUserDefaults setString:obj.profileImage forKey:keyDefaultsUserProfilePic];
//    }
//    if (obj.socialImage != NULL) {
//        [VVBaseUserDefaults setString:obj.socialImage forKey:keyDefaultsUserSocialPic];
//    }
//    if (obj.socialId != NULL) {
//        [VVBaseUserDefaults setString:obj.socialId forKey:keyDefaultsUserSocialId];
//    }
//    if (obj.socialType != NULL) {
//        [VVBaseUserDefaults setString:obj.socialType forKey:keyDefaultsUserSocialType];
//    }
//    if (obj.isVerifiedUser != NULL) {
//        [VVBaseUserDefaults setString:obj.isVerifiedUser forKey:keyDefaultsUserIsVerified];
//    }
//}
+(void)setTintColor:(RNLoadingButton *)btn
{
    [btn setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite forState:UIControlStateNormal];
}

//+(User *)getUserData
//{
//    User *objUser = [[User alloc] init];
//    objUser.name = [VVBaseUserDefaults getStringForKey:keyDefaultsUserName];
//    objUser.userId = [VVBaseUserDefaults getStringForKey:keyDefaultsUserId];
//    objUser.email = [VVBaseUserDefaults getStringForKey:keyDefaultsUserEmail];
//    if ([VVBaseUserDefaults getStringForKey:keyDefaultsUserPhone] != NULL) {
//        objUser.phone = [VVBaseUserDefaults getStringForKey:keyDefaultsUserPhone];
//    }
//    if ([VVBaseUserDefaults getStringForKey:keyDefaultsUserProfilePic] != NULL) {
//        objUser.profileImage = [VVBaseUserDefaults getStringForKey:keyDefaultsUserProfilePic];
//    }
//    if ([VVBaseUserDefaults getStringForKey:keyDefaultsUserSocialId] != NULL) {
//        objUser.socialId = [VVBaseUserDefaults getStringForKey:keyDefaultsUserSocialId];
//    }
//    if ([VVBaseUserDefaults getStringForKey:keyDefaultsUserSocialPic] != NULL) {
//        objUser.socialImage = [VVBaseUserDefaults getStringForKey:keyDefaultsUserSocialPic];
//    }
//    if ([VVBaseUserDefaults getStringForKey:keyDefaultsUserSocialType] != NULL) {
//        objUser.socialType = [VVBaseUserDefaults getStringForKey:keyDefaultsUserSocialType];
//    }
//    if ([VVBaseUserDefaults getStringForKey:keyDefaultsUserIsVerified] != NULL) {
//        objUser.isVerifiedUser = [VVBaseUserDefaults getStringForKey:keyDefaultsUserIsVerified];
//    }
//    return objUser;
//}

#pragma custom method  for email format

-(BOOL)isValidEmail: (NSString *)txt
{
    //Email Validation
    NSString *regex1 = @"\\A[a-z0-9]+([-._][a-z0-9]+)*@([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,4}\\z";
    NSString *regex2 = @"^(?=.{1,64}@.{4,64}$)(?=.{6,100}$).*";
    NSPredicate *test1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate *test2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [test1 evaluateWithObject:txt] && [test2 evaluateWithObject:txt];
    
}

+(NSString*)getLocationStrFromPlaceMarker:(CLPlacemark*)placemark
{
    NSMutableString *str = [NSMutableString new];
//    placemark.thoroughfare, placemark.locality,
//    placemark.administrativeArea,
//    placemark.country
    if(![[AppManager sharedData] isEmpty:placemark.thoroughfare])
    {
        [str appendString:placemark.thoroughfare];
    }
    
   if(![[AppManager sharedData] isEmpty:placemark.subThoroughfare])
    {
        if(str.length>0)
            [str appendString:@", "];
        
        [str appendString:placemark.subThoroughfare];
        
    }
    if(![[AppManager sharedData] isEmpty:placemark.subLocality])
    {
        if(str.length>0)
            [str appendString:@", "];
        
        [str appendString:placemark.subLocality];
        
    }

    if(![[AppManager sharedData] isEmpty:placemark.locality])
    {
        if(str.length>0)
            [str appendString:@", "];
        
        [str appendString:placemark.locality];

    }
    
    if(![[AppManager sharedData] isEmpty:placemark.administrativeArea])
    {
        if(str.length>0)
            [str appendString:@", "];

        [str appendString:placemark.administrativeArea];
    }
    
    if(![[AppManager sharedData] isEmpty:placemark.country])
    {
        if(str.length>0)
            [str appendString:@", "];

        [str appendString:placemark.country];
    }
    return [str copy];
}

+(NSString*)getLocationName:(CLPlacemark*)placemark
{
    NSMutableString *str = [NSMutableString new];
   
    if(![[AppManager sharedData] isEmpty:placemark.subLocality])
    {
        if(str.length>0)
            [str appendString:@", "];
        
        [str appendString:placemark.subLocality];
        
    }
    
    if(![[AppManager sharedData] isEmpty:placemark.locality])
    {
        if(str.length>0)
            [str appendString:@", "];
        
        [str appendString:placemark.locality];
    }
    return [str copy];
}

#pragma GetServiceType form ServiceName

+(ServiceLoginType)getServiceTypeWithServiceName:(NSString*)str
{
    str=[str lowercaseString];
    if([str isEqualToString:@"mega"])
    {
        return ServiceLoginTypeMEGACAB;
    }
    if([str isEqualToString:@"ola"])
    {
        return ServiceLoginTypeOLA;
    }
    if([str isEqualToString:@"meru"])
    {
        return ServiceLoginTypeMERU;
    }
    if([str isEqualToString:@"tabcab"])
    {
        return ServiceLoginTypeTABCAB;
    }
    else
        return ServiceLoginTypeEASYCAB;
}

#pragma mark -
#pragma mark - Facebook API integration
#pragma mark -

/*-(BOOL)isFBSessionValid
{
    if(FBSession.activeSession.isOpen)
        return YES;
    else
        return NO;
}

-(void)signInWithFacebook
{
    if (![self isFBSessionValid])
    {
        [self createfacebookinstance:1];
    }
    else
    {
        if (FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            
            [FBSession.activeSession closeAndClearTokenInformation];
            [self signInWithFacebook];
        }
    }
}

-(void) createfacebookinstance:(int)permissionType
{
   // if (FBSession.activeSession.isOpen==NO  || [ FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound)
    {
        [self openSessionWithAllowLoginUI:YES forPermission:permissionType];
    }
    
}
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI forPermission:(int)permissionType
{
    BOOL openSessionResult = NO;
    
    NSArray *_permisssion=nil;
        _permisssion=[NSArray arrayWithObjects:@"email",nil];
    
    FBSession *session = [[FBSession alloc] initWithAppID:nil
                                              permissions:_permisssion
                                          urlSchemeSuffix:nil
                                       tokenCacheStrategy:nil];
    
    if (allowLoginUI || session.state == FBSessionStateCreatedTokenLoaded)
    {
        if (session.state == FBSessionStateCreatedTokenLoaded) {
        }
        
        [FBSession setActiveSession:session];
        
        [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
                completionHandler:^(FBSession *session,
                                    FBSessionState state,
                                    NSError *error)
         {
             
             [self sessionStateChanged:session
                                 state:state
                                 error:error permission:permissionType];
             
         }];
        openSessionResult = session.isOpen;
    }
    return openSessionResult;
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error permission:(int)permissionType
{
    switch (state) {
            
        case FBSessionStateOpen: {
            
            [[NSUserDefaults standardUserDefaults] setObject:FBSession.activeSession.accessTokenData.accessToken forKey:@"FBAccessTokenKey"];
//            
          //  if([[NSUserDefaults standardUserDefaults] boolForKey:@"FACEBOOK_USER_INFO_DONE"]==NO)
            {
                [[FBRequest requestForMe] startWithCompletionHandler:
                 ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                     if (!error) {
                         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FACEBOOK_USER_INFO_DONE"];
                         [self FbUserDictionary:user];
                     }
                     else
                     {
                         
                         NSString *errorString = [NSString stringWithFormat:@"%@",[error userInfo]];
                         //NSLog(@"%@",errorString);
                         
                         if ([errorString rangeOfString:@"The Internet connection appears to be offline"].location == NSNotFound) {
                             
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             [alertView show];
                             [[NSNotificationCenter defaultCenter]postNotificationName:@"ENEBLE_FB_BUTTON" object:nil];

                         }
                         
                         
                     }
                     
                 }];
            }
            
            break;
        }
        case FBSessionStateClosed:
        {
            //NSLog(@"facebook FBSessionStateClosed");
            // Close the active session
            //[FBSession.activeSession closeAndClearTokenInformation];
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ENEBLE_FB_BUTTON" object:nil];

            break;
            
        }
        case FBSessionStateClosedLoginFailed: {
            // Handle the logged out scenario
            //NSLog(@"facebook FBSessionStateClosedLoginFailed");
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ENEBLE_FB_BUTTON" object:nil];
            [[AppManager sharedData] showHintView:@"Facebook login failed. Please try again."];
            // You may wish to show a logged out view
            
            break;
        }
        default:
            break;
            
    }
    
    
    if (error) {
        
        //NSLog(@"]]]]]]] %@",error);
        [self handleAuthReopenError:error];
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ENEBLE_FB_BUTTON" object:nil];

    }
}

-(void)getFbUserDetails
{
    //if([NSUSERDEFAULT objectForKey:@"FACEBOOK_USER_INFO_DONE"]==nil)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 
                 [self FbUserDictionary:user];
             }
             
         }];
    }
}

#pragma mark - Facebook login response dictionary

- (void)FbUserDictionary:(NSDictionary*)dict
{
    NSLog(@"FB DIC===>%@",dict);
    for (id key in dict)
    {
        id value = [dict objectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"id"] forKey:FACEBOOK_ID];
    [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"email"] forKey:FACEBOOK_EMAIL];
    [SVProgressHUD dismiss];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"FB_LOGIN_SUCCESS" object:nil userInfo:dict];
}


#pragma mark - Facebook Login error handle
- (void)handleAuthReopenError:(NSError *)error{
    
    NSString *alertMessage = nil, *alertTitle = nil;
    ////NSLog(@"facebook error %@",error);
    //NSLog(@"facebook error %@",[error userInfo]);
    
    
    
    if (error.fberrorShouldNotifyUser) {
        if ([[error userInfo][FBErrorLoginFailedReason]
             isEqualToString:FBErrorLoginFailedReasonSystemDisallowedWithoutErrorValue]) {
            // Show a different error message
            alertTitle = @"App Disabled";
            alertMessage = @"Go to Settings > Facebook and turn ON SeatAParty.";
            // Perform any additional customizations
        } else {
            // If the SDK has a message for the user, surface it.
            alertTitle = @"Something Went Wrong";
            alertMessage = error.fberrorUserMessage;
        }
    }
    else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        NSInteger underlyingSubCode = [[error userInfo]
                                       [@"com.facebook.sdk:ParsedJSONResponseKey"]
                                       [@"body"]
                                       [@"error"]
                                       [@"error_subcode"] integerValue];
        if (underlyingSubCode == 458) {
            alertTitle = @"Something Went Wrong";
            alertMessage = @"The app was removed. Please log in again.";
        } else {
            alertTitle = @"Something Went Wrong";
            alertMessage = @"Your current session is no longer valid. Please log in again.";
        }
    }
    else if(error.fberrorCategory == FBErrorCategoryPermissions){
        
        
        //NSLog(@"%@",error);
        
    }
    else if (error.fberrorCategory == FBErrorCategoryServer){
        
        //NSLog(@"%@",error);
    }
    else if (error.fberrorCategory == FBErrorCategoryUserCancelled){
        
        alertMessage = @"you have cancelled the require permission";
    }
    if (alertMessage)
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:APP_TITLE message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerView show];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:APP_TITLE message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerView show];
    }
    
    //NSLog(@"*******\n error.localizedRecoverySuggestion = %@ \nerror.localizedFailureReason = %@ \n error.localizedDescription = %@ ",error.localizedRecoverySuggestion,error.localizedFailureReason, error.localizedDescription);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FACEBOOK_LOGIN_FAIL" object:nil];
    
}


#pragma mark -
#pragma mark - ACAccount For Facebook Account

-(void)accountChanged:(NSNotification *)notif//no user info associated with this notif
{
    [self attemptRenewCredentials];
}

-(void)obtainAccessToAccounts
{
    ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *key = @"321628264694852";
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"email"],ACFacebookPermissionsKey,@[@"publish_stream"],ACFacebookPermissionsKey, nil];
    
    
    [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *e) {
         if (granted) {
             NSArray *accounts = [self.accountStore accountsWithAccountType:FBaccountType];
             //it will always be the last object with single sign on
             self.facebookAccount = [accounts lastObject];
             //NSLog(@"facebook account =%@",self.facebookAccount);
             [self attemptRenewCredentials];
         } else {
             //Fail gracefully...
             //NSLog(@"error getting permission %@",e);
             
         }
     }];
    
}

-(void)attemptRenewCredentials{
    [self.accountStore renewCredentialsForAccount:(ACAccount *)self.facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error){
        if(!error)
        {
            switch (renewResult) {
                case ACAccountCredentialRenewResultRenewed:
                    
                    //NSLog(@"Good to go");
                    break;
                case ACAccountCredentialRenewResultRejected:
                    //NSLog(@"User declined permission");
                    break;
                case ACAccountCredentialRenewResultFailed:
                    //NSLog(@"non-user-initiated cancel, you may attempt to retry");
                    break;
                default:
                    break;
            }
            
        }
        else{
            //handle error gracefully
            //NSLog(@"error from renew credentials%@",error);
        }
    }];
    
    
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark Remove Social Session

- (void)fbDidLogout {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBExpirationDateKey"];
    
}
-(void)removeFacebookSession
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FACEBOOK_ID];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:FACEBOOK_EMAIL];
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    }
    
    [self fbDidLogout];
}*/


-(BOOL)isEmpty:(NSString *)str
{
    if(str.length==0)
        return YES;
    return NO;
}


-(NSString *)getStringFromDate :(NSDate *)date withFormat:(NSString *)frmt
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:frmt];
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
    return stringFromDate;
}

-(NSDate *)getDateFromString:(NSString *)strdate withFormat:(NSString *)frmt
{
    NSDate *dt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:frmt];
    dt = [dateFormatter dateFromString:strdate];
    return dt;
    
}

-(NSString *)getDateInStringFromString:(NSString *)str withCurrentFormat:(NSString *)currentFrmt withExpectedFrmt:(NSString *)expctedFrmt
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:currentFrmt];
    NSDate *date = [dateFormatter dateFromString:str];
    [dateFormatter setDateFormat:expctedFrmt];
    NSString  *steDate = [dateFormatter stringFromDate:date];
    return steDate;
}

-(NSDate *)getDateFromString:(NSString *)str withCurrentFormat:(NSString *)currentFrmt withExpectedFrmt:(NSString *)expctedFrmt
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:currentFrmt];
    NSDate *date = [dateFormatter dateFromString:str];
    [dateFormatter setDateFormat:expctedFrmt];
    NSString  *steDate = [dateFormatter stringFromDate:date];
    NSDate *returnDate=[dateFormatter dateFromString:steDate];
    return returnDate;
}


#pragma mark fetch current lat and long
//-(void)fetchCurrentLatLong
//{
//    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
//        if (!error) {
//           // [SVProgressHUD showInfoWithStatus:@"Fetching current location..."];
//            [self reverseGeocodeLocationForLattitude:geoPoint.latitude ForLongitude:geoPoint.longitude];
//        }
//        else
//        {
//            [PFUIAlertView showAlertViewWithTitle:APP_TITLE
//                                          message:@"Oops! Unable to fetch your current location... Go to Settings > Locationist and ALLOW LOCATION ACCESS."
//                                cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok")];
//            
//            [SVProgressHUD dismiss];
//        }
//    }];
//    
//}
#pragma mark fetch location from current lat and long
//-(void) queryGooglePlaces: (NSString *) googleType  ForLattitude:(double) lattitude ForLongitude:(double) longitude
//{
//    // Build the url string to send to Google. NOTE: The kGOOGLE_API_KEY is a constant that should contain your own API key that you obtain from Google. See this link for more info:
//    // https://developers.google.com/maps/documentation/places/#Authentication
//    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", lattitude, longitude, @"10", @"", KGOOGLE_PLACES_API_KEY];
//    
//    //Formulate the string as a URL object.
//    NSURL *googleRequestURL=[NSURL URLWithString:url];
//    
//    // Retrieve the results of the URL.
//    
//    dispatch_async(dispatch_get_main_queue(), ^(void){
//        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
//        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
//
//    });
//   }

//-(void)fetchedData:(NSData *)responseData {
//    //parse out the json data
//    NSError* error;
//    NSDictionary* json = [NSJSONSerialization
//                          JSONObjectWithData:responseData
//                          
//                          options:kNilOptions
//                          error:&error];
//    
//    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
//    NSArray* places = [json objectForKey:@"results"];
//    
//    //Write out the data to the console.
//    NSLog(@"Google Data: %@", places);
//}
//- (void) reverseGeocodeLocationForLattitude:(CLLocation *)location
//{
//    double lattitude=location.coordinate.latitude;
//    double longitude=location.coordinate.longitude;
//    
//    if (! geocoder)
//        geocoder = [[CLGeocoder alloc] init];
//    
//   // CLLocation *location = [[CLLocation alloc] initWithLatitude:lattitude longitude:longitude];
//    
//    [geocoder reverseGeocodeLocation:location completionHandler: ^(NSArray* placemarks, NSError* error)
//          {
//         NSString *strLocation=nil;
//
//         if ([placemarks count] > 0)
//         {
//             if (! error)
//             {
//                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                 NSLog(@";;;;;%@",placemark.name);
//                 NSLog(@";;;;;%@",placemark.addressDictionary);
//                 NSLog(@"location;;;;;%f  %f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
//                 NSLog(@"location:%@",[placemark.addressDictionary valueForKey:@"City"]);
//                 [SVProgressHUD dismiss];
//                   strLocation=[placemark.addressDictionary valueForKey:@"City"];
//                 
//                 
//                 
//                 [[NSUserDefaults standardUserDefaults] setValue:strLocation forKey:@"USER_CURRENT_LOCATION"];
//                 [[NSUserDefaults standardUserDefaults]synchronize];
//                 
//                /* NSDictionary* dict = [NSDictionary dictionaryWithObject:strLocation forKey:@"locationName"];
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATION" object:nil userInfo:dict];*/
//
//             }
//             else
//             {
//                 [[AppManager sharedData] showHintView:@"Oops! Unable to fetch your current location... Go to Settings > Locationist and ALLOW LOCATION ACCESS."];
//                [SVProgressHUD dismiss];
//             }
//         }
//              }];
//    
//
//}
#pragma GetAttributedString

-(NSMutableAttributedString *)getAttributedString: (NSString *)str
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttribute:NSUnderlineStyleAttributeName
                         value:[NSNumber numberWithInt:1]
                         range:NSMakeRange(0, [attributeStr length])];
    
    [attributeStr addAttribute:NSUnderlineColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributeStr.length)];
    return attributeStr;
}

#pragma marks --Files related functions

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString*)path
{
    NSURL *URL = [NSURL fileURLWithPath:path];
    return [self addSkipBackupAttributeToItemAtFileURL:URL];
}

// From https://developer.apple.com/library/ios/qa/qa1719/_index.html
+(BOOL)addSkipBackupAttributeToItemAtFileURL:(NSURL*)URL
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]) {
        NSError *error = nil;
        BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                      forKey:NSURLIsExcludedFromBackupKey error:&error];
        if(!success){
           SSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        else
        {
            SSLog(@"NSURLIsExcludedFromBackupKey flag successfully set %@",[URL lastPathComponent]);
        }
        return success;
    }
    SSLog(@"Error excluding %@ from backup. File does not exist", [URL lastPathComponent]);
    return NO;
}

+(NSString *)getCacheDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
}

+(void)createApplicationSupportDirectory
{
    // store in /Library/Application Support/BUNDLE_IDENTIFIER/Reference
    // make sure Application Support folder exists
    NSError *error=nil;
    [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                           inDomain:NSUserDomainMask
                                  appropriateForURL:nil
                                             create:YES
                                              error:&error];
    if (error) {
        SSLog(@"KCDM: Could not create application support directory. %@", error);
        return;
    }
    
}

#pragma Trimming String
+(NSString *)trimString: (NSString *)str
{
    return [[str description] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(void)setDecorationForTextField:(JVFloatLabeledTextField*)textfield
{
    textfield.font = FONT_Next_LTPro_H7;
    textfield.floatingLabelActiveTextColor=UICOLOR_PLACEHOLDER_ACTIVE;
    textfield.floatingLabelTextColor=UICOLOR_PLACEHOLDER_ACTIVE;
    textfield.floatingLabelFont = FONT_Next_LTPro_H00;
    textfield.floatingLabelYPadding = 0;
    textfield.backgroundColor=[UIColor clearColor];
}

//-(void)logOut
//{
//    [VVBaseUserDefaults setCurrentUserId:0];
//    [VVBaseUserDefaults setPickUpLocation:[Place new]];
//    [VVBaseUserDefaults setDropOffLocation:[Place new]];
//    [[OlaEngine sharedEngine] logout];
//    [[GIDSignIn sharedInstance] signOut];
//    if ([[Twitter sharedInstance] session])
//    {
//        [[Twitter sharedInstance] logOut];
//    }
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    if ( [FBSDKAccessToken currentAccessToken] ){
//        [login logOut];
//    }
//    
//    [APNRegistrationHelpers clearTokenFromDefaults];
//}

+(void)setTextField:(UITextField*)textfield
{
    textfield.font = FONT_Next_LTPro_H7;
    textfield.backgroundColor=[UIColor whiteColor];
}

- (BOOL)validatePhone:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"^((\\+)|[7-9])[0-9]{9,10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    SSLog(@"Here= %d",[phoneTest evaluateWithObject:phoneNumber]);
    return [phoneTest evaluateWithObject:phoneNumber];
}

#pragma marks -- UI Elements
+(UIImageView*)logoForNavigation
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
}


+(NSUInteger)getLRMarginForXFPageWithTitleArr:(NSArray*)arrTitles
{
    CGFloat width = 0;
    for (NSString *title in arrTitles) {
        CGFloat temwidth =[title VVSizeWithFont:FONT_Next_LTPro_H8].width-6;
        //  MMLog(@"title width %f",temwidth);
        
        width+=temwidth;
    }
    CGFloat remaning_width =SCREEN_SIZE.width -width;
    return (NSUInteger) round(remaning_width/(2*[arrTitles count]));
}
@end
