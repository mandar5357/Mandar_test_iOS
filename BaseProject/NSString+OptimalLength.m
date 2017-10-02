

#import "NSString+OptimalLength.h"

@implementation NSString (OptimalLength)

- (NSString*)optimalStringForWidth:(CGFloat)width withFont:(UIFont*)font postfix:(NSString*)postfix
{
    NSString* result = [self copy];

    CGFloat currentWidth = [result VVSizeWithFont:font].width;

    if (currentWidth <= width)
        return result;

    NSInteger min = 0;
    NSInteger max = [result length] - 1;
    while (max >= min) {
        NSInteger mid = (min + max) / 2;

        result = [NSString stringWithFormat:@"%@%@", [self substringToIndex:mid], postfix];
        currentWidth = [result VVSizeWithFont:font].width;

        if (currentWidth <= width) {
            min = mid + 1;
        } else {
            max = mid - 1;
        }
    }
    return result;
}


-(UIFont*)getOptimalFontFromBaseFontName:(NSString*)fontName fontSize:(float)fontSize andConstrainedToSize:(CGSize)constrainedSize
{
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    CGSize size = [ self VVSizeWithFont:font constrainedToSize:CGSizeMake(constrainedSize.width, MAXFLOAT)  lineBreakMode:NSLineBreakByTruncatingTail];
    while (size.height >= constrainedSize.height ) {
        
        fontSize--;
        font = [UIFont fontWithName:Avenir_Next_LT_Pro_MediumCn size:fontSize];
        size = [ self VVSizeWithFont:font constrainedToSize:CGSizeMake(constrainedSize.width, MAXFLOAT)  lineBreakMode:NSLineBreakByTruncatingTail];
    }
    
    
    return font;
}

@end
