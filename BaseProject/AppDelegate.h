//
//  AppDelegate.h
//  BaseProject
//
//  Created by ananadmahajan on 1/25/16.
//  Copyright © 2016 ananadmahajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)isInternetAvailable;
@end

