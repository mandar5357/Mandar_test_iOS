

#import <Foundation/Foundation.h>

@interface NSString (checkEmpty)

-(BOOL)isNotEmpty;
-(BOOL)isEmpty;
- (NSString*)replaceOnEmpty:(NSString*)replacement;
- (NSString*)emptyAsBlank;
- (NSString*)emptyAsHyphen;
- (NSString*)replacePunctuations;
- (NSString*)replaceNewLineCharacter;
- (NSInteger)getWordsCount;
- (NSInteger)getAgeFromBirthDate; //for date in MM/dd/yyyy
+ (id)stringWithFormat:(NSString *)format array:(NSArray*)arguments;
-(NSString *)replaceQuotationMark;

- (NSString*)MD5;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
// Added in iOS 8, retrofitted for iOS 7
- (BOOL)containsString:(NSString *)aString;
#endif

@end
