//
//  Place.m
//  CabWala
//
//  Created by Sphinx Solution Pvt Ltd on 12/18/15.
//  Copyright © 2015 ananadmahajan. All rights reserved.
//

#import "Place.h"

@implementation Place
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // override this in the model if property names in JSON don't match model
    NSDictionary *mapping = [NSDictionary mtl_identityPropertyMapWithModel:self];
    return [mapping mtl_dictionaryByAddingEntriesFromDictionary:@{@"place_id":@"id"}];
}

-(id)initWithCLPlaceMarker:(CLPlacemark*)obj
{
    self=[super init];
    
    SSLog(@"obj.name  %@  obj.locality %@",obj,obj.locality);
    self.name=[AppManager getLocationStrFromPlaceMarker:obj];
    self.cityName=self.name;
    self.lat=[NSString stringWithFormat:@"%f",obj.location.coordinate.latitude];
    self.lng=[NSString stringWithFormat:@"%f",obj.location.coordinate.longitude];
    self.is_favorite=0;
    
    return self;
}

-(id)initWithCLPlaceMarker:(NSDictionary*)dict formattedAddress:(NSString*)address
{
    self=[super init];
     NSDictionary *location =dict[@"result"][@"geometry"][@"location"];
   if(![[AppManager sharedData] isEmpty:address])
    {
        NSArray *arr = [address componentsSeparatedByString:@" "];
        self.name=[arr firstObject];
        
        NSMutableArray *arrAddress = [NSMutableArray arrayWithArray:arr];
        [arrAddress removeObject:[arr firstObject]];
        
         self.cityName=[arrAddress componentsJoinedByString:@" "];
    }
   
   
   self.lat=[NSString stringWithFormat:@"%@",location[@"lat"]];
    self.lng=[NSString stringWithFormat:@"%@",location[@"lng"]];;
    self.is_favorite=0;
    
    return self;
}
+(NSURL*)getGoogleDistanceUrlWithSourceCoordinate:(NSString*)sco destinationCoordinate:(NSString*)dco
{
   NSString *url=  [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true", sco,dco];
    
    return  [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}
-(BOOL)hasValidCoordinates
{
    return ([self.lat floatValue]>0 || [self.lng floatValue]);
}
- (BOOL)isEqual:(id)object
{
    Place *obj = (Place*)object;
    
    if([self.lat floatValue]==[obj.lat floatValue] && [self.lng floatValue]==[obj.lng   floatValue])
        return YES;
    return NO;
}
-(CLLocation*)getLocationCoordinates
{
    return [[CLLocation alloc] initWithLatitude:[_lat floatValue] longitude:[_lng floatValue]];
}
@end
