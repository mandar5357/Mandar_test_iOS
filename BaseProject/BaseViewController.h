//
//  BaseViewController.h
//  
//
//  Created by ananadmahajan on 12/21/15.
//
//

#import <UIKit/UIKit.h>
@class NoInternetView;
@interface BaseViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong) NoInternetView *vwOffline;

#pragma marks --Offline View functions
-(void)initOfflineView;
-(void)initOfflineViewWithFrame:(CGRect)frame;
-(void)showOfflineView:(BOOL)show error:(NSError*)error;

#pragma marks --Activity View functions
-(void)setLoadingTitle:(NSString*)title;
-(void)initLoaderActivityWithYposition:(CGFloat)yPostion;
-(void)initLoaderActivity;
-(void)startLoadingActivity;
-(void)stopLoadingActivity;

+(UIBarButtonItem*)backButton;
@end
