//
//  NoDataView.h
//  MediPock
//
//  Created by Sphinx Solution Pvt Ltd on 11/5/15.
//  Copyright (c) 2015 Sphinx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NoDataViewType)
{
    NoDataViewTypeCabs=0
};
@interface NoDataView : UIView
-(id)initWithType:(NoDataViewType)type frame:(CGRect)frame;
@end
