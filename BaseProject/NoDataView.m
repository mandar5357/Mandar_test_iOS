//
//  NoDataView.m
//  MediPock
//
//  Created by Sphinx Solution Pvt Ltd on 11/5/15.
//  Copyright (c) 2015 Sphinx. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView()
@property(nonatomic)NoDataViewType type;
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *lblMessage;
@end
@implementation NoDataView

-(id)initWithType:(NoDataViewType)type frame:(CGRect)frame
{
    self =[super init];
    self.type=type;
    self.frame=frame;
    [self commanInit];
    return self;
}

-(void)commanInit
{
    self.backgroundColor = UICOLOR_GLOBAL_BG;
    [self loadAllComponents];

}
-(void)loadAllComponents
{
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width/2 - 75/2), (self.frame.size.height/2.0)-100 , 75, 75)];
        _imgView.image = [UIImage imageNamed:[self getImageByType]];
        [self addSubview:_imgView];
   
    _lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, _imgView.frame.origin.y+ _imgView.frame.size.height+5, (self.frame.size.width-10*2), 20)];
    _lblMessage.textAlignment = NSTextAlignmentCenter;
    _lblMessage.backgroundColor = [UIColor clearColor];
    _lblMessage.lineBreakMode=NSLineBreakByWordWrapping;
    _lblMessage.numberOfLines = 0;
    _lblMessage.textColor = [UIColor colorWithHexValue:0xA9A9A9];
    _lblMessage.font = FONT_Next_LTPro_H5;
    _lblMessage.text=[self getMessageByType];
    [self addSubview:_lblMessage];

}

-(NSString*)getImageByType
{
    if(_type==NoDataViewTypeCabs)
        return @"no_cabs_found";
    return @"";
}

-(NSString*)getMessageByType
{
    if(_type==NoDataViewTypeCabs)
        return SSLocalizedString(@"no_cabs_found2", nil);
   return @"";

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
