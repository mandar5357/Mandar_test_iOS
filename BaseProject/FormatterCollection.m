
#import "FormatterCollection.h"
#import "MMCurrencyFormatter.h"
#import "MMDecimalFormatter.h"
#import "MMOrdinalFormatter.h"
#import "MMDateFormatter.h"
#import "LanguageManager.h"
#import "Utility.h"



static VVFormatterDefaultsBlock currencyDefaults = ^(NSNumberFormatter* formatter) {
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;
    formatter.minimumIntegerDigits = 1;
    formatter.roundingMode = NSNumberFormatterRoundHalfUp;
    formatter.locale = [LanguageManager getPerferedLocale];
    formatter.usesGroupingSeparator = YES;
};

static VVFormatterDefaultsBlock decimalDefaults = ^(NSNumberFormatter* formatter) {
    formatter.lenient = YES;
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;
    formatter.roundingMode = NSNumberFormatterRoundHalfUp;
    formatter.locale = [LanguageManager getPerferedLocale];
    formatter.usesGroupingSeparator = YES;
    formatter.minimumIntegerDigits = 1;
};

static VVFormatterDefaultsBlock ordinalDefaults = ^(TTTOrdinalNumberFormatter* formatter) {
    formatter.locale = [LanguageManager getPerferedLocale];
    formatter.usesGroupingSeparator = YES;
    formatter.grammaticalGender = TTTOrdinalNumberFormatterMaleGender;
};

static VVFormatterDefaultsBlock dateDefaults = ^(NSDateFormatter* formatter) {
    formatter.locale = [LanguageManager getPerferedLocale];
    formatter.timeZone = [NSTimeZone systemTimeZone];
};


static VVFormatterDefaultsBlock utcdateDefaults = ^(NSDateFormatter* formatter) {
    formatter.locale = [LanguageManager getPerferedLocale];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
};


// We go to great lenghts to reuse the NSFormatters.
// Bencmarks at http://forgecode.net/2010/02/simplifying-nsnumberformatter-use-on-the-iphone-with-objective-c-categories/

@implementation FormatterCollection

#pragma mark - Public API

#pragma mark - Currency formatter methods

+ (NSString*)formatCurrency:(NSNumber*)amount
               currencyCode:(NSString*)currencyCode
           localeIdentifier:(NSString*)localeIdentifier
              decimalPlaces:(NSInteger)decimals
{
    NSLocale* locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
    return [self formatCurrency:amount currencyCode:currencyCode locale:locale decimalPlaces:decimals];
}

+ (NSString*)formatCurrency:(NSNumber*)amount
               currencyCode:(NSString*)currencyCode
                     locale:(NSLocale*)locale
              decimalPlaces:(NSInteger)decimals
{
    MMCurrencyFormatter* cf = [[MMCurrencyFormatter alloc] initWithCurrencyCode:currencyCode defaults:currencyDefaults];
    NSString* res = [cf formatCurrency:amount locale:locale decimalPlaces:decimals];
    return res;
}

+ (id)runCurrencyFormatterForCode:(NSString*)currencyCode withBlock:(id (^)(NSNumberFormatter* formatter))formatterBlock
{
    MMCurrencyFormatter* cf = [[MMCurrencyFormatter alloc] initWithCurrencyCode:currencyCode defaults:currencyDefaults];
    id result = [cf format:formatterBlock];
    return result;
}

#pragma mark - Decimal formatter methods

+ (NSNumber*)parseDecimalInput:(NSString*)inputString localeIdentifier:(NSString*)localeIdentifier
{
    NSLocale* locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
    NSNumber* result = [self parseDecimalInput:inputString locale:locale];
    return result;
}

+ (NSNumber*)parseDecimalInput:(NSString*)inputString locale:(NSLocale*)locale
{
    MMDecimalFormatter* df = [[MMDecimalFormatter alloc] initWithDefaults:currencyDefaults];
    NSNumber* result = [df parseDecimalInput:inputString locale:locale];
    return result;
}

