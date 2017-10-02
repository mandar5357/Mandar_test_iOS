

#import "NSString+checkEmpty.h"
#import "RegExCategories.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (checkEmpty)

- (BOOL)isEmpty
{
    return (
        self == nil ||
        [self rangeOfString:@"null"].location != NSNotFound ||
        [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 ||
        [self isEqual:[NSNull null]] ||
        [self isEqualToString:@""]);
}

- (BOOL)isNotEmpty
{
    return ![self isEmpty];
}

- (NSString*)replaceOnEmpty:(NSString*)replacement
{
    return [self isEmpty] ? replacement : self;
}

- (NSString*)emptyAsBlank
{
    return [self replaceOnEmpty:@""];
}

- (NSString*)emptyAsHyphen
{
    return [self isEmpty] ? @"-" : [self isEqualToString:@"0"]? @"-": self;
}

-(NSString *)replaceQuotationMark
{
   return  [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

-(NSString *)replaceNewLineCharacter
{
    return  [self stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
}

- (NSString*)replacePunctuations
{
    NSString* originalStr = self;
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"." withString:@" "];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"," withString:@" "];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"?" withString:@" "];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"!" withString:@" "];
    //self =  [self stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@":" withString:@" "];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@";" withString:@" "];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"..." withString:@" "];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\"" withString:@" "];

    return originalStr;
}

- (NSInteger)getWordsCount
{
    NSString* originalStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];

    originalStr = [regex stringByReplacingMatchesInString:originalStr options:0 range:NSMakeRange(0, [originalStr length]) withTemplate:@" "];
    return [[originalStr componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] count];
}

- (NSInteger)getAgeFromBirthDate
{
    // birthday = "10/25/1988";
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSDate* birthday = [dateFormat dateFromString:self];

    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
        components:NSYearCalendarUnit
          fromDate:birthday
            toDate:now
           options:0];
    NSInteger age = [ageComponents year];

    return age;
}


// From http://stackoverflow.com/questions/1058736/how-to-create-a-nsstring-from-a-format-string-like-xxx-yyy-and-a-nsarr#1061750
+ (id)stringWithFormat:(NSString *)format array:(NSArray*)arguments
{/*
    __unsafe_unretained id  * argList = (__unsafe_unretained id  *) calloc(1UL, sizeof(id) * arguments.count);
    for (NSInteger i = 0; i < arguments.count; i++) {
        argList[i] = arguments[i];
    }
    
    NSString* result;
#ifdef __LP64__
    result = [[NSString alloc] initWithFormat:format, *argList] ;//  arguments:(void *) argList];
#else
    result = [[NSString alloc] initWithFormat:format arguments:(void *) argList];
#endif
    free (argList);
>>>>>>> origin/7.6.0_bit64
    return result;
     */
    NSArray* subStrings = [format split:RX(@"%.{0,2}@")];
    NSInteger placeholderCount = [subStrings count] - 1;
    NSInteger argumentCount = [arguments count];

    if (placeholderCount != argumentCount) {
        NSException* myException = [NSException
            exceptionWithName:@"NSStringException"
                       reason:[NSString stringWithFormat:@"Argument and placholder count mismatch. Argument count: %ld, placeholder count: %ld", (long)argumentCount, (long)placeholderCount]
                     userInfo:nil];
        NSLog(@"%@",myException);
        @throw myException;
    }

    NSMutableString *tmp = [NSMutableString new];
    
    for (NSInteger i = 0; i <= placeholderCount; i++) {
        NSString *sub = subStrings[i];
        [tmp appendString:sub];
        if (i < placeholderCount) {
            [tmp appendFormat:@"%@", arguments[i]];
        }
    }
    
    return [NSString stringWithString:tmp];
}





- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr,(CC_LONG) strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
// Added in iOS 8, retrofitted for iOS 7
- (BOOL)containsString:(NSString*)other {
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}
#endif

@end
