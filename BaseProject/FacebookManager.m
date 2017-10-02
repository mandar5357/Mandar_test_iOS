//
//  FacebookManager.m
//  VivinoV2
//
//  Created by Sphinx Solution Pvt Ltd on 28/11/14.
//
//

#import "FacebookManager.h"
#import "NSObject+SimpleJson.h"
#import "Utility.h"


#define USED_GRAPH_API_VERSION @"v2.5"

@interface FacebookManager ()
@property(nonatomic,strong)  FBSDKLoginManager *fbSdkLoginMgr;
@property(nonatomic)BOOL isLoginWithFB,fbRequsetLock;

@end

@implementation FacebookManager


+ (FacebookManager *)sharedInstance {
    static FacebookManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FacebookManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (!self) {
        
        return nil;
    }
    
    _fbSdkLoginMgr = [[FBSDKLoginManager alloc] init];
     return self;
}



#pragma mark- SDK methods
/*
- (void)createfacebookinstance:(FacebookPermissionType)permissionType
                       success:(void (^)())success
                       failure:(void (^)())failure;
{
   NSSet *permissions = [FBSDKAccessToken currentAccessToken].permissions;
    SSLog(@">> %@ >>>",permissions);
    _fbSdkLoginMgr.loginBehavior=FBSDKLoginBehaviorSystemAccount;
    if (![permissions containsObject:@"publish_actions"] )
    {
        NSArray* _permisssion = nil;
        if (permissionType==FacebookPermissionTypeEmail)
            _permisssion = [NSArray arrayWithObject:@"email"];
        else if (permissionType==FacebookPermissionTypeEmailLocation )
            _permisssion = [NSArray arrayWithObjects:@"email", @"user_location", nil];
        else if (permissionType==FacebookPermissionTypePublishStream)
            _permisssion = [NSArray arrayWithObjects:nil];
        
       
        [self getFacebookReadPermissionWith:_permisssion andHandler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            SSLog(@"result %@  %@",result,result.grantedPermissions);
            if (error)
            {
                SSLog(@">> error %@ >>>",error);
                [self onLoginFailure:error];
            }
            else if (result.isCancelled)
            {
                // Handle cancellations
                SSLog(@">isCancelled " );
                [self onLoginFailure:nil];
            }
            else
            {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if ([result.grantedPermissions containsObject:@"email"])
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[FBSDKAccessToken currentAccessToken].tokenString forKey:@"FBAccessTokenKey"];
                    [self getFbUserDetailsWithSuccess:success failure:failure];
                }
                else
                {
                    if(success)
                        success();
                }
            }
        }];
    }
    else
    {
         [self getFbUserDetailsWithSuccess:success failure:failure];
    }
}

-(void)facebookManagerBecomeActive
{
    [FBSDKAppEvents activateApp];
   
}

-(NSString*)getFBAccessToken
{
    return  [FBSDKAccessToken currentAccessToken].tokenString;
    // return FBSession.activeSession.accessTokenData.accessToken;
}

-(void)logout
{
   
    [self.fbSdkLoginMgr logOut];
    
    NSUserDefaults *userdefault =[NSUserDefaults standardUserDefaults];
    [userdefault removeObjectForKey:@"FACEBOOK_USER"];
    [userdefault removeObjectForKey:@"FACEBOOK_ID"];
    [userdefault removeObjectForKey:@"FIRST_NAME_FACEBOOK"];
    [userdefault removeObjectForKey:@"LAST_NAME_FACEBOOK"];
    [userdefault removeObjectForKey:@"FACEBOOK_EMAIL"];
    
   
    [userdefault removeObjectForKey:@"IMAGE_URL_FACEBOOK"];
    [userdefault removeObjectForKey:@"FACEBOOK_USER_INFO_DONE"];
    
    [userdefault synchronize];
    
}


- (void)storeAuthData:(NSString*)accessToken expiresAt:(NSDate*)expiresAt
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}


+(BOOL)isFBSessionValid
{
    if([FBSDKAccessToken currentAccessToken])
        return YES;
    
    return NO;
}

- (void)fbDidLogout
{
    //VVLog(@"Facebook logout");
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbSessionInvalidated
{
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:SSLocalizedString(@"facebook_exception", nil)
                              message:SSLocalizedString(@"your_session_has_expired", nil)
                              delegate:nil
                              cancelButtonTitle:SSLocalizedString(@"ok", nil)
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    
    [self fbDidLogout];
}

#pragma mark- Helper methods

-(void)getFacebookReadPermissionWith:(NSArray*)permisssion andHandler:(FBSDKLoginManagerRequestTokenHandler)handler
{
    [self.fbSdkLoginMgr logInWithReadPermissions:permisssion handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
         handler(result, error);
        
    }];
}

-(void)getFacebookPublishPermissionHandler:(FBSDKLoginManagerRequestTokenHandler)handler
{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {

        handler(result, error);
    }];

}
-(void)onLoginFailure:( NSError *)error
{
    self.isLoginWithFB = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideProgreesViewForFBSessionStateClosedNotification object:nil];
    if(error)
        [self handleAuthReopenError:error withGraphObject:nil];
}

-(void)getFbUserDetailsWithSuccess:(void (^)())success
                       failure:(void (^)())failure;
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FACEBOOK_USER_INFO_DONE"] == nil)
    {
        //FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,email,birthday,first_name,gender,last_name" forKey:@"fields"];
   
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                [self FbUserDictionary:result];
                if(success)
                    success();
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME_TITLE message:error.localizedDescription  delegate:nil cancelButtonTitle:SSLocalizedString(@"ok", nil) otherButtonTitles:nil];
                [alertView show];
                
                if(failure)
                    failure();
        
            }
            
        }];
    }
    else
    {
          [self notifyControllers];
        if(success)
            success();
    }
}

- (void)FbUserDictionary:(NSDictionary*)info
{
    
  SSLog(@"here 1 %@",info);
    if ([Utility isEmpty:[info objectForKey:@"id"]] == NO) {
        NSString* friend_id = [NSString stringWithFormat:@"%@", [info objectForKey:@"id"]];
        [[NSUserDefaults standardUserDefaults] setObject:friend_id forKey:@"FACEBOOK_ID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        
        NSString* friend_pic = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", [info objectForKey:@"id"]];
        [[NSUserDefaults standardUserDefaults] setObject:friend_pic forKey:@"IMAGE_URL_FACEBOOK"];
    }
    
    NSString* first_name = @"";
    
    if ([Utility isEmpty:[info objectForKey:@"first_name"]] == NO) {
        first_name = [NSString stringWithString:[info objectForKey:@"first_name"]];
        [[NSUserDefaults standardUserDefaults] setObject:first_name forKey:@"FIRST_NAME_FACEBOOK"];
    }
    
    //VVLog(@"here 3");
    
    if ([Utility isEmpty:[info objectForKey:@"last_name"]] == NO) {
        NSString* last_name = [NSString stringWithString:[info objectForKey:@"last_name"]];
        NSString* USER = [NSString stringWithFormat:@"%@ %@", first_name, last_name];
        [[NSUserDefaults standardUserDefaults] setObject:USER forKey:@"FACEBOOK_USER"];
        [[NSUserDefaults standardUserDefaults] setObject:last_name forKey:@"LAST_NAME_FACEBOOK"];
    }
    
    
    //VVLog(@"here 5");
    if ([Utility isEmpty:[info objectForKey:@"email"]] == NO) {
        NSString* email = [info objectForKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"FACEBOOK_EMAIL"];
        
    }
    
    //gender
    if ([Utility isEmpty:[info objectForKey:@"gender"]] == NO) {
        NSString* gender = [info objectForKey:@"gender"];
        [[NSUserDefaults standardUserDefaults] setObject:gender forKey:@"FACEBOOK_GENDER"];
     }
    
    if ([info objectForKey:@"location"] != nil) {
        NSDictionary* dictlocation = [info objectForKey:@"location"];
        
        NSString* locationname = [dictlocation objectForKey:@"name"];
        if ([Utility isEmpty:locationname] == NO) {
            NSArray* lslocation = [locationname componentsSeparatedByString:@","];
            NSString* state = nil;
            if (lslocation.count != 0)
                state = [lslocation lastObject];
            
            if (state != nil) {
                state = [state stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[NSUserDefaults standardUserDefaults] setObject:state forKey:@"FACEBOOK_USER_STATE"];
                
            }
        }
    }

    [self notifyControllers];
}

-(void)notifyControllers
{
   
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FACEBOOK_USER_INFO_DONE"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    SSLog(@"<>>>>>>>>>>>>from %ld  self.fromController %ld",(long)self.from,(long)self.fromController);
  

}

- (void)connectWithFacebook
{
}

- (void)getNewFacebookPermissionComeFrom:(NSInteger)comefrom WithSuccess:(void (^)())success
                                 failure:(void (^)())failure
{
    if ([FacebookManager isFBSessionValid])
    {
        if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
            
            if (success)
                success();

            return;
        }
        
        // get pusblish permission
        if(_fbRequsetLock)//https://tickets.vivino.com/issues/10261
        {
            SSLog(@"Fb previous request already running");
            return;
        }
            
        _fbRequsetLock=YES;
        [self getFacebookPublishPermissionHandler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error) {
                // Handle errors
                [self handleAuthReopenError:error withGraphObject:nil];
                if(failure)
                    failure();
                
                _fbRequsetLock=NO;
                
            } else {
                // No error
               
                
                if(success)
                    success();
                
                _fbRequsetLock=NO;
                
            }

        }];
        
    }// eof if access tokem is available
    else
    {    //get the read permission
        self.from = comefrom;
        [self getFacebookReadPermissionWith:@[@"email"] andHandler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error || result.isCancelled || ![result.grantedPermissions containsObject:@"email"])
            {
               SSLog(@"error while getting email permission %@",error);
                [self handleAuthReopenError:error withGraphObject:nil];
                if(failure)
                    failure();

            }
            else
            {
                _fbRequsetLock=YES;
                [self getFacebookPublishPermissionHandler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                    
                    if (error) {
                        // Handle errors
                        SSLog(@"error while getting publish permission %@",error);

                        [self handleAuthReopenError:error withGraphObject:nil];
                        if(failure)
                            failure();
                        
                        _fbRequsetLock=NO;
                        
                    } else {
                        // No error
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[FBSDKAccessToken currentAccessToken].tokenString forKey:@"FBAccessTokenKey"];
                      
                        [self getFbUserDetailsWithSuccess:success failure:failure];
                        
                        
                        _fbRequsetLock=NO;
                        
                    }
                    
                }];
          
            }
            
        }];
    }
}


#pragma mark - Error handler
- (void)handleAuthReopenError:(NSError*)error  withGraphObject:(id)objGraph
{
    SSLog(@"facebook error msg %@", [error userInfo]);
    
    NSString* alertTitle = SSLocalizedString(@"facebook_error", nil);;
    NSString* alertText = @"";
    //NSInteger tag = FB_ERROR;
    
    if(error.userInfo[NSLocalizedDescriptionKey])
        alertText = error.userInfo[NSLocalizedDescriptionKey];
    
    
    
    FBSDKGraphRequestErrorCategory errorCategory = [error.userInfo[FBSDKGraphRequestErrorCategoryKey] integerValue];
    if (errorCategory == FBSDKGraphRequestErrorCategoryRecoverable)
    {
     //   tag  = FB_ERROR_RELOGIN;
    }
    else if (errorCategory == FBSDKGraphRequestErrorCategoryOther && error.userInfo[NSLocalizedRecoverySuggestionErrorKey] )
        alertText = error.userInfo[NSLocalizedRecoverySuggestionErrorKey];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:SSLocalizedString(@"ok", nil) otherButtonTitles:nil];
   // alertView.tag = tag;
    //alertView.error=error;
    [alertView show];
    
    
}
#pragma mark- Utility Methods
+(NSInteger)fbUsedBy
{
    return [FacebookManager sharedInstance].from;
}

+(BOOL)isFBAppInstalled
{
    BOOL fbIsInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    return  fbIsInstalled;
}


#pragma marks -- getters
+(NSString*)facebookId
{
    return [VVBaseUserDefaults getObjectForKey:@"FACEBOOK_ID"];
}

+(NSString*)facebookUserName
{
    return [VVBaseUserDefaults getObjectForKey:@"FACEBOOK_USER"];
}

+(NSString*)facebookFirstName
{
    return [VVBaseUserDefaults getObjectForKey:@"FIRST_NAME_FACEBOOK"];
}

+(NSString*)facebookLastName
{
    return [VVBaseUserDefaults getObjectForKey:@"LAST_NAME_FACEBOOK"];
}

+(NSString*)facebookFullName
{
    return [NSString stringWithFormat:@"%@ %@",[VVBaseUserDefaults getObjectForKey:@"FIRST_NAME_FACEBOOK"],[VVBaseUserDefaults getObjectForKey:@"LAST_NAME_FACEBOOK"]];

}

+(NSString*)facebookEmail
{
    return [VVBaseUserDefaults getObjectForKey:@"FACEBOOK_EMAIL"];
}

+(NSString*)facebookImageUrl
{
    return [VVBaseUserDefaults getObjectForKey:@"IMAGE_URL_FACEBOOK"];
}

+(NSString*)facebookVoinitPassword
{
  return md5([NSString stringWithFormat:@"fb%@%@", [FacebookManager facebookId],@"vointi"]);
}*/
@end
