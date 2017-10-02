

#import <UIKit/UIKit.h>

@interface BaseImageViewWithData : UIImageView

#define kCabPlaceHolderImage @"hachback"
#define kUserPlaceHolderImage @"userPlaceholder"
#define kCabProviderPlaceHolderImage @"hachback"

- (void) getImageWithURL:(NSString*)stringURL comefrom:(ImageViewComfrom)comefrom;
-(void)makeImageRoundWithRadius:(CGFloat)radius border:(CGFloat)border  color:(UIColor*)color;
- (void) getImageWithURL:(NSString*)stringURL
                comefrom:(ImageViewComfrom)comefrom
                 success:(void (^)())success
                 failure:(void (^)())failure;
- (void)cancelDownload;
@end
