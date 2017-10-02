/*
  Intended use
 
 The devices' current location is stored in
 [VVCachedCLLocationManager currentLocation];
 This wil be nil if no location has been found yet
 
 
 Location updates and errors are broadcast as NSNotifications.
 Please note that this should generally not be neccesary to use, as a precise location will be cached after a few seconds.
 
 Register an object for location update notifications
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(receiveLocationUpdate:)
 name:kLocationUpdateNotification
 object:nil];
 
 Register an object for location update errors
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(receiveLocationUpdateError:)
 name:kLocationErrorNotification
 object:nil];
 
 Remember to remove the object from the observer queue before deallocation
 - (void)dealloc
 [[NSNotificationCenter defaultCenter] removeObserver:self];
 }
 */

#include <CoreLocation/CoreLocation.h>

@interface VVCachedCLLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation* currentLocation;


@property (nonatomic) NSInteger ttl;

+ (VVCachedCLLocationManager*)sharedInstance;
+ (CLLocation*)currentLocation;
+ (CLLocation*)currentLocationIfPermitted;
+ (CLLocation*)currentLocationWithStampede;
+ (void)startUpdate;
+ (void)stopUpdate;
+ (void)startUpdateIfDue;
+ (BOOL)locationFound;

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations;
- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error;
+ (CLLocationAccuracy)getAccuracyUsedToFetchTheLocation;
-(void)getAddressWithLocation:(CLLocation*)location
                      success:(void (^)(CLPlacemark *placemark))success
                      failure:(void (^)(NSError *error))failure;

-(void)getLatLngWithAddress:(NSString*)address
                    success:(void (^)(CLPlacemark *placemark))success
                    failure:(void (^)(NSError *error))failure;

+(BOOL)isAuthorizationStatusDenied;
+(BOOL)isAuthorizationStatusNotDetermined;
@end