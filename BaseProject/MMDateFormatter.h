
#import "MMBaseFormatter.h"

/**
 *  VVBaseFormatter subclass for formatting NSDates. Always runs on a NSDateFormatter.
 */

#pragma mark - Helpers

#define SECONDS_IN_A_MINUTE 60
#define SECONDS_IN_A_HOUR  3600
#define SECONDS_IN_A_DAY 86400
#define SECONDS_IN_A_MONTH_OF_30_DAYS 2592000
#define SECONDS_IN_A_YEAR_OF_MONTH_OF_30_DAYS 31104000

@interface MMDateFormatter : MMBaseFormatter <VVFormatterImplementation>

/**
 *  Format a date to a specific format
 *
 *  @param date         Date to format.
 *  @param formatString Date format string.
 *
 *  @return Formatted date.
 */
- (NSString*)formatDate:(NSDate*)date format:(NSString*)formatString;
/**
 *  Format a date to the format for the formatters locale
 *
 *  @param date         Date to format
 *  @param formatString Format string containing the date components that should go into the result
 *
 *  @return Date formatted for the formatters locale.
 */
- (NSString*)localeAwareFormatDate:(NSDate*)date format:(NSString*)formatString;

- (NSDate*)parseDate:(NSString*)dateString format:(NSString*)format;

- (NSDate*)localeAwareParseDate:(NSString*)dateString format:(NSString*)formatString;

-(NSString*)getTimsSlot:(NSString*)time;//getTimeSlot in am/pm;
-(NSDate *)utc_dateFromString:(NSString *)dateString                    format:(NSString*)format;

-(NSString *)dateStrFromDate:(NSDate *)date;
-(NSString*)utc_stringFromDate:(NSDate*)date format:(NSString*)format;
-(NSString*)utc_timeAgoWithUTCDate:(NSString*)strDate;
@end
