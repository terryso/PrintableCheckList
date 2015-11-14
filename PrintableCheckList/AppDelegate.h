//
//  AppDelegate.h
//  PrintableCheckList
//
//  Created by Nick on 15/4/21.
//  Copyright (c) 2015 WeHack Studio. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)shareDelegate;
- (NSString *)channelID;

@end
