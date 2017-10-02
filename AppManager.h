//
//  AppManager.h
//  SeatAParty
//
//  Created by anand mahajan on 10/03/15.
//  Copyright (c) 2015 anand mahajan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIActivityIndicatorView.h>
#import <UIKit/UIKit.h>
#import <RNLoadingButton.h>
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>
#import <MapKit/MapKit.h>
@class JVFloatLabeledTextField;
@interface AppManager : NSObject
{
    BOOL isReachable;
    CLGeocoder* geocoder;
}

@property (nonatomic, strong) UIActivityIndicatorView * activity;

@property (nonatomic,strong) NSString *loggedinUserId;
@property (nonatomic,strong) NSString *loggedinUserImage;
@property (nonatomic,strong) NSString *loggedinUserName;
@property (nonatomic,strong) NSString *loggedinUserEmail;
@property (nonatomic,strong) NSString *loggedinUserFirstName;
@property (nonatomic,strong) NSString *loggedinUserLastName;

@property (nonatomic,retain) NSMutableDictionary *dictEventDetail;
@property (nonatomic,retain)NSArray *lsParseUsers;
@property (nonatomic) CLLocationCoordinate2D currentLatLong;
@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic,retain) NSString *userHometown;
@property (nonatomic) NSInteger selectedPanel;

+ (AppManager *) sharedData;

// Activity indicator
-(void)AddCustomUIActivityIndicatorView;
-(void)RemoveCustomUIActivityIndicatorView;

// Alert view
-(void)showHintView:(NSString *)text;
NSString* md5(NSString* concat);
- (BOOL)isNetwokAvailable;

-(UILabel *)createLableOnNavigation:(NSString *)lblTitle;

+ (NSString *) md5:( NSString *)concat;
-(BOOL)isValidEmail: (NSString *)txt;

- (BOOL)validatePhone:(NSString *)phoneNumber;

-(void)logOut;

// get event type
-(NSString *)getEventType;

+(void)setDecorationForTextField:(JVFloatLabeledTextField*)textfield;
+(void)setTextField:(UITextField*)textfield;
+(void)setTintColor:(RNLoadingButton *)btn;


#pragma mark - Facebook methods
-(void)obtainAccessToAccounts;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI forPermission:(int)permissionType;
-(BOOL)isFBSessionValid;
-(void)signInWithFacebook;
-(void) fbDidLogout;
-(void)removeFacebookSession;

+(ServiceLoginType)getServiceTypeWithServiceName:(NSString*)str;

// get event price
-(NSString *)getEventPrice;

-(BOOL)isEmpty:(NSString *)str;

// NSDate
-(NSDate *)getDateFromString:(NSString *)strdate withFormat:(NSString *)frmt;
-(NSString *)getStringFromDate :(NSDate *)date withFormat:(NSString *)frmt;
-(NSString *)getDateInStringFromString:(NSString *)str withCurrentFormat:(NSString *)currentFrmt withExpectedFrmt:(NSString *)expctedFrmt;
-(NSDate *)getDateFromString:(NSString *)str withCurrentFormat:(NSString *)currentFrmt withExpectedFrmt:(NSString *)expctedFrmt;

-(void) queryGooglePlaces: (NSString *) googleType  ForLattitude:(double) lattitude ForLongitude:(double) longitude;

-(NSMutableAttributedString *)getAttributedString: (NSString *)str;
+(NSString *)trimString: (NSString *)str;
//
//+(void)setUserData: (User *)obj;
//+(User *)getUserData;

-(void)fetchCurrentLatLong;
-(UIButton *)setCustomBackButtonOnNavigation;
+(NSString*)getLocationStrFromPlaceMarker:(CLPlacemark*)placemark;
+(NSString*)getLocationName:(CLPlacemark*)placemark;

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString*)path;
// From https://developer.apple.com/library/ios/qa/qa1719/_index.html
+(BOOL)addSkipBackupAttributeToItemAtFileURL:(NSURL*)URL;
+(NSString *)getCacheDirectoryPath;

+(void)createApplicationSupportDirectory;
#pragma mark reverseGeocode
- (void) reverseGeocodeLocationForLattitude:(CLLocation *)location;

#pragma marks -- UI Elements
+(UIImageView*)logoForNavigation;

+(NSUInteger)getLRMarginForXFPageWithTitleArr:(NSArray*)arrTitles;

@end
