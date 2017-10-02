//
//  CustomButton.m
//  CabWala
//
//  Created by Sphinx Solution Pvt Ltd on 1/12/16.
//  Copyright © 2016 ananadmahajan. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
//http://stackoverflow.com/questions/13225761/custom-font-on-uibutton-title-clipped-on-top-of-word
-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.titleLabel.frame;
    frame.size.height = self.bounds.size.height;
    frame.origin.y = self.titleEdgeInsets.top;
    self.titleLabel.frame = frame;

}

@end
