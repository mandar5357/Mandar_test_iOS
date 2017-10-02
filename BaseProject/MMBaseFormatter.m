
#import "MMBaseFormatter.h"

@interface MMBaseFormatter ()

@property (nonatomic, strong) VVFormatterDefaultsBlock defaults;
@property (nonatomic, strong) MMFormatter* formatter;

@end

@implementation MMBaseFormatter

#pragma mark - Formatter cache


/**
 *  Look up or create cached formatter instances for the provided VVBaseFormatter implementation
 *
 *  @discussion Some NSFormatters break if they are reconfigured hence we need to cache a number of them. NSCache will throw away content if the app receives a memory warning.
 */
+ (MMFormatter*)formatterForImplementation:(id<VVFormatterImplementation>)implementation
{
    static NSCache* _formatters = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatters = [NSCache new];
    });

    NSString* key = [implementation cacheKey];
    MMFormatter* res = [_formatters objectForKey:key];
    if (!res) {
        id formatter = [implementation formatterInstance];
        res = [[MMFormatter alloc] initWithFormatter:formatter];
        [_formatters setObject:res forKey:key];
    }
    return res;
}

#pragma mark - Initializer

- (instancetype)initWithDefaults:(VVFormatterDefaultsBlock)defaults
{
    if (!(self = [super init]))
        return nil;

    _defaults = defaults;

    return self;
}

/**
 *  Run block on formatter
 *
 *  @discussion Lazy instantiation of formatters happens here
 */
- (id)format:(VVFormatterBlock)formatBlock
{
    if (!_formatter) {
        // Lazy instantiation of formatters happens here
        _formatter = [MMBaseFormatter formatterForImplementation:(id<VVFormatterImplementation>)self];
    }

    return [self.formatter formatWithDefaults:_defaults format:formatBlock];
}

@end
