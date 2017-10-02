
#import "VVCachedCLLocationManager.h"
#import "NotificationDefinitions.h"

@interface VVCachedCLLocationManager ()

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic) BOOL updating;
@property (nonatomic) BOOL locationFound;
@property (nonatomic, strong) NSDate* lastUpdated;
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation VVCachedCLLocationManager

#pragma mark - Singleton Method

+ (VVCachedCLLocationManager*)sharedInstance
{
    //VVLog(@"");
    static VVCachedCLLocationManager* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[VVCachedCLLocationManager alloc] init];
        
    });

    return _sharedInstance;
}

#pragma mark - init Method

- (id)init
{
    self = [super init];
    if (self != nil) {
        //VVLog(@"");
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate=self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _ttl = 300; // 5 minutes
        _lastUpdated = [NSDate distantPast];
        _updating = NO;
        _locationFound = NO;
    }
    return self;
}

#pragma mark - public API

+ (void)startUpdate
{
    //VVLog(@"");
    [[VVCachedCLLocationManager sharedInstance] startUpdate];
}

+ (void)stopUpdate
{
    //VVLog(@"");
    [[VVCachedCLLocationManager sharedInstance] stopUpdate];
}

+ (void)startUpdateIfDue
{
    [[VVCachedCLLocationManager sharedInstance] startUpdateIfDue];
}

+ (CLLocation*)currentLocation
{
    //VVLog(@"");
    return [[VVCachedCLLocationManager sharedInstance] currentLocation];
}

+ (CLLocationAccuracy)getAccuracyUsedToFetchTheLocation
{
   return [[VVCachedCLLocationManager sharedInstance] accuracy];
}

+ (CLLocation*)currentLocationIfPermitted
{
    //VVLog(@"");
    return [[VVCachedCLLocationManager sharedInstance] currentLocationIfPermitted];
}

+ (CLLocation*)currentLocationWithStampede
{
    //VVLog(@"");
    return [[VVCachedCLLocationManager sharedInstance] currentLocationWithStampede];
}

+ (BOOL)locationFound
{
    return [[VVCachedCLLocationManager sharedInstance] locationFound];
}

#pragma mark - location manager methods

- (CLLocationAccuracy)accuracy
{
    return _currentLocation ? _currentLocation.horizontalAccuracy : -1.0f;
}

- (CLLocation*)currentLocation
{
    [self startUpdateIfDue];
    return _currentLocation;
}

- (CLLocation*)currentLocationIfPermitted
{
    BOOL auth = NO;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS7 and below
        auth = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
    } else {
        auth = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse;
    }
    
    if ([CLLocationManager locationServicesEnabled] && auth) {
        return [self currentLocation];
    } else {
        return nil;
    }
}

// http://en.wikipedia.org/wiki/Cache_stampede
- (CLLocation*)currentLocationWithStampede
{
    [self startUpdateIfDue];
    if ([self dueForUpdate]) {
        return nil;
    } else {
        return _currentLocation;
    }
}


- (void)startUpdate
{
    SSLog(@"startUpdate ");
    if (_updating == NO) {
        [self startTimer];
        _updating = YES;
      
        if(([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]))
        {
            [_locationManager requestWhenInUseAuthorization];
        }
        
        [_locationManager startUpdatingLocation];
    }
}

- (void)stopUpdate
{
    //VVLog(@"");
    if (_updating == YES) {
        [self stopTimer];
        _updating = NO;
        [_locationManager stopUpdatingLocation];
    }
}

- (BOOL)locationFound
{
    return _locationFound;
}

- (void)startUpdateIfDue
{
    if ([self dueForUpdate])
        [self startUpdate];
}

- (BOOL)dueForUpdate
{
    NSTimeInterval secondsPast = [_lastUpdated timeIntervalSinceNow] + _ttl;
    return (secondsPast < 0);
}

#pragma mark - CLLocationManager Delegate Method

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    _currentLocation = [locations objectAtIndex:0];
    // Heini is going to showcase verified wine lists at this location
    //_currentLocation = [[CLLocation alloc] initWithLatitude:37.785271f longitude:-122.3975806f];
    if ([self shouldStopUpdate:_currentLocation]) {
        [self stopUpdate];
    }
    _lastUpdated = _currentLocation.timestamp;
    _locationFound = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationUpdateNotification object:self];
    //VVLog(@"location: %@", _currentLocation);
}

- (BOOL)shouldStopUpdate:(CLLocation*)location
{
    // keep the updater going until the accuracy is tolerable
    return location.horizontalAccuracy < 40.0f;
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    SSLog(@"Error: %@", error.localizedDescription);
    [self stopUpdate];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationErrorNotification object:self];
}

#pragma mark - Timer methods

- (void)startTimer
{
    if (!_timer) {
        // keep the updater alive for maximum 20 seconds
        _timer = [NSTimer scheduledTimerWithTimeInterval:20.0f
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:NO];
    }
}

- (void)stopTimer
{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}

- (void)timerFired:(NSTimer*)timer
{
    [self stopUpdate];
}

+(BOOL)isAuthorizationStatusDenied
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        return YES;
    
    return NO;
}

+(BOOL)isAuthorizationStatusNotDetermined
{
     if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
         return YES;
    return NO;
}

-(void)getAddressWithLocation:(CLLocation*)location
            success:(void (^)(CLPlacemark *placemark))success
              failure:(void (^)(NSError *error))failure;
{
    if(location.coordinate.latitude==0 && location.coordinate.longitude==0)
    {
        failure(nil);
        return;
    }
    [[CLGeocoder new]  reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
             SSLog(@"placemark %@",placemarks);
            CLPlacemark * placemark = [placemarks lastObject];
            if(success)
                success(placemark);
           
          } else {
            
              failure(error);
        }
    } ];
}


-(void)getLatLngWithAddress:(NSString*)address
                      success:(void (^)(CLPlacemark *placemark))success
                      failure:(void (^)(NSError *error))failure;
{
   
    [[CLGeocoder new]  geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark * placemark = [placemarks lastObject];
            if(success)
                success(placemark);
            SSLog(@"placemark lat %f lag %f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
        } else {
            
            failure(error);
        }
    }];
    
    
   
}
- (void)dealloc
{
    if (_locationManager)
        _locationManager.delegate = nil;
}

@end