+ (NSString*)formatInteger:(NSInteger)number
{
    return [self formatNumberAsInteger:[NSNumber numberWithInteger:number]];
}

+ (NSString*)formatNumberAsInteger:(NSNumber*)number
{
    return [self formatDecimalNumber:number locale:nil decimalPlaces:0];
}

+ (NSString*)formatDecimalNumber:(NSNumber*)number localeIdentifier:(NSString*)localeIdentifier
{
    NSLocale* locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
    NSString* result = [self formatDecimalNumber:number locale:locale];
    return result;
}

+ (NSString*)formatDecimalNumber:(NSNumber*)number locale:(NSLocale*)locale
{
    return [self formatDecimalNumber:number locale:locale decimalPlaces:2];
}

+ (NSString*)formatDecimalNumber:(NSNumber*)number locale:(NSLocale*)locale decimalPlaces:(NSInteger)decimals
{
    MMDecimalFormatter* df = [[MMDecimalFormatter alloc] initWithDefaults:currencyDefaults];
    NSString* result = [df formatDecimalNumber:number locale:locale decimalPlaces:decimals];
    return result;
}

+ (NSString*)transformDecimalStringtoCanonical:(NSString*)inputString localeIdentifier:(NSString*)localeIdentifier
{
    NSLocale* locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
    NSString* result = [self transformDecimalStringtoCanonical:inputString locale:locale];
    return result;
}

+ (NSString*)transformDecimalStringtoCanonical:(NSString*)inputString locale:(NSLocale*)locale
{
    MMDecimalFormatter* df = [[MMDecimalFormatter alloc] initWithDefaults:currencyDefaults];
    NSString* result = [df transformDecimalStringtoCanonical:inputString locale:locale];
    return result;
}

+ (NSString*)transformCanonicalStringtoDecimal:(NSString*)canonical localeIdentifier:(NSString*)localeIdentifier
{
    NSLocale* locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
    NSString* result = [self transformCanonicalStringtoDecimal:canonical locale:locale];
    return result;
}

+ (NSString*)transformCanonicalStringtoDecimal:(NSString*)canonical locale:(NSLocale*)locale
{
    MMDecimalFormatter* df = [[MMDecimalFormatter alloc] initWithDefaults:currencyDefaults];
    NSString* result = [df transformCanonicalStringtoDecimal:canonical locale:locale];
    return result;
}

+ (id)runDecimalFormatterWithBlock:(id (^)(NSNumberFormatter* formatter))formatterBlock;
{
    MMDecimalFormatter* df = [[MMDecimalFormatter alloc] initWithDefaults:currencyDefaults];
    id result = [df format:formatterBlock];
    return result;
}

#pragma mark - Ordinal number formatter methods

+ (NSString*)ordinalStringFromNumber:(NSNumber*)number
{
    MMOrdinalFormatter* of = [[MMOrdinalFormatter alloc] initWithDefaults:ordinalDefaults];
    NSString* result = [of stringFromNumber:number];
    return result;
}

+ (NSString*)ordinalIndicatorFromNumber:(NSNumber*)number
{
    MMOrdinalFormatter* of = [[MMOrdinalFormatter alloc] initWithDefaults:ordinalDefaults];
    NSString* result = [of ordinalIndicatorStringFromNumber:number];
    return result;
}

#pragma mark - Date formatters

+(NSDate*)pastDateWithDays:(NSInteger)days
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-days];
    NSDate *daysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    
    return daysAgo;
}
+ (NSString*)formatDate:(NSDate*)date format:(NSString*)formatString
{
    MMDateFormatter* df = [[MMDateFormatter alloc] initWithDefaults:dateDefaults];
    NSString* result = [df formatDate:date format:formatString];
    return result;
}
+ (NSString*)formatDateStr:(NSString*)dateStr format:(NSString*)formatString
{
    MMDateFormatter* df = [[MMDateFormatter alloc] initWithDefaults:dateDefaults];
    
    NSDate *date =[df parseDate:dateStr format:kDateFormatTypeGeneric24Hours];
    NSString* result = [df formatDate:date format:formatString];
    return result;
}

