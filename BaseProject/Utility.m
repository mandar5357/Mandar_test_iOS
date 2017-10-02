//
//  Utility.m
//  MediPock
//
//  Created by Sphinx Solution Pvt Ltd on 15/09/15.
//  Copyright (c) 2015 Sphinx. All rights reserved.
//

#import "Utility.h"
#import "FormatterCollection.h"
#import "AFSphinxAPIClient.h"


@implementation Utility

+ (BOOL)isEmpty:(NSString*)val
{
    if ([val isKindOfClass:[NSString class]]) {
        if (val != nil && [val isEqualToString:@"(null)"] == NO && [val isEqualToString:@"<null>"] == NO && [val isEqualToString:@""] == NO && [val isEqual:[NSNull null]] == NO)
            return NO;
        else
            return YES;
    }
    return YES;
}
#pragma marks -- Device related funtions
+(BOOL)isIOS7
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
}
+(BOOL)isIOS8
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0");
}

+(BOOL)isIOS9
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0");
}



@end
