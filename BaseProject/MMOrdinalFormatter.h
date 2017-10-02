
#import "MMBaseFormatter.h"
#import "FormatterKit/TTTOrdinalNumberFormatter.h"

/**
 *  Formatter for formatting ordinal numbers. Uses https://github.com/mattt/FormatterKit
 */
@interface MMOrdinalFormatter : MMBaseFormatter <VVFormatterImplementation>

/**
 *  Ordinal representation of a number
 *
 *  @param number The number to be formatted
 *
 *  @return Ordinal representation.
 */
- (NSString*)stringFromNumber:(NSNumber*)number;

/**
 *  The ordinal indicator string.
 *
 *  @param number Number to for which to find the indicator string
 *
 *  @return The ordinal indicator string.
 */
- (NSString*)ordinalIndicatorStringFromNumber:(NSNumber*)number;

@end
