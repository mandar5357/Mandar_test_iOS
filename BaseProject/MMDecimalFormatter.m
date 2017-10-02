
#import "MMDecimalFormatter.h"

@implementation MMDecimalFormatter

#pragma mark - Init

- (instancetype)initWithDefaults:(VVFormatterDefaultsBlock)defaults
{
    if (!(self = [super initWithNumberStyle:NSNumberFormatterDecimalStyle defaults:defaults]))
        return nil;

    return self;
}

#pragma mark - Decimal formatter methods

- (NSNumber*)parseDecimalInput:(NSString*)inputString locale:(NSLocale*)locale
{
    NSNumber* result = [self format:^id(NSNumberFormatter* formatter) {
        formatter.locale = locale;
        NSNumber* number = [formatter numberFromString:inputString];
        return number;
    }];

    return result;
}

- (NSString*)formatDecimalNumber:(NSNumber*)number locale:(NSLocale*)locale decimalPlaces:(NSInteger)decimals
{
    NSString* result = [self format:^id(NSNumberFormatter* formatter) {
        if (locale)
            formatter.locale = locale;
        formatter.minimumFractionDigits = decimals;
        formatter.maximumFractionDigits = decimals;
        NSString* res = [formatter stringFromNumber:number];
        return res;
    }];

    return result;
}

- (NSString*)transformDecimalStringtoCanonical:(NSString*)inputString locale:(NSLocale*)locale
{
    NSNumber* number = [self parseDecimalInput:inputString locale:locale];
    NSString* res = [self format:^id(NSNumberFormatter* formatter) {
        formatter.usesGroupingSeparator = NO;
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        NSString* res = [formatter stringFromNumber:number];
        return res;
    }];
    return res;
}

- (NSString*)transformCanonicalStringtoDecimal:(NSString*)canonical locale:(NSLocale*)locale
{
    NSNumber* number = [self format:^id(NSNumberFormatter* formatter) {
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        NSNumber* number = [formatter numberFromString:canonical];
        return number;
    }];

    NSString* result = [self formatDecimalNumber:number locale:locale decimalPlaces:2];
    return result;
}

@end
