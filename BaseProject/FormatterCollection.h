
/*
 * This class wraps the shared formatters in convenience methods
 */

@interface FormatterCollection : NSObject

/*
 *  Currency formatters
 */

// Run a block on the shared currency formatter

+ (id)runCurrencyFormatterForCode:(NSString*)currencyCode withBlock:(id (^)(NSNumberFormatter* formatter))formatterBlock;

// Format currency for locale

+ (NSString*)formatCurrency:(NSNumber*)amount currencyCode:(NSString*)currencyCode localeIdentifier:(NSString*)localeIdentifier decimalPlaces:(NSInteger)decimals;
+ (NSString*)formatCurrency:(NSNumber*)amount currencyCode:(NSString*)currencyCode locale:(NSLocale*)locale decimalPlaces:(NSInteger)decimals;

/* 
 *  Decimal formatters
 */

// Run a block on the shared decimal formatter

+ (id)runDecimalFormatterWithBlock:(id (^)(NSNumberFormatter* formatter))formatterBlock;

// Parse decimal user input

+ (NSNumber*)parseDecimalInput:(NSString*)inputString localeIdentifier:(NSString*)localeIdentifier;
+ (NSNumber*)parseDecimalInput:(NSString*)inputString locale:(NSLocale*)locale;

// Format integers

+ (NSString*)formatInteger:(NSInteger)number;
+ (NSString*)formatNumberAsInteger:(NSNumber*)number;

// Format decimal numbers

+ (NSString*)formatDecimalNumber:(NSNumber*)number localeIdentifier:(NSString*)localeIdentifier;
+ (NSString*)formatDecimalNumber:(NSNumber*)number locale:(NSLocale*)locale;
+ (NSString*)formatDecimalNumber:(NSNumber*)number locale:(NSLocale*)locale decimalPlaces:(NSInteger)decimals;

// Utility for transforming decimal strings to and from canonical string description (en_US)

+ (NSString*)transformDecimalStringtoCanonical:(NSString*)inputString localeIdentifier:(NSString*)localeIdentifier;
+ (NSString*)transformDecimalStringtoCanonical:(NSString*)inputString locale:(NSLocale*)locale;
+ (NSString*)transformCanonicalStringtoDecimal:(NSString*)canonical localeIdentifier:(NSString*)localeIdentifier;
+ (NSString*)transformCanonicalStringtoDecimal:(NSString*)canonical locale:(NSLocale*)locale;

// Ordinal number formatters

+ (NSString*)ordinalStringFromNumber:(NSNumber*)number;
+ (NSString*)ordinalIndicatorFromNumber:(NSNumber*)number;

// Date formatters
+(NSDate*)pastDateWithDays:(NSInteger)days;
+ (NSString*)formatDate:(NSDate*)date format:(NSString*)formatString;
+ (NSString*)formatDateStr:(NSString*)dateStr format:(NSString*)formatString;
+ (NSString*)localeAwareFormatDate:(NSDate*)date format:(NSString*)formatString;
+ (NSDate*)parseDate:(NSString*)date format:(NSString*)formatString;
+(NSString*)localeDate_parseDate:(NSString*)date format:(NSString*)formatString;
+ (NSDate*)localeAwareParseDate:(NSString*)date format:(NSString*)formatString;


+(NSString*)getTimsSlot:(NSString*)time;//getTimeSlot in am/pm;


+(NSString*)currentFormattedDate;


#pragma marks --


#pragma marks -- UTC date
+ (NSString*)utc_formatDate:(NSDate*)date format:(NSString*)formatString;
+(NSString*)utc_parseDate:(NSString*)date format:(NSString*)formatString;
+(NSString*)utc_timeAgoWithUTCDate:(NSString*)strDate;
+(NSDate *)utc_dateFromString:(NSString *)dateString
                   format:(NSString*)format;
+(NSString*)utc_stringFromDate:(NSDate*)date
                    formatType:(DateFormatType)dateFormatType;
+(NSString*)utc_formattedDateFromDateStr:(NSString*)date
                              formatType:(DateFormatType)dateFormatType;

+(NSString*)utc_dateFromTimeStamp:(double)timestamp;
@end
