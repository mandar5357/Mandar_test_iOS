//
//  APNRegistrationHelpers.m
//  VivinoV2
//
//  Created by Kasper Weibel Nielsen-Refs on 22/11/13.
//
//

#import "APNRegistrationHelpers.h"

NSString* const kLifetimeRegistrationsKey = @"lifetimeAPNRegistrations";

NSString* const kANSRegistrationsPUSHTOKENKey = @"kANSRegistrationsPUSHTOKENKey";

@interface APNRegistrationHelpers ()

@property (nonatomic, strong) NSData* deviceToken;
@property (nonatomic) NSInteger apnRequestsSent;

@end

@implementation APNRegistrationHelpers

+ (APNRegistrationHelpers*)sharedInstance
{
    static APNRegistrationHelpers* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[APNRegistrationHelpers alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init
{
    if(!(self = [super init]))
        return nil;
    
    _apnRequestsSent = 0;
    
    return self;
}

+ (void)applicationDidFinishLaunching:(UIApplication*)application
{
    //VVLog(@"");
    [[self sharedInstance] applicationDidFinishLaunching:application];
}

+ (void)registerForAPN
{
    //VVLog(@"");
    [[self sharedInstance] registerForAPN];
}

+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [[self sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

+ (void)didFailToRegisterForRemoteNotifications
{
    [[self sharedInstance] didFailToRegisterForRemoteNotifications];
}

+ (NSData*)deviceToken
{
    return [self sharedInstance].deviceToken;
}

+ (NSString*)deviceTokenString
{
    return [[self sharedInstance] deviceTokenString];
}

// private interface

- (void)applicationDidFinishLaunching:(UIApplication*)application
{
    BOOL APNPreviouslyRegistered = [VVBaseUserDefaults getIntForKey:kLifetimeRegistrationsKey] > 0;
    // re-register if previosuly registered
    if (APNPreviouslyRegistered)
    {
        [self registerForAPN];
    }
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    _deviceToken = deviceToken;
    [VVBaseUserDefaults setString:[self deviceTokenString] forKey:kANSRegistrationsPUSHTOKENKey];
    _apnRequestsSent --;
}

- (void)didFailToRegisterForRemoteNotifications
{
    _apnRequestsSent --;
}

- (NSString*)deviceTokenString
{
    if (!_deviceToken)
        return nil;

    const unsigned* tokenBytes = [_deviceToken bytes];
    NSString* token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                                ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                                ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                                ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    return token;
}
+ (NSString*)deviceTokenStringFromDefaults
{
    return [VVBaseUserDefaults getStringForKey:kANSRegistrationsPUSHTOKENKey];
}
+ (void)clearTokenFromDefaults
{
    [VVBaseUserDefaults setString:@"" forKey:kANSRegistrationsPUSHTOKENKey];
}

/**
 *
 * For push notification permissions, if the user has not granted, or denied the permission (for the push token) then ask for it the first time the user goes into a label scanning flow, at the time when the user is shown the progress messages ("Uploading", "Hang on there").
 */
- (void)registerForAPN
{
    // only ask to register if we
    // 1) already have a userid from the vivino server
    // 2) and we don't already have a token for this session
    // 3) and we don't have any pending requests
    if ([[VVBaseUserDefaults getCurrentUserId] integerValue] > 0 && _deviceToken == nil && _apnRequestsSent == 0) {
        _apnRequestsSent ++;
        
        SSLog(@"registerForAPN");
        [self registerUserNotificationSetting];
    }
}


- (void)registerUserNotificationSetting
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS7 and below
                SSLog(@"registerUserNotificationSetting IOS 7");
        UIRemoteNotificationType myTypes = [self types_7];
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    else {
        // iOS8+
      /*  UIMutableUserNotificationAction* ignoreAction = [[UIMutableUserNotificationAction alloc] init];
        ignoreAction.identifier = @"ignoreAction";
        ignoreAction.activationMode = UIUserNotificationActivationModeBackground;
        ignoreAction.title = VVLocalizedString(@"ignore", nil);
        ignoreAction.destructive = YES;

        UIMutableUserNotificationAction* acceptAction = [[UIMutableUserNotificationAction alloc] init];
        acceptAction.identifier = @"acceptAction";
        acceptAction.activationMode = UIUserNotificationActivationModeBackground;
        acceptAction.title = VVLocalizedString(@"accept", nil);

        UIMutableUserNotificationCategory* category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier = @"FOLLOW_REQUEST";
        [category setActions:@[ ignoreAction, acceptAction ] forContext:UIUserNotificationActionContextDefault];*/

        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:[self types_8]
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (UIUserNotificationType)types_8
{
    return UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
}

- (UIRemoteNotificationType)types_7
{
    return UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
}

@end
