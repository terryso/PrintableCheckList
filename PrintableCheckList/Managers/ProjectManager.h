//
// Created by Nick on 15/5/2.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project;


@interface ProjectManager : NSObject

+ (NSMutableArray *)allProjects;
+ (void)addProject:(Project *)project;
+ (void)saveProject:(Project *)project;
+ (void)deleteProject:(Project *)project;
+ (void)saveAllProjects:(NSArray *)projects;

+ (void)backupUserProjects;

@end