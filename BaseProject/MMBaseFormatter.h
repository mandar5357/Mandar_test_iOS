
#import "MMFormatter.h"

/**
 *  All subclasses of VVBaseFormatter implements this protocol
 */
@protocol VVFormatterImplementation

/**
 *  The cacheKey is used to look up a formatter instance in the shared formatter cache.
 *
 *  @discussion We need the key to identify the cached formatter instances for every VVBaseFormatter subclass. Bear in mind that the NSFormatter family does not always like to be reconfigured so if something breaks you might need to create more diverse cache keys in order to create cached formatter instances for specific configurations. This is a delicate balance. We want to keep enough instances so we don't need to reconfigure something that will break the NSFormatter. Vice versa we don't want to instantiate and cache too many instances for performance and memory reasons. There are some examples on how to create sensible cache keys in the provided VVBaseFormatter subclasses.
 *
 *  @return String that identifies the formatter instance for a given VVBaseFormatter subclass.
 */
- (NSString*)cacheKey;

/**
 *  Instantiates a fresh NSFormatter instance.
 *
 *  @discussion The specific NSFormatter subclass is unknown at this point hence the id return type.
 *
 *  @return A NSFormatter subclass instance.
 */
- (id)formatterInstance;

@end

/**
 *  VVBaseFormatter is the abstract superclass for specific formatter implementations.
 */
@interface MMBaseFormatter : NSObject

/**
 *  Initializer for the formatter instances.
 *
 *  @param defaults Formatter defaults block.
 *
 *  @return An instance of VVBaseFormatter
 */
- (instancetype)initWithDefaults:(VVFormatterDefaultsBlock)defaults NS_DESIGNATED_INITIALIZER;

/**
 *  Execute the formatter block on the formatter.
 *
 *  @discussion Execute instructions on the cached NSFormatter subclass and return a value. This method can be used if you want access to the raw NSFormatter.
 *
 *  @param formatBlock Formatter formatting block.
 *
 *  @return Any object which can be returned from a NSFormatter.
 */
- (id)format:(VVFormatterBlock)formatBlock;

@end
