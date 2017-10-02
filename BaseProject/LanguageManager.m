//
//  LanguageManager.m
//  VivinoV2
//
//  Created by Admin on 17/04/14.
//
//

#import <objc/runtime.h>
#import "LanguageManager.h"

NSString* const kUserPreferedLanguageKey = @"userPreferedLanguage";
NSString* const kUserPreferedLocaleKey = @"userPreferedLocale";

/*
"english_lng"="English";
"hindi_lng"="Hindi";
"tamil_lng"="Tamil";
"kanada_lng"="Kannada";
"bengali_lng"="Bengali";
"telugu_lng"="Telugu";
"marathi_lng"="Marathi";
"gujarati_lng"="Gujarati";
"malayalam_lng"="Malayalam";
"odia_lng"="Odia";
"punjabi_lng"="Punjabi";
"assamese_lng"="Assamese";*/

#define LANGUAGE_ENGLISH_CODE @"en"
#define LANGUAGE_ENGLISH_LOCALE_CODE @"en_US"

#define LANGUAGE_HINDI_CODE @"hi"
#define LANGUAGE_HINDI_LOCALE_CODE @"en_US"

#define LANGUAGE_TAMIL_CODE @"ta-IN"
#define LANGUAGE_TAMIL_LOCALE_CODE @"en_US"

#define LANGUAGE_KANNADA_CODE @"kn-IN"
#define LANGUAGE_KANNADA_LOCALE_CODE @"en_US"

#define LANGUAGE_BENGALI_CODE @"bn-IN"
#define LANGUAGE_BENGALI_LOCALE_CODE @"en_US"

#define LANGUAGE_TELUGU_CODE @"te-IN"
#define LANGUAGE_TELUGU_LOCALE_CODE @"en_US"

#define LANGUAGE_MARATHI_CODE @"mr-IN"
#define LANGUAGE_MARATHI_LOCALE_CODE @"en_US"

#define LANGUAGE_GUJRATI_CODE @"gu-IN"
#define LANGUAGE_GUJRATI_LOCALE_CODE @"en_US"

#define LANGUAGE_MALAYALAM_CODE @"ml-IN"
#define LANGUAGE_MALAYALAM_LOCALE_CODE @"en_US"

#define LANGUAGE_ODIA_CODE @"or-IN"
#define LANGUAGE_ODIA_LOCALE_CODE @"en_US"

#define LANGUAGE_PUNJABI_CODE @"pa-IN"
#define LANGUAGE_PUNJABI_LOCALE_CODE @"en_US"

#define LANGUAGE_ASSAMESE_CODE @"as-IN"
#define LANGUAGE_ASSAMESE_LOCALE_CODE @"en_US"

typedef NS_ENUM(NSInteger, LanguageManagerLanguage) {
    LanguageManagerLanguageEnglish=0,
    LanguageManagerLanguageHindi=1,
    LanguageManagerLanguageTamil=2,
    LanguageManagerLanguageKannada=3,
    LanguageManagerLanguageBengali=4,

    LanguageManagerLanguageTelugu=5,
    LanguageManagerLanguageMarathi=9,
    LanguageManagerLanguageGujarati=6,
    LanguageManagerLanguageMalayalam=7,
    LanguageManagerLanguageOdia=8,
    LanguageManagerLanguagePunjabi=10,
    LanguageManagerLanguageAssamese=11
};

@interface LanguageManager ()

@property (nonatomic, strong) NSBundle* bundle;
@property (nonatomic, strong) NSArray* supportedLanguages;

@end

@implementation LanguageManager

+ (NSString*)get:(NSString*)key alter:(NSString*)alternate
{
    return [[LanguageManager sharedInstance] get:key
                                           alter:alternate];
}

+ (NSInteger)getPerferedLanguageInInteger
{
    return [[LanguageManager sharedInstance] getPerferedLanguageInInteger];
}


+ (NSString*)nativeLanguageNameForLocale:(NSString*)isoIdentifier
{
    return [[LanguageManager sharedInstance] nativeLanguageNameForLocale:isoIdentifier];
}

+ (NSString*)getPerferedLocaleCode
{
    return [[LanguageManager sharedInstance] getPerferedLocaleCode];
}

