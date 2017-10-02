

#import "UnitConverter.h"
#import "MKUnits.h"
#import "FormatterCollection.h"

static MKQuantity *_1mi, *_1000yd, *_0_1mi, *_0_01mi, *_1km, *_100m, *_10m;

@interface UnitConverter ()

@property (nonatomic, strong) MKQuantity *quantity;

@end

@implementation UnitConverter

+ (void)initialize {
    if (self == [UnitConverter class]) {
        _1mi = [MKQuantity length_mileWithAmount:@1.0];
        _1000yd = [MKQuantity length_yardWithAmount:@1000];
        _0_1mi = [MKQuantity length_mileWithAmount:@0.1];
        _0_01mi = [MKQuantity length_mileWithAmount:@0.01];
        _1km = [MKQuantity length_kilometerWithAmount:@1.0];
        _100m = [MKQuantity length_meterWithAmount:@100.0];
        _10m = [MKQuantity length_meterWithAmount:@10.0];
    }
}

- (id)initWithMeters:(NSInteger)meters {
    self = [super init];
    if (self) {
        _quantity = [MKQuantity length_meterWithAmount:[NSNumber numberWithInteger:meters]];
    }
    return self;
}

- (NSString*)description {
    //NSAssert(@"Deprecated", @"Please don't use this method in your code");
    return [self formatForUserDefault];
}

- (NSString*)formatForUserDefault
{
   /* if([[Utility new] useEmperial]) {
        return [self formatForSystem:UnitConverterSystemImperial];
    } else {
        return [self formatForSystem:UnitConverterSystemMetric];
    }*/
   return nil;
}

- (NSString*)formatForSystem:(UnitConverterSystem)system
{
    MKQuantity *quantity;
    switch (system) {
        case UnitConverterSystemMetric:
            quantity = [self asMetric];
            break;
        case UnitConverterSystemImperial:
            quantity = [self asImperial];
            break;
    }
    
    return [self formatQuantity:quantity];
}

- (NSString*)formatQuantity:(MKQuantity*)quantity
{
    NSString *res = [FormatterCollection runDecimalFormatterWithBlock:^id(NSNumberFormatter *formatter) {
        formatter.minimumFractionDigits = 0;
        return [formatter stringFromNumber:quantity.amount];
    }];
    return [NSString stringWithFormat:@"%@ %@", res, quantity.unit];
}

- (MKQuantity*)asMetric {
    //id padding = [_quantity add:_100m];
    
    if ([_quantity isGreaterThan:_1km withPrecision:3]) {
        return [[_quantity convertTo:[MKLengthUnit kilometer]] quantityWithPrecision:2];
    }
    else {
        return [_quantity quantityWithPrecision:0];
    }
}

- (MKQuantity*)asImperial {
    // http://ux.stackexchange.com/questions/46281/what-do-ui-developers-in-the-us-working-in-imperial-measurements-use-for-decim
    //id padding = [_quantity add:_0_1mi];
    
    if ([_quantity isGreaterThan:_1000yd withPrecision:3]) {
        return [[_quantity convertTo:[MKLengthUnit mile]] quantityWithPrecision:2];
    }
    else {
        return [[_quantity convertTo:[MKLengthUnit yard]] quantityWithPrecision:0];
    }
}

@end