//
//  FacebookManager.h
//  VivinoV2
//
//  Created by Sphinx Solution Pvt Ltd on 28/11/14.
//
//

#import <Foundation/Foundation.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@class FBInvitesDialogParams;

@interface FacebookManager : NSObject
@property(nonatomic) NSInteger from, fromController;

+ (FacebookManager *)sharedInstance;
/*
#pragma marks--Facebok Instance Create Methods
- (void)createfacebookinstance:(FacebookPermissionType)permissionType
                       success:(void (^)())success
                       failure:(void (^)())failure;
-(void)connectWithFacebook;
-(void) facebookManagerBecomeActive;
-(void)getNewFacebookPermissionComeFrom:(NSInteger)comefrom
                            WithSuccess:(void (^)())success
                                failure:(void (^)())failure;

#pragma marks--Access Token Related Methods
-(NSString*)getFBAccessToken;
-(void) storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt;
-(void)logout;
+(BOOL)isFBSessionValid;
+(BOOL)isFBAppInstalled;


#pragma marks-Sharing Methods
- (void)FbUserDictionary:(NSDictionary*)result;

#pragma marks-Utility Methods
+(NSInteger)fbUsedBy;


#pragma marks -- getters
+(NSString*)facebookId;
+(NSString*)facebookUserName;
+(NSString*)facebookFirstName;
+(NSString*)facebookLastName;
+(NSString*)facebookFullName;
+(NSString*)facebookEmail;
+(NSString*)facebookImageUrl;

//get voniti hard code password for fb users
+(NSString*)facebookVoinitPassword;
 */
@end
