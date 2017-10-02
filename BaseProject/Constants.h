

#ifndef SS_Constants_h
#define SS_Constants_h

#import "AppDelegate.h"



#define UIAppDelegate \
                    ((AppDelegate *)[UIApplication sharedApplication].delegate)


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define APP_NAME [[[NSBundle mainBundle] localizedInfoDictionary]objectForKey:@"CFBundleDisplayName"]

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define NAVIGATION_HEIGHT 64


#define APP_NAME_TITLE @"CabWala"

#define CURRENCY_SYMBOL @"₹"
#define DISTANCE_KM @"Km"

const static CGFloat defaultLat = 12.9738;
const static CGFloat defaultLng = 77.6119;

#define DATABASE_NAME @"CabWala.sqlite"

static NSString* const kFbGraphPictureLink = @"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1";

#define KSocialMediaFB         3000
#define KEY_DEVICE_TOKEN                       @"deviceToken"
#define UBER_CLIENT_ID @"0XYN1gFgn_Dplqyukp5dBjJWibxcpA8k"
static const CGFloat maxCabFair = 99999999;


static NSString *kDateFormatTypeBasic = @"dd-MM-yyyy";
static NSString *kDateFormatTypeFullDate = @"dd MMM yyyy , hh:mm a";
static NSString *kDateFormatTypeZFormatted = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
static NSString *kDateFormatTypeWithoutT = @"yyyy-MM-dd";

static NSString *kDateFormatTypeTime = @"hh:mm a";
static NSString *kDateFormatTypeGraphDate = @"dd MMM hh:mm a";
static NSString *kDateFormatTypeGeneric = @"yyyy-MM-dd hh:mm a";
static NSString *kDateFormatTypeGeneric24Hours = @"yyyy-MM-dd HH:mm:ss";
typedef NS_ENUM(NSInteger, DateFormatType)
{
    DateFormatTypeFullDate=0,
    DateFormatTypeZFormatted=1,
    DateFormatTypeTypeBasic=2,
    DateFormatTypeTime=3
    
};

typedef NS_ENUM(NSInteger, ImageViewComfrom)
{
    ImageViewComfromCab=1,
    ImageViewComfromCabProvider=2,
    ImageViewComfromUser=3
};


typedef NS_ENUM(NSInteger, ServiceLoginType)
{
    ServiceLoginTypeOLA=0,
    ServiceLoginTypeMERU=1,
    ServiceLoginTypeMEGACAB=2,
    ServiceLoginTypeTABCAB=3,
    ServiceLoginTypeEASYCAB=4
};

typedef NS_ENUM(NSInteger, LoginPushedFrom)
{
    LoginPushedFromAppConnect=0,
    LoginPushedFromBookRide=1
};
typedef NS_ENUM(NSInteger, LocationSearchPresent)
{
    LocationSearchPresentHome=0,
    LocationSearchPresentSearchTrip=1
};

typedef NS_ENUM(NSInteger, TextFieldFirstResponder)
{
    TextFieldFirstResponderNone=0,
    TextFieldFirstResponderUserName=1,
    TextFieldFirstResponderEmail=2,
    TextFieldFirstResponderPassword=3,
    TextFieldFirstResponderPhone=4
};

typedef NS_ENUM(NSInteger, CellType)
{
    CellTypeName =0,
    CellTypePassword,
    CellTypeEmail,
    CellTypeLocation,
    CellTypeMobile,
    CellTypeCity,
    CellTypeOTP,
    CellTypeFirstName,
    CellTypeLastName,
    CellTypePromoCode
};


typedef NS_ENUM(NSInteger, MyRideType)
{
    MyRideTypeUpcoming =0,
    MyRideTypePast,
};

typedef NS_ENUM(NSInteger, SearchLocationComefrom)
{
   SearchLocationComefromPickUp=1,
   SearchLocationComefromDropOff=2
};


typedef NS_ENUM(NSInteger,SearchLocationSelectedIndex)
{
    SearchLocationSelectedIndexFavorite=0,
    SearchLocationSelectedIndexRecent=1
    
};
typedef NS_ENUM(NSInteger, CabsCategoryType)
{
    CabsCategoryTypeAll=0,
    CabsCategoryTypeSedan=1,
    CabsCategoryTypeHatchback=2,
    CabsCategoryTypeLuxury=3
};
typedef NS_ENUM(NSInteger, RideType)
{
    RideTypeNow=0,
    RideTypeLater=1
};

static  NSString *BOOKING_STATUS_PROCESSING = @"processing";
static  NSString *BOOKING_STATUS_COMPLETED =  @"completed";
static  NSString *BOOKING_STATUS_CANCELLED =  @"cancelled";
static  NSString *BOOKING_STATUS_ACCEPTED =  @"accepted";
// user defaults keys

#define keyDefaultsUserName @"user_name"
#define keyDefaultsUserId @"user_id"
#define keyDefaultsUserEmail @"user_email"
#define keyDefaultsUserPhone @"user_phone"
#define keyDefaultsUserProfilePic @"user_profile_pic"
#define keyDefaultsUserSocialPic @"user_social_pic"
#define keyDefaultsUserSocialId @"user_social_Id"
#define keyDefaultsUserSocialType @"user_social_Type"
#define keyDefaultsUserIsVerified @"user_Is_Verified"
#define keyDefaultsRateMe @"rate_me"
#define keyDefaultsFirsTimeBookingDone @"first_time_booking_done"
#define keyDefaultsForceShowRatingScreen @"force_show_rating_screen"
#define keyDefaultsUserNewPhone @"user_new_phone"

// isFirstTime defaults keys
#define keyDefaultsIsFirstTime @"isFirstTime"


// PlaceHolderImages
#define imgUserPlaceholder @"userPlaceholder"
#define logoOLA @"logo_olacab"
#define logoMeruCab @"logo_merucab"
#define logoMegaCab @"logo_megacab"
#define logoEasyCab  @"logo_easycab"
#define logoTabCab @"logo_tabcab"


#endif
