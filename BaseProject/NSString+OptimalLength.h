

#import <Foundation/Foundation.h>

@interface NSString (OptimalLength)

- (NSString*)optimalStringForWidth:(CGFloat)width withFont:(UIFont*)font postfix:(NSString*)postfix;


/*@property(nonatomic) BOOL adjustsFontSizeToFitWidth
 Discussion
 Normally, the label text is drawn with the font you specify in the font property. If this property is set to YES, however, and the text in the text property exceeds the label’s bounding rectangle, the receiver starts reducing the font size until the string fits or the minimum font size is reached. In iOS 6 and earlier, this property is effective only when the numberOfLines property is set to 1.
 */
-(UIFont*)getOptimalFontFromBaseFontName:(NSString*)fontName fontSize:(float)fontSize andConstrainedToSize:(CGSize)constrainedSize;



@end
