//
//  NSString+StringSizeWithFont.h
//  VivinoV2
//
//  Created by Sphinx Solution Pvt Ltd on 22/04/15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (StringSizeWithFont)

- (CGSize) VVSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize) VVSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize) VVSizeWithFont:(UIFont *)font;

@end
