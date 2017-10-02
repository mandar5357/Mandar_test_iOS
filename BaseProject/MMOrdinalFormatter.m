

#import "MMOrdinalFormatter.h"

/**
 *  Monkey patch for opening localizedOrdinalIndicatorStringFromNumber to outside use
 */
@interface TTTOrdinalNumberFormatter ()

- (NSString*)localizedOrdinalIndicatorStringFromNumber:(NSNumber*)number;

@end

@implementation MMOrdinalFormatter

#pragma mark - Shared formatters

- (TTTOrdinalNumberFormatter*)formatterInstance
{
    TTTOrdinalNumberFormatter* ordinalNumberFormatter = [[TTTOrdinalNumberFormatter alloc] init];
    ordinalNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    ordinalNumberFormatter.minimumIntegerDigits = 1;
    ordinalNumberFormatter.minimumFractionDigits = 0;
    ordinalNumberFormatter.maximumFractionDigits = 0;
    ordinalNumberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
    return ordinalNumberFormatter;
}

- (NSString*)cacheKey
{
    return @"TTTOrdinalNumberFormatter";
}

#pragma mark - Ordinal formatter methods

- (NSString*)stringFromNumber:(NSNumber*)number
{
    NSString* result = [self format:^id(TTTOrdinalNumberFormatter* formatter) {
        NSString* ordinalNumber = [formatter stringFromNumber:number];
        return ordinalNumber;
    }];

    return result;
}

- (NSString*)ordinalIndicatorStringFromNumber:(NSNumber*)number
{
    NSString* result = [self format:^id(TTTOrdinalNumberFormatter* formatter) {
        NSString* indicator = [formatter localizedOrdinalIndicatorStringFromNumber:number];
        return indicator;
    }];

    return result;
}

@end
