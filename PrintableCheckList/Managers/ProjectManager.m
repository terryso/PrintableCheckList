//
// Created by Nick on 15/5/2.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "ProjectManager.h"
#import "Project.h"
#import "PCLConstants.h"
#import <AVOSCloud/AVOSCloud.h>

#define keyProjects @"keyProjects"
#define keyLastSyncProjects @"keyLastSyncProjects"

@implementation ProjectManager

+ (NSMutableArray *)allProjects {
    NSData *projectsData = [[NSUserDefaults standardUserDefaults] objectForKey:keyProjects];
    NSArray *projects = nil;
    if (projectsData) {
        projects = [NSKeyedUnarchiver unarchiveObjectWithData:projectsData];
    }
    return projects ? [NSMutableArray arrayWithArray:projects] : [NSMutableArray array];
}

+ (void)addProject:(Project *)project {
    NSMutableArray *projects = [self allProjects];
    if (![projects containsObject:project]) {
        [projects addObject:project];

        NSData *projectsData = [NSKeyedArchiver archivedDataWithRootObject:projects];
        [[NSUserDefaults standardUserDefaults] setObject:projectsData forKey:keyProjects];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)saveProject:(Project *)project {
    NSMutableArray *projects = [self allProjects];
    NSInteger index = [projects indexOfObject:project];
    if (index != NSNotFound) {
        projects[index] = project;

        NSData *projectsData = [NSKeyedArchiver archivedDataWithRootObject:projects];
        [[NSUserDefaults standardUserDefaults] setObject:projectsData forKey:keyProjects];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)deleteProject:(Project *)project {
    NSMutableArray *projects = [self allProjects];
    [projects removeObject:project];

    NSData *projectsData = [NSKeyedArchiver archivedDataWithRootObject:projects];
    [[NSUserDefaults standardUserDefaults] setObject:projectsData forKey:keyProjects];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveAllProjects:(NSArray *)projects {
    NSData *projectsData = [NSKeyedArchiver archivedDataWithRootObject:projects];
    [[NSUserDefaults standardUserDefaults] setObject:projectsData forKey:keyProjects];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)backupUserProjects {
    NSTimeInterval lastSyncTime = [[NSUserDefaults standardUserDefaults] doubleForKey:keyLastSyncProjects];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    PCL_LOG(@"now: %@, lastSyncTime: %@, result: %@", @(now), @(lastSyncTime), @(now - lastSyncTime));
    if (now - lastSyncTime > 3600) {
        NSMutableArray *projects = [NSMutableArray array];
        for (Project *project in [self allProjects]) {
            [projects addObject:[project toDictionary]];
        }

        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:projects options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        AVUser * currentUser = [AVUser currentUser];
        [currentUser setObject:json forKey:@"checklist"];

        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            PCL_LOG(@"同步清单完成: %@", @(succeeded));
            if (succeeded) {
                [[NSUserDefaults standardUserDefaults] setDouble:now forKey:keyLastSyncProjects];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }
}


@end