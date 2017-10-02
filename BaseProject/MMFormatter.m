

#import "MMFormatter.h"

@interface MMFormatter ()

@property (nonatomic, strong) dispatch_queue_t accessQueue;
@property (nonatomic, strong) id formatterInstance;

@end

@implementation MMFormatter

- (instancetype)initWithFormatter:(id)formatterInstance
{
    if (!(self = [super init]))
        return nil;

    _formatterInstance = formatterInstance;
    _accessQueue = dispatch_queue_create("com.ss.MMFormatter.accessQueue", DISPATCH_QUEUE_SERIAL);

    return self;
}

- (id)formatWithDefaults:(VVFormatterDefaultsBlock)defaults format:(VVFormatterBlock)formatBlock
{
    __block id result;
    dispatch_sync(_accessQueue, ^{
        if (defaults)
            defaults(_formatterInstance);
        result = formatBlock(_formatterInstance);
    });
    return result;
}

@end
