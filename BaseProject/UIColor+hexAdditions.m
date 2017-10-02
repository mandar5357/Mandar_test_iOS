//
//  UIColor+hexAdditions.m
//  VivinoV2
//
//  Created by Mikkel Selsøe Sørensen on 10/06/13.
//
//

#import "UIColor+hexAdditions.h"

@implementation UIColor(SHPAdditions)

+ (UIColor *)colorWithHexValue:(uint32_t )hexValue {
    
    return [UIColor colorWithHexValue:hexValue alpha:1.0f];
}

+ (UIColor *)colorWithHexValue:(uint32_t )hexValue alpha:(float)alpha {
    // default values
    uint32_t r = 0xff;
    uint32_t g = 0xff;
    uint32_t b = 0xff;
    
    r = (hexValue & 0xff0000) >> 8*2;
    g = (hexValue & 0x00ff00) >> 8*1;
    b = (hexValue & 0x0000ff);
    
    UIColor *newColor = [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:alpha];
    
	return newColor;
}

+ (UIColor *)colorFromStringWithHexValue:(NSString *)hexString
{
    return [UIColor colorFromStringWithHexValue:hexString alpha:1.0f];
}

+ (UIColor *)colorFromStringWithHexValue:(NSString *)hexString alpha:(float)alpha;
{
    uint32_t hex;
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&hex];
    
    return [UIColor colorWithHexValue:hex alpha:alpha];
}

@end