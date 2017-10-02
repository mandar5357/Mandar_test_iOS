//
//  LanguageManager.h
//  VivinoV2
//
//  Created by Admin on 17/04/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LanguageManager : NSObject

+ (LanguageManager*)sharedInstance;
-(NSArray*)supportedLanguages;
+ (NSString*)get:(NSString*)key alter:(NSString*)alternate;
+ (NSInteger)getPerferedLanguageInInteger;
+ (NSString*)nativeLanguageNameForLocale:(NSString*)isoIdentifier;
+ (NSString*)getPerferedLocaleCode;
+ (NSLocale*)getPerferedLocale;
+ (NSString*)getPerferedLanguage;
+ (NSString*)getPerferedLanguageForServer;
+ (NSString*)getPluralizedString:(NSString*)key
                      withNumber:(CGFloat)n
                           alter:(NSString*)alternate;

+ (NSString*)getLocalizeCountryNameWithCode:(NSString*)countryCode;
+ (NSString*)getLocalizeCurrencyNameWithCode:(NSString*)currencyCode;
+ (UIImage*)getLocalizedImage:(NSString*)imageName;

+ (NSLocale*)getCurrentLocale;

+ (void)setUserPerferedLanguage:(NSString*)language
                     withLocale:(NSString*)locale;
+ (void)setLanguageWithIntType:(NSInteger)language_value;
+ (void)setLanguageAsEnglish;
+ (void)setLanguageAsHindi;
+ (void)setLanguageAsTamil;
+ (void)setLanguageAsKannada;
+ (void)setLanguageAsBengali;
+ (void)setLanguageAsTelugu;
+ (void)setLanguageAsMarathi;
+ (void)setLanguageAsGujrati;
+ (void)setLanguageAsMalayalam;
+ (void)setLanguageAsOdia;
+ (void)setLanguageAsPunjabi;
+ (void)setLanguageAsAssamese;

+ (BOOL)isEnglishLanguage;
@end
