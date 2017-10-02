

#import "MMNumberFormatter.h"

/**
 *  VVNumberFormatter subclass for formatting decimal numbers.
 */
@interface MMDecimalFormatter : MMNumberFormatter

/**
 *  Parse decimal input for a given locale.
 *
 *  @param inputString String with a number formatted in a given locale.
 *  @param locale      NSLocale for the input string.
 *
 *  @return NSNumber representation of the input string.
 */
- (NSNumber*)parseDecimalInput:(NSString*)inputString locale:(NSLocale*)locale;

/**
 *  Format NSNumber or a given locale.
 *
 *  @param number   NSNumber to be formatted.
 *  @param locale   NSLocale for the output string.
 *  @param decimals Number of decimals in the formatted string.
 *
 *  @return NSString representation of the input formatted for the given locale.
 */
- (NSString*)formatDecimalNumber:(NSNumber*)number locale:(NSLocale*)locale decimalPlaces:(NSInteger)decimals;

/**
 *  Transform any decimal input from locale to en_US string representation with no grouping seperator.
 *
 *  @param inputString String with a number formatted in a given locale.
 *  @param locale      NSLocale for the input string.
 *
 *  @return NSString representation of the input formatted for en_US NSLocale.
 */
- (NSString*)transformDecimalStringtoCanonical:(NSString*)inputString locale:(NSLocale*)locale;

/**
 *  Transform en_US decimal input to a given locale representation
 *
 *  @param canonical en_US NSLocale string representation of a number.
 *  @param locale    NSLocale for the output string.
 *
 *  @return  NSString representation of the input formatted for the given locale.
 */
- (NSString*)transformCanonicalStringtoDecimal:(NSString*)canonical locale:(NSLocale*)locale;

@end
