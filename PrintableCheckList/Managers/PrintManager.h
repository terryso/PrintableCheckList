//
// Created by Nick on 15/5/3.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project;


@interface PrintManager : NSObject

+ (NSString *)printTextForProject:(Project *)project;

@end