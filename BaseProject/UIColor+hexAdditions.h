//
//  UIColor+hexAdditions.h
//  VivinoV2
//
//  Created by Mikkel Selsøe Sørensen on 10/06/13.
//
//

#import <Foundation/Foundation.h>

@interface UIColor(HexAdditions)

/**
 Create a UIColor from a hex value as often used in image editors like photoshop. The alpha value is set to 1.0f
 */
+ (UIColor *)colorWithHexValue:(uint32_t )hexValue;

/**
 Create a UIColor from a hex value as often used in image editors like photoshop and specify an alpha value between 0.0f and 1.0f
 */
+ (UIColor *)colorWithHexValue:(uint32_t )hexValue alpha:(float)alpha;

/**
 Create a UIColor from a hex value in a NSString object eg. @"FF00F0"
 */
+ (UIColor *)colorFromStringWithHexValue:(NSString *)hexString;

/**
 Create a UIColor from a hex value in a NSString object eg. @"FF00F0" and specify an alpha value between 0.0f and 1.0f
 */
+ (UIColor *)colorFromStringWithHexValue:(NSString *)hexString alpha:(float)alpha;

@end