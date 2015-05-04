//
// Created by Nick on 15/5/2.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Item : NSObject <NSCoding>

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *title;

@end