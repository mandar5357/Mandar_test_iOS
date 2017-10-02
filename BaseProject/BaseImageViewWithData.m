

#import "BaseImageViewWithData.h"
#import <SDWebImage/UIImageView+WebCache.h>


static UIImage* cabPlaceHolder;
static UIImage* userPlaceHolder;
static UIImage* cabProviderPlaceHolder;
@interface BaseImageViewWithData()

@property (nonatomic,strong) UIImage *placeholder;
@property (nonatomic) ImageViewComfrom comefrom;
@end


@implementation BaseImageViewWithData

#pragma mark - Initialize
+ (void)initialize
{
    if(self == [BaseImageViewWithData class])
    {
        cabPlaceHolder = [UIImage imageNamed:kCabPlaceHolderImage];
        userPlaceHolder = [UIImage imageNamed:kUserPlaceHolderImage];
        cabProviderPlaceHolder = [UIImage imageNamed:kCabProviderPlaceHolderImage];
    }
}

#pragma mark - Get Images Methods
- (void) getImageWithURL:(NSString*)stringURL  comefrom:(ImageViewComfrom)comefrom
{
    self.comefrom=comefrom;
    [self setPlaceHolder];
    
    [self loadImageWithURL:stringURL success:nil failure:nil];
}
- (void) getImageWithURL:(NSString*)stringURL
                comefrom:(ImageViewComfrom)comefrom
                 success:(void (^)())success
                 failure:(void (^)())failure
{
    self.comefrom=comefrom;
    [self setPlaceHolder];
    [self loadImageWithURL:stringURL success:^{
        if(success)
            success();
    } failure:^{
            if(failure)
                failure();
    }];

}

-(void)loadImageWithURL:(NSString*)stringURL
                success:(void (^)())success
                failure:(void (^)())failure
{
    if ([stringURL isEmpty] == YES || stringURL == nil) {
        self.image = _placeholder;
        return;
    }
    
    NSURL* url;
     url = [NSURL URLWithString:stringURL];
    
    
    //VVLog(@"url==>%@",url);
    
   __weak BaseImageViewWithData* weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:_placeholder
                   completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType,NSURL *originalImageURL) {
                       if(image) {
                         
                          [UIView transitionWithView:weakSelf
                                             duration:0.2f
                                              options:UIViewAnimationOptionTransitionCrossDissolve
                                           animations:^{
                                               
                                               [self changeContentMadeIfNeeded];
                                               
                                               [weakSelf setImage:image];
                                           
                                           }
                                           completion:NULL];
                           
                           if(success)
                               success();
                       }
                   }];
}

#pragma mark - Custum Methods

- (void)cancelDownload
{
    [self sd_cancelCurrentImageLoad];
}

- (void) setPlaceHolder
{
    self.clipsToBounds=YES;
   
    if(_comefrom==ImageViewComfromCab)
    {
        _placeholder = cabPlaceHolder;
         self.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if(_comefrom==ImageViewComfromCabProvider)
    {
        _placeholder = cabProviderPlaceHolder;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if(_comefrom==ImageViewComfromUser)
    {
        _placeholder =userPlaceHolder;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
}
-(void)changeContentMadeIfNeeded
{
    if(self.comefrom==ImageViewComfromCab)
        self.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)makeImageRoundWithRadius:(CGFloat)radius border:(CGFloat)border color:(UIColor*)color
{
    CALayer *imageLayer = self.layer;
    [imageLayer setCornerRadius:radius];
    [imageLayer setBorderWidth:border];
    [imageLayer setBorderColor:color.CGColor];
    [imageLayer setMasksToBounds:YES];

}


@end