+ (NSLocale*)getPerferedLocale
{
    return [[LanguageManager sharedInstance] getPerferedLocale];
}

+ (NSString*)getPerferedLanguage
{
    return [[LanguageManager sharedInstance] getPerferedLanguage];
}

+ (NSString*)getPerferedLanguageForServer
{
    return [[LanguageManager sharedInstance] getPerferedLanguageForServer];
}

+ (NSString*)getPluralizedString:(NSString*)key
                      withNumber:(CGFloat)n
                           alter:(NSString*)alternate
{
    return [[LanguageManager sharedInstance] getPluralizedString:key
                                                      withNumber:n
                                                           alter:alternate];
}

+ (NSString*)getLocalizeCountryNameWithCode:(NSString*)countryCode
{
    return [[LanguageManager sharedInstance] getLocalizeCountryNameWithCode:countryCode];
}

+ (NSString*)getLocalizeCurrencyNameWithCode:(NSString*)currencyCode
{
    return [[LanguageManager sharedInstance] getLocalizeCurrencyNameWithCode:currencyCode];
}

+ (UIImage*)getLocalizedImage:(NSString*)imageName
{
    return [[LanguageManager sharedInstance] getLocalizedImage:imageName];
}

+ (NSLocale*)getCurrentLocale
{
    return [[LanguageManager sharedInstance] getCurrentLocale];
}

+ (void)setUserPerferedLanguage:(NSString*)language
                     withLocale:(NSString*)locale
{
    return [[LanguageManager sharedInstance] setUserPerferedLanguage:language
                                                          withLocale:locale];
}

+ (void)setLanguageWithIntType:(NSInteger)language_value
{
    return [[LanguageManager sharedInstance] setLanguageWithIntType:language_value];
}

+ (void)setLanguageAsEnglish
{
    return [[LanguageManager sharedInstance] setLanguageAsEnglish];
}

+ (void)setLanguageAsHindi
{
    return [[LanguageManager sharedInstance] setLanguageAsHindi];
}

+ (void)setLanguageAsTamil
{
    return [[LanguageManager sharedInstance] setLanguageAsTamil];
}

+ (void)setLanguageAsKannada
{
    return [[LanguageManager sharedInstance] setLanguageAsKannada];
}

+ (void)setLanguageAsBengali
{
    return [[LanguageManager sharedInstance] setLanguageAsBengali];
}

+ (void)setLanguageAsTelugu
{
    return [[LanguageManager sharedInstance] setLanguageAsTelugu];
}

+ (void)setLanguageAsMarathi
{
    return [[LanguageManager sharedInstance] setLanguageAsMarathi];
}

+ (void)setLanguageAsGujrati
{
    return [[LanguageManager sharedInstance] setLanguageAsGujrati];
}

+ (void)setLanguageAsMalayalam
{
    return [[LanguageManager sharedInstance] setLanguageAsMalayalam];
}

+ (void)setLanguageAsOdia
{
    return [[LanguageManager sharedInstance] setLanguageAsOdia];
}

+ (void)setLanguageAsPunjabi
{
    return [[LanguageManager sharedInstance] setLanguageAsPunjabi];
}
+ (void)setLanguageAsAssamese
{
    return [[LanguageManager sharedInstance] setLanguageAsAssamese];
}

+ (LanguageManager*)sharedInstance
{
    static LanguageManager* sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {

        


        _supportedLanguages = @[
                                LANGUAGE_ENGLISH_CODE,
                                LANGUAGE_HINDI_CODE,
                                LANGUAGE_TAMIL_CODE,
                                LANGUAGE_KANNADA_CODE,
                                LANGUAGE_BENGALI_CODE,
                                LANGUAGE_TELUGU_CODE,
                              //  LANGUAGE_MARATHI_CODE,
                                LANGUAGE_GUJRATI_CODE,
                                LANGUAGE_MALAYALAM_CODE,
                                LANGUAGE_ODIA_CODE,
                             //   LANGUAGE_PUNJABI_CODE,
                             //   LANGUAGE_ASSAMESE_CODE
        ];

        [self setUserPerferedLanguage:[self getPerferedLanguage]
                           withLocale:[self getPerferedLocaleCode]];
    }

    return self;
}
-(NSArray*)supportedLanguages
{
    return _supportedLanguages;
}
- (NSString*)get:(NSString*)key alter:(NSString*)alternate
{
    return [_bundle localizedStringForKey:key
                                    value:alternate
                                    table:nil];
}

