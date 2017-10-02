//
//  NSString+StringSizeWithFont.m
//  VivinoV2
//
//  Created by Sphinx Solution Pvt Ltd on 22/04/15.
//
//

#import "NSString+StringSizeWithFont.h"

@implementation NSString (StringSizeWithFont)

- (CGSize) VVSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    // Let's make an NSAttributedString first
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    //Add LineBreakMode
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineBreakMode:lineBreakMode];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
    
    // Add Font
    [attributedString setAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, attributedString.length)];
    
    //Now let's make the Bounding Rect
    CGSize expectedSize = [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return expectedSize;
}

- (CGSize) VVSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    // Let's make an NSAttributedString first
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
     // Add Font
    [attributedString setAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, attributedString.length)];
    
    //Now let's make the Bounding Rect
    CGSize expectedSize = [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return expectedSize;

}

- (CGSize) VVSizeWithFont:(UIFont *)font
{
    return [self VVSizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_SIZE.width-16, MAXFLOAT)];
}

@end
