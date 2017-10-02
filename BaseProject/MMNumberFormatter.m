
#import "MMNumberFormatter.h"

@interface MMNumberFormatter ()

@property (nonatomic) NSNumberFormatterStyle numberStyle;

@end

@implementation MMNumberFormatter

- (instancetype)initWithDefaults:(VVFormatterDefaultsBlock)defaults
{
    return [self initWithNumberStyle:NSNumberFormatterNoStyle defaults:defaults];
}

- (instancetype)initWithNumberStyle:(NSNumberFormatterStyle)numberStyle defaults:(VVFormatterDefaultsBlock)defaults
{
    if (!(self = [super initWithDefaults:defaults]))
        return nil;

    _numberStyle = numberStyle;

    return self;
}

#pragma mark - <VVFormatterImplementation>

- (NSNumberFormatter*)formatterInstance
{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = _numberStyle;
    return formatter;
}

/**
 *  @discussion For the NSNumberFormatter there's a cached formatter instance for each numberStyle.
 */
- (NSString*)cacheKey
{
    return [NSString stringWithFormat:@"NSNumberFormatter.%ld", _numberStyle];
}

@end