- (NSString*)getPluralizedString:(NSString*)key
                      withNumber:(CGFloat)n
                           alter:(NSString*)alternate
{

    /*return [_bundle pluralizedStringWithKey:key
                               defaultValue:@""
                                      table:@""
                                pluralValue:n
                            forLocalization:[LanguageManager getPerferedLanguage]];*/
    return nil;
}

- (void)setUserPerferedLanguage:(NSString*)language
                     withLocale:(NSString*)locale
{
    if (language == nil) {
        [self setDefaultLanguage];
    } else {
        [self setLanguageInUserDefaultsWithLangaueCode:language
                                        withLocaleCode:locale];
    }
}

- (void)setLanguageWithIntType:(NSInteger)language_value
{
    
 
    switch (language_value) {
    case LanguageManagerLanguageEnglish:
        [self setLanguageAsEnglish];
        break;

    case LanguageManagerLanguageHindi:
        [self setLanguageAsHindi];
        break;

    case LanguageManagerLanguageTamil:
        [self setLanguageAsTamil];
        break;

    case LanguageManagerLanguageKannada:
        [self setLanguageAsKannada];
        break;

    case LanguageManagerLanguageBengali:
        [self setLanguageAsBengali];
        break;

   case LanguageManagerLanguageTelugu:
        [self setLanguageAsTelugu];
        break;

    case LanguageManagerLanguageMarathi:
        [self setLanguageAsMarathi];
        break;

    case LanguageManagerLanguageGujarati:
        [self setLanguageAsGujrati];
        break;
   
    case LanguageManagerLanguageMalayalam:
        [self setLanguageAsMalayalam];
        break;
        
    case LanguageManagerLanguageOdia:
        [self setLanguageAsOdia];
        break;
        
    case LanguageManagerLanguagePunjabi:
        [self setLanguageAsPunjabi];
        break;

    case LanguageManagerLanguageAssamese:
        [self setLanguageAsAssamese];
        break;
            

    default:
        break;
    }
}

- (void)setLanguageInUserDefaultsWithLangaueCode:(NSString*)language
                                  withLocaleCode:(NSString*)locale
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
   /*  NSArray* languages = [NSArray arrayWithObject:language];
   [[NSUserDefaults standardUserDefaults] setObject:languages
                                              forKey:@"AppleLanguages"];*/

    [defaults setObject:language
                 forKey:kUserPreferedLanguageKey];
    [defaults setObject:locale
                 forKey:kUserPreferedLocaleKey];
    [defaults synchronize];
   NSString* path =
        [[NSBundle mainBundle] pathForResource:language
                                        ofType:@"lproj"];
    _bundle = [NSBundle bundleWithPath:path];
}

