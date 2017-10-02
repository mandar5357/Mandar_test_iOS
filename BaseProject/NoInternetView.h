//
//  NoInternetView.h
//  
//
//  Created by Sphinx on 10/15/13.
//
//

#import <UIKit/UIKit.h>
#import "SSError.h"

typedef NS_ENUM(NSInteger, ConnectivityScreenType) {
    ConnectivityCommon,
    ConnectivityDoctorList,
    ConnectivityDoctorProfile,
    ConnectivitySelectTimeSlot
};

/*
typedef NS_ENUM(NSInteger, ConnectivityErrorCode) {
    ConnectivityErrorCode403 = 403,
    ConnectivityErrorCode404 = 404,
    ConnectivityErrorCode500 = 500,
    ConnectivityErrorCode503 = 503
};
*/

@interface NoInternetView : UIView

@property (nonatomic, strong) UIButton* btnRetry;
@property (nonatomic, strong) UILabel* lblMessage;
@property (nonatomic, strong) UIImageView* imgView;
@property (nonatomic) ConnectivityScreenType connectivity_type;
@property (nonatomic, strong) SSError* error;
@property (assign) BOOL isCustom;
- (void)drawSubviewsWithType:(ConnectivityScreenType)type;
- (void)drawCustomSubviewsWithType:(ConnectivityScreenType)type;
- (void)showConnectivityMessage:(NSError*)error;
- (NSString*)getConnectivityMsgWithType:(ConnectivityScreenType)ScreenType;
-(void)adjustSubViews;

- (void)showErrorMessageOnly:(SSError*)error;

@end
