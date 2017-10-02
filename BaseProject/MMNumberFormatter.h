
#import "MMBaseFormatter.h"

/**
 *  Subclass of VVBaseFormatter for formatting NSNumbers. Always runs on a NSNumberFormatter.
 */
@interface MMNumberFormatter : MMBaseFormatter <VVFormatterImplementation>

/**
 *  Initializer for a specific numberstyle
 *
 *  @param numberStyle NSNumberFormatterStyle specification for the NSNumberFormatter.
 *  @param defaults    Formatter defaults block.
 *
 *  @return An instance of VVNumberFormatter.
 */
- (instancetype)initWithNumberStyle:(NSNumberFormatterStyle)numberStyle defaults:(VVFormatterDefaultsBlock)defaults NS_DESIGNATED_INITIALIZER;

@end