- (void)setDefaultLanguage
{
    // need to set default lanague
    NSString* language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSString* locale = @"";
    if (![_supportedLanguages
            containsObject:language]) // set default langaue as english
    {
        language = LANGUAGE_ENGLISH_CODE;
        locale = LANGUAGE_ENGLISH_LOCALE_CODE;
    } else {

         if ([language isEqualToString:LANGUAGE_HINDI_CODE]) {
            language = LANGUAGE_HINDI_CODE;
            locale = LANGUAGE_HINDI_LOCALE_CODE;

        } else if ([language isEqualToString:LANGUAGE_TAMIL_CODE]) {
            language = LANGUAGE_TAMIL_CODE;
            locale = LANGUAGE_TAMIL_LOCALE_CODE;

        } else if ([language isEqualToString:LANGUAGE_KANNADA_CODE]) {
            language = LANGUAGE_KANNADA_CODE;
            locale = LANGUAGE_KANNADA_LOCALE_CODE;

        }else if ([language isEqualToString:LANGUAGE_BENGALI_CODE]) {
            language = LANGUAGE_BENGALI_CODE;
            locale = LANGUAGE_BENGALI_LOCALE_CODE;
        }else if ([language isEqualToString:LANGUAGE_TELUGU_CODE]) {
            language = LANGUAGE_TELUGU_CODE;
            locale = LANGUAGE_TELUGU_LOCALE_CODE;
        }  else if ([language isEqualToString:LANGUAGE_MARATHI_CODE]) {
            language = LANGUAGE_MARATHI_CODE;
            locale = LANGUAGE_MARATHI_LOCALE_CODE;
        }  else if ([language isEqualToString:LANGUAGE_GUJRATI_CODE]) {
            language = LANGUAGE_GUJRATI_CODE;
            locale = LANGUAGE_GUJRATI_LOCALE_CODE;
        }
        else if ([language isEqualToString:LANGUAGE_MALAYALAM_CODE]) {
            language = LANGUAGE_MALAYALAM_CODE;
            locale = LANGUAGE_MALAYALAM_LOCALE_CODE;
        }
        else if ([language isEqualToString:LANGUAGE_ODIA_CODE]) {
            language = LANGUAGE_ODIA_CODE;
            locale = LANGUAGE_ODIA_LOCALE_CODE;
        }
        else if ([language isEqualToString:LANGUAGE_PUNJABI_CODE]) {
            language = LANGUAGE_PUNJABI_CODE;
            locale = LANGUAGE_PUNJABI_LOCALE_CODE;
        }
        else if ([language isEqualToString:LANGUAGE_ASSAMESE_CODE]) {
            language = LANGUAGE_ASSAMESE_CODE;
            locale = LANGUAGE_ASSAMESE_LOCALE_CODE;
        }
        else
        {
            language = LANGUAGE_ENGLISH_CODE;
            locale = LANGUAGE_ENGLISH_LOCALE_CODE;
        }
        
    }

    [self setLanguageInUserDefaultsWithLangaueCode:language
                                    withLocaleCode:locale];
}

- (void)setLanguageAsEnglish
{
    [self setUserPerferedLanguage:LANGUAGE_ENGLISH_CODE
                       withLocale:LANGUAGE_ENGLISH_LOCALE_CODE];
}

- (void)setLanguageAsHindi
{
    [self setUserPerferedLanguage:LANGUAGE_HINDI_CODE
                       withLocale:LANGUAGE_HINDI_LOCALE_CODE];
}

- (void)setLanguageAsTamil
{
    [self setUserPerferedLanguage:LANGUAGE_TAMIL_CODE
                       withLocale:LANGUAGE_TAMIL_LOCALE_CODE];

}

- (void)setLanguageAsKannada
{
    [self setUserPerferedLanguage:LANGUAGE_KANNADA_CODE
                       withLocale:LANGUAGE_KANNADA_LOCALE_CODE];

}

- (void)setLanguageAsBengali
{
    [self setUserPerferedLanguage:LANGUAGE_BENGALI_CODE
                       withLocale:LANGUAGE_BENGALI_LOCALE_CODE];

}

- (void)setLanguageAsTelugu
{
    [self setUserPerferedLanguage:LANGUAGE_TELUGU_CODE
                       withLocale:LANGUAGE_TELUGU_LOCALE_CODE];
}

- (void)setLanguageAsMarathi
{
    [self setUserPerferedLanguage:LANGUAGE_MARATHI_CODE
                       withLocale:LANGUAGE_MARATHI_LOCALE_CODE];
}

- (void)setLanguageAsGujrati
{
    [self setUserPerferedLanguage:LANGUAGE_GUJRATI_CODE
                       withLocale:LANGUAGE_GUJRATI_LOCALE_CODE];
}

- (void)setLanguageAsMalayalam
{
    [self setUserPerferedLanguage:LANGUAGE_MALAYALAM_CODE
                       withLocale:LANGUAGE_MALAYALAM_LOCALE_CODE];
}

- (void)setLanguageAsOdia
{
    [self setUserPerferedLanguage:LANGUAGE_ODIA_CODE
                       withLocale:LANGUAGE_ODIA_LOCALE_CODE];
}

- (void)setLanguageAsPunjabi
{
    [self setUserPerferedLanguage:LANGUAGE_PUNJABI_CODE
                       withLocale:LANGUAGE_PUNJABI_LOCALE_CODE];
}
- (void)setLanguageAsAssamese
{
    [self setUserPerferedLanguage:LANGUAGE_ASSAMESE_CODE
                       withLocale:LANGUAGE_ASSAMESE_LOCALE_CODE];

}

