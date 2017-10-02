//
//  VVBaseUserDefaults.m
//  VivinoV2
//
//  Created by Kasper Weibel Nielsen-Refs on 19/01/15.
//
//

#import "VVBaseUserDefaults.h"
#import "ISO8601DateFormatter.h"
#import "NSString+checkEmpty.h"
#import "Place.h"
@implementation VVBaseUserDefaults

#pragma mark - Base methods

+ (void)setString:(NSString*)value forKey:(NSString*)key
{
    
    [self setStringForKey:key value:value];
}

+ (void)setInt:(NSInteger)value forKey:(NSString*)key
{
    [self setIntForKey:key value:value];
}

+ (void)setDict:(NSDictionary*)value forKey:(NSString*)key
{
    [self setDictForKey:key value:value];
}

+ (void)setArray:(NSArray*)value forKey:(NSString*)key
{
    [self setArrayForKey:key value:value];
}

+ (void)setBool:(BOOL)value forKey:(NSString*)key
{
    [self setBoolForKey:key value:value];
}

+ (void)setDate:(NSDate*)value forKey:(NSString*)key
{
    [self setDateForKey:key date:value];
}

#pragma mark - Get values

+ (NSDate*)getDateForKey:(NSString*)key
{
    NSString* timeString = [self getStringForKey:key];
    NSDate* date = nil;
    if ([timeString isNotEmpty]) {
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        date = [[ISO8601DateFormatter new] dateFromString:timeString timeZone:&timeZone];
    }
    return date;
}

+ (NSString*)getStringForKey:(NSString*)key
{
    NSString* val = @"";
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
        val = [standardUserDefaults stringForKey:key];
    if (val == NULL)
        val = @"";
    return val;
}

+ (NSInteger)getIntForKey:(NSString*)key
{
    NSInteger val = 0;
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:key];
    return val;
}

+ (NSDictionary*)getDictForKey:(NSString*)key
{
    NSDictionary* val = nil;
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
        val = [standardUserDefaults dictionaryForKey:key];
    return val;
}

+ (NSArray*)getArrayForKey:(NSString*)key
{
    NSArray* val = nil;
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
        val = [standardUserDefaults arrayForKey:key];
    return val;
}

+ (BOOL)getBoolForKey:(NSString*)key
{
    BOOL val = FALSE;
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
        val = [standardUserDefaults boolForKey:key];
    return val;
}

+ (id)getObjectForKey:(NSString*)key
{
    id val;
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:key];
    return val;
}

#pragma mark - Set values

+ (void)setStringForKey:(NSString*)key value:(NSString*)value
{
    [self setObjectForKey:key value:value];
}

+ (void)setIntForKey:(NSString*)key value:(NSInteger)value
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+ (void)setDictForKey:(NSString*)key value:(NSDictionary*)value
{
    [self setObjectForKey:key value:value];
}

+ (void)setArrayForKey:(NSString*)key value:(NSArray*)value
{
    [self setObjectForKey:key value:value];
}

+ (void)setObjectForKey:(NSString*)key value:(id)value
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+ (void)setDateForKey:(NSString*)key date:(NSDate*)date
{
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    ISO8601DateFormatter* formatter = [ISO8601DateFormatter new];
    formatter.includeTime = YES;
    NSString* time = [formatter stringFromDate:date timeZone:timeZone];
    [self setStringForKey:key value:time];
}

+ (void)setBoolForKey:(NSString*)key value:(BOOL)value
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setBool:value forKey:key];
        [standardUserDefaults synchronize];
    }
}
+(NSNumber*)getCurrentUserId
{
    return @([VVBaseUserDefaults getIntForKey:keyDefaultsUserId]);
}
+(void)setCurrentUserId:(NSInteger)userid
{
    SSLog(@"%ld",(long)userid);
    [VVBaseUserDefaults setInt:userid forKey:keyDefaultsUserId];
}
+(void)setPickUpLocation:(Place*)obj
{
    [VVBaseUserDefaults saveCustomObject:obj key:@"pickup"];
}
+(Place*)getPickUpLocation
{
    return [VVBaseUserDefaults loadCustomObjectWithKey:@"pickup"];
}

+(void)setDropOffLocation:(Place*)obj
{
    [VVBaseUserDefaults saveCustomObject:obj key:@"dropoff"];
}
+(Place*)getDropOffLocation
{
    return [VVBaseUserDefaults loadCustomObjectWithKey:@"dropoff"];
}

+ (id)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}
+ (void)saveCustomObject:(id)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}
#pragma marks -- Rate Me methods
+(NSInteger)getRateMeCount
{
    if([VVBaseUserDefaults isFirstTimeBookingDone])
        return [VVBaseUserDefaults getIntForKey:keyDefaultsRateMe];
    return -1;
}
+(void)resetRateMeCount
{
    [VVBaseUserDefaults setInt:0 forKey:keyDefaultsRateMe];
}
+(void)invalieRateMeCount
{
    [VVBaseUserDefaults setInt:-1 forKey:keyDefaultsRateMe];
}
+(BOOL)isInvalieRateMeCount
{
    return ([VVBaseUserDefaults getRateMeCount]==-1);
}

+(NSInteger)increaseRateMeCount
{
    if([VVBaseUserDefaults isFirstTimeBookingDone])
    {
        NSInteger count = [VVBaseUserDefaults getRateMeCount] +1;
        [VVBaseUserDefaults setInt:count forKey:keyDefaultsRateMe];
        return count;
    }
    
    return -1;
}

+(BOOL)isFirstTimeBookingDone
{
    NSNumber *userid = [VVBaseUserDefaults getCurrentUserId];
    return [VVBaseUserDefaults getBoolForKey:[NSString stringWithFormat:@"%@_%@",keyDefaultsFirsTimeBookingDone,userid]];
}
+(void)setFirstTimeBookingDone
{
    NSNumber *userid = [VVBaseUserDefaults getCurrentUserId];
    [VVBaseUserDefaults setBool:YES forKey:[NSString stringWithFormat:@"%@_%@",keyDefaultsFirsTimeBookingDone,userid]];
}

+(NSInteger)isForceShowRatingAfterBooking
{
    NSNumber *userid = [VVBaseUserDefaults getCurrentUserId];
    return [VVBaseUserDefaults getIntForKey:[NSString stringWithFormat:@"%@_%@",keyDefaultsForceShowRatingScreen,userid]];
}
+(void)setForceShowRatingAfterBooking:(NSInteger)value
{
    NSInteger previousVal =[VVBaseUserDefaults isForceShowRatingAfterBooking];
    SSLog(@"previousVal %ld",(long)previousVal);
    if (previousVal!=-1)
    {
        NSNumber *userid = [VVBaseUserDefaults getCurrentUserId];
        [VVBaseUserDefaults setInt:value forKey:[NSString stringWithFormat:@"%@_%@",keyDefaultsForceShowRatingScreen,userid]];
    }
  
}
#pragma mark - Remove values

+ (void)removeValueForKey:(NSString*)key
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults removeObjectForKey:key];
        [standardUserDefaults synchronize];
    }
}

@end
