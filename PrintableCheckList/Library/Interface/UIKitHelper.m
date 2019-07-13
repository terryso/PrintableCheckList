//
// TSUIKitHelper
//
// Created by nick on 13-12-18.
// Copyright (c) 2012年 WeHack. All rights reserved.
// 



#import <UIKit/UIKit.h>
#import "UIKitHelper.h"

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.2
#endif

BOOL iOS8OrLater() {
    return [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending;
}

BOOL iOS7OrLater() {
    return [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending;
}

BOOL iOS6OrLater() {
    return [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending;
}

BOOL isDeviceIPad() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
#endif
    return NO;
}
