

#import <Foundation/Foundation.h>
#import "MKQuantity.h"

typedef NS_ENUM(NSInteger, UnitConverterSystem) {
    UnitConverterSystemMetric = 0,
    UnitConverterSystemImperial
};

@interface UnitConverter : NSObject

- (id)initWithMeters:(NSInteger)meters;
- (NSString*)formatForUserDefault;
- (NSString*)formatForSystem:(UnitConverterSystem)system;

@end