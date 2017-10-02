//
//  Place.h
//  CabWala
//
//  Created by Sphinx Solution Pvt Ltd on 12/18/15.
//  Copyright © 2015 ananadmahajan. All rights reserved.
//

#import "MTLModelModified.h"

@interface Place : MTLModelModified
@property(nonatomic,strong) NSString *cityId;
@property(nonatomic,strong) NSString *cityName;
@property(nonatomic,strong) NSString *distance;
@property(nonatomic,strong) NSString *place_id;
@property(nonatomic,strong) NSString *lat;
@property(nonatomic,strong) NSString *lng;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *type;

//for app use
-(id)initWithCLPlaceMarker:(CLPlacemark*)obj;
-(id)initWithCLPlaceMarker:(NSDictionary*)dict formattedAddress:(NSString*)address;
-(BOOL)hasValidCoordinates;
@property(nonatomic)NSInteger local_location_id;
@property(nonatomic)BOOL is_favorite;
- (BOOL)isEqual:(id)object;
+(NSURL*)getGoogleDistanceUrlWithSourceCoordinate:(NSString*)sco destinationCoordinate:(NSString*)dco;
-(CLLocation*)getLocationCoordinates;
@end
