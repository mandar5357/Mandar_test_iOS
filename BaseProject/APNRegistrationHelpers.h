//
//  APNRegistrationHelpers.h
//  VivinoV2
//
//  Created by Kasper Weibel Nielsen-Refs on 22/11/13.
//
//

#import <Foundation/Foundation.h>

@interface APNRegistrationHelpers : NSObject

+ (APNRegistrationHelpers *)sharedInstance;
+ (void)applicationDidFinishLaunching:(UIApplication *)application;
+ (void)registerForAPN;
+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;
+ (void)didFailToRegisterForRemoteNotifications;
+ (NSData*)deviceToken;
+ (NSString*)deviceTokenString;
+ (NSString*)deviceTokenStringFromDefaults;
+ (void)clearTokenFromDefaults;
@end