- (NSString*)getPerferedLanguage
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kUserPreferedLanguageKey];
}

- (NSString*)getPerferedLocaleCode
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kUserPreferedLocaleKey];
}

- (NSLocale*)getPerferedLocale
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* isoIdentifier = [defaults objectForKey:kUserPreferedLocaleKey];
    return [[NSLocale alloc] initWithLocaleIdentifier:isoIdentifier];
}

- (NSString*)getPerferedLanguageForServer
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *val= [[[defaults objectForKey:kUserPreferedLanguageKey] componentsSeparatedByString:@"-"] firstObject];
    if (val == nil)
    {
        [self setLanguageWithIntType:0];
       return [self getPerferedLanguage];
    }
    else
    {
        return val;
    }
}


- (NSLocale*)getCurrentLocale
{
    return [[NSLocale alloc]
        initWithLocaleIdentifier:[LanguageManager getPerferedLocaleCode]];
}

- (NSString*)getLocalizeCountryNameWithCode:(NSString*)countryCode
{
    NSLocale* usLocale = [self getCurrentLocale];
    return [usLocale displayNameForKey:NSLocaleCountryCode
                                 value:countryCode];
}

- (NSString*)getLocalizeCurrencyNameWithCode:(NSString*)currencyCode
{
    NSLocale* usLocale = [self getCurrentLocale];

    return [[usLocale displayNameForKey:NSLocaleCurrencyCode
                                  value:currencyCode] capitalizedStringWithLocale:usLocale];
}

- (NSInteger)getPerferedLanguageInInteger
{
    
    NSInteger language_int_value = LanguageManagerLanguageEnglish;
    NSString* language = [self getPerferedLanguage];
    if ([language isEqualToString:LANGUAGE_ENGLISH_CODE])
        language_int_value = LanguageManagerLanguageEnglish;
    else if ([language isEqualToString:LANGUAGE_HINDI_CODE])
        language_int_value = LanguageManagerLanguageHindi;
    else if ([language isEqualToString:LANGUAGE_TAMIL_CODE])
        language_int_value = LanguageManagerLanguageTamil;
    else if ([language isEqualToString:LANGUAGE_KANNADA_CODE])
        language_int_value = LanguageManagerLanguageKannada;
    else if (([language isEqualToString:LANGUAGE_BENGALI_CODE]))
        language_int_value = LanguageManagerLanguageBengali;
    else if ([language isEqualToString:LANGUAGE_TELUGU_CODE])
        language_int_value = LanguageManagerLanguageTelugu;
    else if ([language isEqualToString:LANGUAGE_MARATHI_CODE])
        language_int_value = LanguageManagerLanguageMarathi;
    else if ([language isEqualToString:LANGUAGE_GUJRATI_CODE])
        language_int_value = LanguageManagerLanguageGujarati;
    else if ([language isEqualToString:LANGUAGE_MALAYALAM_CODE])
        language_int_value = LanguageManagerLanguageMalayalam;
    else if ([language isEqualToString:LANGUAGE_ODIA_CODE])
        language_int_value = LanguageManagerLanguageOdia;
    else if ([language isEqualToString:LANGUAGE_PUNJABI_CODE])
        language_int_value = LanguageManagerLanguagePunjabi;
    else if ([language isEqualToString:LANGUAGE_ASSAMESE_CODE])
        language_int_value = LanguageManagerLanguageAssamese;
    
    return language_int_value;
    
    
}

- (NSString*)nativeLanguageNameForLocale:(NSString*)isoIdentifier
{
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:isoIdentifier];
    return [[locale displayNameForKey:NSLocaleIdentifier
                                value:isoIdentifier]
        capitalizedStringWithLocale:locale];
}

- (UIImage*)getLocalizedImage:(NSString*)imageName
{
  
    return [UIImage imageWithContentsOfFile:[_bundle pathForResource:imageName
                                                              ofType:@"png"]];
}

+ (BOOL)isEnglishLanguage
{
    return [[LanguageManager getPerferedLanguage] isEqualToString:LANGUAGE_ENGLISH_CODE];
}

@end
