//
//  BaseViewController.m
//  
//
//  Created by ananadmahajan on 12/21/15.
//
//

#import "BaseViewController.h"
#import "NoInternetView.h"
@interface BaseViewController ()
@property(nonatomic,strong)UIActivityIndicatorView *activityLoader;
@property(nonatomic,strong) UILabel *lblLoading;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:NAV_TITLE_FONT,NSFontAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
     [self setNeedsStatusBarAppearanceUpdate];
}

#pragma textFieldShouldReturn
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self callAPI];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)callAPI
{
    
}

#pragma textViewShouldReturn
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)initOfflineView
{
    [self initOfflineViewWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width,SCREEN_SIZE.height)];
    
}
#pragma marks --Offline View functions
-(void)initOfflineViewWithFrame:(CGRect)frame
{
    _vwOffline=[[NoInternetView alloc] initWithFrame:frame];
    [_vwOffline drawSubviewsWithType:ConnectivityCommon];
     [self.view addSubview:_vwOffline];
    _vwOffline.hidden=YES;
}
-(void)showOfflineView:(BOOL)show error:(NSError*)error
{
    if(show)
    {
        [_vwOffline showConnectivityMessage:error];
        _vwOffline.hidden=NO;
    }
    else
    {
        _vwOffline.hidden=YES;
    }
    
}

#pragma marks --Activity View functions
-(void)initLoaderActivityWithFrame:(CGRect)frame
{
    _activityLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    _activityLoader.frame = frame;
    _activityLoader.tintColor=[UIColor blackColor];
    [self.view addSubview:_activityLoader];
    _activityLoader.hidden=YES;
    
    self.lblLoading =[[UILabel alloc] initWithFrame:CGRectMake(8, _activityLoader.frame.size.height + _activityLoader.frame.origin.y + 10, SCREEN_SIZE.width-16, 17)];
    self.lblLoading.font =FONT_Next_LTPro_H5;
    self.lblLoading.translatesAutoresizingMaskIntoConstraints=YES;
    self.lblLoading.textAlignment=NSTextAlignmentCenter;
    self.lblLoading.textColor=[UIColor blackColor];
    [self.view addSubview:_lblLoading];
    self.lblLoading.hidden=YES;
    
}
-(void)setLoadingTitle:(NSString*)title
{
    CGSize messageSize =[title VVSizeWithFont:FONT_Next_LTPro_H5 constrainedToSize:CGSizeMake(SCREEN_SIZE.width-16, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    SSLog(@"height %f",messageSize.height);
    _lblLoading.text=title;
    _lblLoading.numberOfLines=0;
    _lblLoading.translatesAutoresizingMaskIntoConstraints=YES;
    _lblLoading.frame=CGRectMake(8, _lblLoading.frame.origin.y, SCREEN_SIZE.width-16, messageSize.height);
 }
-(void)initLoaderActivity
{
    [self initLoaderActivityWithFrame: CGRectMake((SCREEN_SIZE.width/2.0)-10,(SCREEN_SIZE.height/2.0)-50, 20, 20)];
}

-(void)initLoaderActivityWithYposition:(CGFloat)yPostion
{
    [self initLoaderActivityWithFrame: CGRectMake((SCREEN_SIZE.width/2.0)-10,yPostion, 20, 20)];
    
}

-(void)startLoadingActivity
{
    _activityLoader.hidden =NO;
    _lblLoading.hidden=NO;
    [_activityLoader startAnimating];
    
}
-(void)stopLoadingActivity
{
    _activityLoader.hidden =YES;
    _lblLoading.hidden=YES;
    if([_activityLoader isAnimating])
        [_activityLoader stopAnimating];
}

+(UIBarButtonItem*)backButton
{
    UIImage *myImage = [[UIImage imageNamed:@"backarrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *btnLeft = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain target:nil action:nil];
    return btnLeft;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
