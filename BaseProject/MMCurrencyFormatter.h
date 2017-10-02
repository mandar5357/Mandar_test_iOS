

#import "MMNumberFormatter.h"

/**
 *  VVNumberFormatter subclass for formatting currencies.
 */
@interface MMCurrencyFormatter : MMNumberFormatter

/**
 *  Init a formatter with a specific currency code.
 *
 *  @param currencyCode The ISO 4217 currency code. If no code is needed use a blank string.
 *  @param defaults     Formatter defaults block.
 *
 *  @return An instance of VVCurrencyFormatter.
 */
- (instancetype)initWithCurrencyCode:(NSString*)currencyCode defaults:(VVFormatterDefaultsBlock)defaults NS_DESIGNATED_INITIALIZER;

/**
 *  Format amount for a given display locale.
 *
 *  @param amount   NSNumber with the amount to format
 *  @param locale   The locale for the in which the amount should be displayed
 *  @param decimals The number of decimals desired in in the formatting.
 *
 *  @return NSString with the formatted abount.
 */
- (NSString*)formatCurrency:(NSNumber*)amount locale:(NSLocale*)locale decimalPlaces:(NSInteger)decimals;

@end
