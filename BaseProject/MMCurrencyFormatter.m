
#import "MMCurrencyFormatter.h"

@interface MMCurrencyFormatter ()

@property (nonatomic, strong) NSString* currencyCode;

@end

@implementation MMCurrencyFormatter

#pragma mark - Init


- (instancetype)initWithNumberStyle:(NSNumberFormatterStyle)numberStyle defaults:(VVFormatterDefaultsBlock)defaults
{
    if(!(self = [self initWithCurrencyCode:@"" defaults:defaults]))
        return nil;
    
    return self;
}

- (instancetype)initWithCurrencyCode:(NSString*)currencyCode defaults:(VVFormatterDefaultsBlock)defaults
{
    if (!(self = [super initWithNumberStyle:NSNumberFormatterCurrencyStyle defaults:defaults]))
        return nil;

    _currencyCode = currencyCode;

    return self;
}

#pragma mark - <VVFormatterImplementation>

- (NSNumberFormatter*)formatterInstance
{
    NSNumberFormatter* formatter = [super formatterInstance];
    formatter.currencyCode = _currencyCode;
    return formatter;
}

/**
 *  @discussion NSNumberFormatter breaks if the currency is reconfigured so the currency is part of the cache key to make sure we have a formatter instance for each currency.
 */
- (NSString*)cacheKey
{
    return [NSString stringWithFormat:@"%@.%@", [super cacheKey], _currencyCode];
}

#pragma mark - Currency formatter methods

- (NSString*)formatCurrency:(NSNumber*)amount
                     locale:(NSLocale*)locale
              decimalPlaces:(NSInteger)decimals
{
    NSString* res = [self format:^id(NSNumberFormatter* formatter) {
        formatter.locale = locale;
        formatter.minimumFractionDigits = decimals;
        formatter.maximumFractionDigits = decimals;
        NSString* tmp = [formatter stringFromNumber:amount];
        return tmp;
    }];

    return res;
}

@end
