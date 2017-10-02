//
//  VVBaseUserDefaults.h
//  VivinoV2
//
//  Created by Kasper Weibel Nielsen-Refs on 19/01/15.
//
//

#import <Foundation/Foundation.h>
@class Place;

@interface VVBaseUserDefaults : NSObject

+ (NSString*)getStringForKey:(NSString*)key;
+ (NSInteger)getIntForKey:(NSString*)key;
+ (NSDictionary*)getDictForKey:(NSString*)key;
+ (NSArray*)getArrayForKey:(NSString*)key;
+ (BOOL)getBoolForKey:(NSString*)key;
+ (id)getObjectForKey:(NSString*)key;
+ (NSDate*)getDateForKey:(NSString*)key;

// New style setters
+ (void)setString:(NSString*)value forKey:(NSString*)key;
+ (void)setInt:(NSInteger)value forKey:(NSString*)key;
+ (void)setDict:(NSDictionary*)value forKey:(NSString*)key;
+ (void)setArray:(NSArray*)value forKey:(NSString*)key;
+ (void)setBool:(BOOL)value forKey:(NSString*)key;
+ (void)setDate:(NSDate*)value forKey:(NSString*)key;

+(void)setPickUpLocation:(Place*)obj;
+(Place*)getPickUpLocation;
+(void)setDropOffLocation:(Place*)obj;
+(Place*)getDropOffLocation;

// Old style setters
// TODO: DEPRECATE these
+ (void)setStringForKey:(NSString*)key value:(NSString*)value;
+ (void)setIntForKey:(NSString*)key value:(NSInteger)value;
+ (void)setDictForKey:(NSString*)key value:(NSDictionary*)value;
+ (void)setArrayForKey:(NSString*)key value:(NSArray*)value;
+ (void)setBoolForKey:(NSString*)key value:(BOOL)value;
+ (void)setDateForKey:(NSString*)key date:(NSDate*)date;

+ (void)removeValueForKey:(NSString*)key;

+ (void)setObjectForKey:(NSString*)key value:(id)value;
+(NSNumber*)getCurrentUserId;
+(void)setCurrentUserId:(NSInteger)userid;

#pragma marks -- Rate Me methods
+(NSInteger)getRateMeCount;
+(void)resetRateMeCount;
+(void)invalieRateMeCount;
+(BOOL)isInvalieRateMeCount;
+(NSInteger)increaseRateMeCount;
+(BOOL)isFirstTimeBookingDone;
+(void)setFirstTimeBookingDone;
+(NSInteger)isForceShowRatingAfterBooking;
+(void)setForceShowRatingAfterBooking:(NSInteger)value;
@end
