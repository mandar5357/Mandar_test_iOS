
#import "MMDateFormatter.h"

@implementation MMDateFormatter

#pragma mark - <VVFormatterImplementation>

- (NSDateFormatter*)formatterInstance
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    return formatter;
}

- (NSString*)cacheKey
{
    return @"NSDateFormatter";
}

#pragma marks -- Helper functions

- (NSString *)timeAgo:(NSDate *)date {
    NSTimeInterval distanceBetweenDates = [date timeIntervalSinceDate:[NSDate date]] * (-1);
    NSInteger distance = (NSInteger)floorf(distanceBetweenDates);
    if (distance <= 0) {
        return SSLocalizedString(@"now", nil);
    }
    else if (distance < SECONDS_IN_A_MINUTE) {
        return   [NSString stringWithFormat:SSPluralizedString(@"%ld seconds", distance, nil),distance];
    }
    else if (distance < SECONDS_IN_A_HOUR) {
        distance = distance / SECONDS_IN_A_MINUTE;
        return   [NSString stringWithFormat:SSPluralizedString(@"%ld minutes", distance, nil),distance];
    }
    else if (distance < SECONDS_IN_A_DAY) {
        distance = distance / SECONDS_IN_A_HOUR;
        return   [NSString stringWithFormat:SSPluralizedString(@"%ld hours", distance, nil),distance];
    }
    else if (distance < SECONDS_IN_A_MONTH_OF_30_DAYS) {
        distance = distance / SECONDS_IN_A_DAY;
        return   [NSString stringWithFormat:SSPluralizedString(@"%ld days", distance, nil),distance];
    }
    else if (distance < SECONDS_IN_A_YEAR_OF_MONTH_OF_30_DAYS) {
        distance = distance / SECONDS_IN_A_MONTH_OF_30_DAYS;
        return   [NSString stringWithFormat:SSPluralizedString(@"%ld months", distance, nil),distance];
    } else {
        distance = distance / SECONDS_IN_A_YEAR_OF_MONTH_OF_30_DAYS;
        return   [NSString stringWithFormat:SSPluralizedString(@"%ld years", distance, nil),distance];
    }
}


#pragma mark - Date formatting methods

- (NSString*)formatDate:(NSDate*)date format:(NSString*)formatString
{
    NSString* result = [self format:^id(NSDateFormatter* formatter) {
        formatter.dateFormat = formatString;
        NSString *res = [formatter stringFromDate:date];
        return res;
    }];
    return result;
}

- (NSString*)localeAwareFormatDate:(NSDate*)date format:(NSString*)formatString
{
    NSString* result = [self format:^id(NSDateFormatter* formatter) {
        NSString *localizedFormat = [NSDateFormatter dateFormatFromTemplate:formatString options:0 locale:formatter.locale];
        formatter.dateFormat = localizedFormat;
        NSString *res = [formatter stringFromDate:date];
        return res;
    }];
    return result;
}

- (NSDate*)parseDate:(NSString*)dateString format:(NSString*)formatString
{
    NSDate* result = [self format:^id(NSDateFormatter* formatter) {
     
        [formatter setDateFormat:formatString];
        NSDate *res = [formatter dateFromString:dateString];
        return res;
    }];
    return result;
}

- (NSDate*)localeAwareParseDate:(NSString*)dateString format:(NSString*)formatString
{
    NSDate* result = [self format:^id(NSDateFormatter* formatter) {
        NSString *localizedFormat = [NSDateFormatter dateFormatFromTemplate:formatString options:0 locale:formatter.locale];
        formatter.dateFormat = localizedFormat;
        NSDate *res = [formatter dateFromString:dateString];
        return res;
    }];
    return result;
}

-(NSString*)getTimsSlot:(NSString*)time//getTimeSlot in am/pm
{
    NSString *dats1 = time;
    
    NSString*result = [self format:^id(NSDateFormatter* formatter) {
        formatter.dateFormat = @"HH:mm";
        NSDate *res = [formatter dateFromString:dats1];
        [formatter setDateFormat:@"hh:mm a"];
        
        return [formatter stringFromDate:res];
    }];
    return result;
    
    
}

-(NSString *)dateStrFromDate:(NSDate *)date
{
    return [self localeAwareFormatDate:date format:kDateFormatTypeZFormatted];
    
}
-(NSDate*)localeDateFromString:(NSString*)dateString format:(NSString*)format
{

    NSDate *result = [self format:^id(NSDateFormatter* formatter) {
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setDateFormat:format];
        return [formatter dateFromString:dateString];
    }];
    return result;
}

-(NSDate*)localeDateFromString:(NSString*)dateString
{
    return [self localeDateFromString:dateString format:kDateFormatTypeZFormatted];
}

#pragma marks -- UTC date functions
-(NSString*)utc_timeAgoWithUTCDate:(NSString*)strDate
{
    NSDate *date =[self utc_dateFromString:strDate format:kDateFormatTypeZFormatted];
    return [self timeAgo:date];
}

-(NSDate *)utc_dateFromString:(NSString *)dateString                   format:(NSString*)format;
{
    
    NSDate *result = [self format:^id(NSDateFormatter* formatter) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [formatter setDateFormat:format];
        return [formatter dateFromString:dateString];
    }];
    return result;
    
}

-(NSString*)utc_stringFromDate:(NSDate*)date format:(NSString*)format
{
    NSString *result = [self format:^id(NSDateFormatter* formatter) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [formatter setDateFormat:kDateFormatTypeZFormatted];
        return [formatter stringFromDate:date];
    }];
    return result;
}



@end