+ (NSString*)localeAwareFormatDate:(NSDate*)date format:(NSString*)formatString
{
    MMDateFormatter* df = [[MMDateFormatter alloc] initWithDefaults:dateDefaults];
    NSString* result = [df localeAwareFormatDate:date format:formatString];
    return result;
}

+ (NSDate*)parseDate:(NSString*)date format:(NSString*)formatString
{
    MMDateFormatter* df = [[MMDateFormatter alloc] initWithDefaults:dateDefaults];
    NSDate* result = [df parseDate:date format:formatString];
    return result;
}
+ (NSDate*)localeAwareParseDate:(NSString*)date format:(NSString*)formatString
{
    MMDateFormatter* df = [[MMDateFormatter alloc] initWithDefaults:dateDefaults];
    NSDate* result = [df localeAwareParseDate:date format:formatString];
    return result;
}

+(NSString*)getTimsSlot:(NSString*)time
{
    MMDateFormatter* df = [[MMDateFormatter alloc] initWithDefaults:dateDefaults];
   return [df getTimsSlot:time];
}


+(NSString*)currentFormattedDate
{
   return [FormatterCollection formatDate:[NSDate date]
                             format:kDateFormatTypeFullDate];

}



#pragma marks -- UTC date
+ (NSString*)utc_formatDate:(NSDate*)date format:(NSString*)formatString
{
    MMDateFormatter* df = [[MMDateFormatter alloc] initWithDefaults:utcdateDefaults];
    NSString* result = [df formatDate:date format:formatString];
    return result;
}

+(NSString*)utc_parseDate:(NSString*)date format:(NSString*)formatString
{
    MMDateFormatter* df = [[MMDateFormatter alloc] initWithDefaults:dateDefaults];
    NSDate *objdate =[df utc_dateFromString:date format:kDateFormatTypeZFormatted];
    
    NSString *result = [FormatterCollection formatDate:objdate format:formatString];
    return result;
    
}
+(NSString*)utc_timeAgoWithUTCDate:(NSString*)strDate
{
    MMDateFormatter* df = [[MMDateFormatter alloc] initWithDefaults:utcdateDefaults];
    
    return [df utc_timeAgoWithUTCDate:strDate];
}

+(NSDate *)utc_dateFromString:(NSString *)dateString format:(NSString *)format
{
    MMDateFormatter* df = [[MMDateFormatter alloc] initWithDefaults:utcdateDefaults];
    
    return [df utc_dateFromString:dateString format:format];
}

+(NSString*)utc_stringFromDate:(NSDate*)date
                    formatType:(DateFormatType)dateFormatType
{
    if(dateFormatType==DateFormatTypeFullDate)
    {
        return [FormatterCollection utc_formatDate:date
                                        format:kDateFormatTypeFullDate];
    }
    else  if(dateFormatType==DateFormatTypeTypeBasic)
    {
        return [FormatterCollection utc_formatDate:date
                                            format:kDateFormatTypeBasic];
        
    }
   else{
        return [FormatterCollection utc_formatDate:date
                                        format:kDateFormatTypeZFormatted];
        
    }
    
}


+(NSString*)utc_formattedDateFromDateStr:(NSString*)date
                              formatType:(DateFormatType)dateFormatType
{
    return [FormatterCollection utc_stringFromDate:[self utc_dateFromString:date format:kDateFormatTypeZFormatted] formatType:dateFormatType];
}

+(NSString*)utc_dateFromTimeStamp:(double)timestamp
{
    return [FormatterCollection formatDate:[NSDate dateWithTimeIntervalSince1970:timestamp]
                                    format:kDateFormatTypeFullDate];
    
}


@end
