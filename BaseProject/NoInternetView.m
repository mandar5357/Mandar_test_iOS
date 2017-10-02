//
//  NoInternetView.m
//  
//
//  Created by Sphinx on 10/15/13.
//
//

#import "NoInternetView.h"
#import "SSError.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "NSString+StringSizeWithFont.h"
@implementation NoInternetView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    return self;
}
- (void)drawSubviewsWithType:(ConnectivityScreenType)type
{

    self.backgroundColor = UICOLOR_GLOBAL_BG;
    _connectivity_type = type;
    [self loadAllComponents];
}

- (void)drawCustomSubviewsWithType:(ConnectivityScreenType)type
{
    self.backgroundColor = UICOLOR_GLOBAL_BG;
    CGRect rect = self.frame;
    
    self.frame = rect;
    _connectivity_type = type;
    
    [self loadAllComponents];
}

-(void)loadAllComponents
{
    [self addImage];
    [self addLable];
    
    [self addButton];
}
- (void)addImage
{
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width/2 - 61/2), (self.frame.size.height/2.0)-100 , 61, 43)];
    _imgView.image = [UIImage imageNamed:@"no_internet.png"];
    [self addSubview:_imgView];
}

- (void)addLable
{
  
    _lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, _imgView.frame.origin.y+ _imgView.frame.size.height+5, (self.frame.size.width-10*2), 20)];
    _lblMessage.textAlignment = NSTextAlignmentCenter;
    _lblMessage.backgroundColor = [UIColor clearColor];
    _lblMessage.lineBreakMode=NSLineBreakByWordWrapping;
    _lblMessage.numberOfLines = 0;
    _lblMessage.textColor = [UIColor colorWithHexValue:0xA9A9A9];
    _lblMessage.font = FONT_Next_LTPro_H3;
   [self showConnectivityMessage:nil];

    [self addSubview:_lblMessage];
}

- (void)addButton
{
    _btnRetry = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRetry.frame = CGRectMake((self.frame.size.width/2 - 57/2), _lblMessage.frame.origin.y + _lblMessage.frame.size.height + 5, 57, 18);
    [_btnRetry setTitle:[SSLocalizedString(@"retry", nil) uppercaseString] forState:UIControlStateNormal];
    _btnRetry.titleLabel.font = FONT_Next_LTPro_H3;
    _btnRetry.backgroundColor=[UIColor colorWithHexValue:0x67C160];
    [_btnRetry setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRetry setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_btnRetry setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _btnRetry.layer.cornerRadius=3.0f;
    [self addSubview:_btnRetry];
}

- (void)resetAttributedLabel
{
    if ([Utility isEmpty:_lblMessage.text] == NO) {
        [_lblMessage setText:@""];
        [_lblMessage setAttributedText:nil];
    }
}

- (void)showErrorMessageOnly:(SSError*)error
{
    _lblMessage.text = SSLocalizedString(@"error_invalid_facebook_token", nil);
    _btnRetry.hidden= YES;
    _imgView.hidden = YES;
}


- (void)showConnectivityMessage:(NSError*)error
{
    [self resetAttributedLabel];
    SSError *vverror = error.userInfo[kSSErrorObjectKey];
    NSString *message =@"";
    if (_connectivity_type == ConnectivityCommon && error!=nil) {
        message = [vverror localizedMessage];
    } else {
        message= [self getConnectivityMsgWithType:_connectivity_type];
    }

    CGSize messageSize =[message VVSizeWithFont:FONT_Next_LTPro_H5 constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    SSLog(@"height %f",messageSize.height);
    _lblMessage.text =message;
    _lblMessage.frame = CGRectMake(10, _imgView.frame.origin.y+ _imgView.frame.size.height+10, (self.frame.size.width-10*2), messageSize.height);
    [self adjustSubViews];
}



- (NSString*)getConnectivityMsgWithType:(ConnectivityScreenType)ScreenType
{
    NSString* connectivity_title = nil;
    
    if ([UIAppDelegate isInternetAvailable] == YES) //if there is internet and server call fail
    {
        /*if (ScreenType == ConnectivityPaused) {
            connectivity_title = [NSString stringWithFormat:@"%@\n%@", SSLocalizedString(@"service_unavailable", nil), SSLocalizedString(@"we_will_match_your_wine", nil)];
            connectivity_sub_title = SSLocalizedString(@"we_will_match_your_wine", nil);
        } else if (ScreenType == ConnectivityNoStreams) {
            _btnRetry.hidden = YES;
            connectivity_title = SSLocalizedString(@"no_ratings_found", nil);
            return [[NSMutableAttributedString alloc] initWithString:connectivity_title];
        } else if (ScreenType == ConnectivityNoWines) {
            _btnRetry.hidden = YES;
            connectivity_title = SSLocalizedString(@"no_wines", nil);
            return [[NSMutableAttributedString alloc] initWithString:connectivity_title];
        } else*/
        {
            connectivity_title = [NSString stringWithFormat:@"%@\n",
                                      [NSString stringWithFormat:SSLocalizedString(@"app_server_unavailable", nil),
                                       APP_NAME]
                                                            ];
        }
    } else {
        /*if (ScreenType == ConnectivityHome) {
            connectivity_title = SSLocalizedString(@"no_internet_connection_with_friend_msg", nil);

            NSArray* ls_splitstring = [connectivity_title componentsSeparatedByString:@"\n"];
            connectivity_sub_title = [ls_splitstring lastObject];
            if ([connectivity_sub_title isEmpty])
                connectivity_sub_title = connectivity_title;
        } else*/
        {
            connectivity_title = [NSString stringWithFormat:@"%@",
                                                            SSLocalizedString(@"no_internet_connection", nil)];
        }
    }


    return connectivity_title;
}

-(void)adjustSubViews
{
   _imgView.frame=CGRectMake((self.frame.size.width/2 - 52/2),(self.frame.size.height/2.0)-100 , 61, 43);
    _lblMessage.frame=CGRectMake(10, _imgView .frame.origin.y +  _imgView.frame.size.height + 5, self.frame.size.width-20, _lblMessage.frame.size.height);
    
    _btnRetry.frame = CGRectMake((self.frame.size.width/2 - (57/2)), _lblMessage.frame.origin.y + _lblMessage.frame.size.height + 5, 57, 18);
}
@end
