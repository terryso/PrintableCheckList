//
//  AppDelegate.m
//  PrintableCheckList
//
//  Created by Nick on 15/4/21.
//  Copyright (c) 2015 WeHack Studio. All rights reserved.
//


#import <Crashlytics/Crashlytics.h>
#import "MobClick.h"
#import <AVOSCloud/AVOSCloud.h>
#import <SSKeychain/SSKeychain.h>
#import "AppDelegate.h"
#import "PCLConstants.h"
#import "ProjectManager.h"
#import "Project.h"

#define keyFinishAddDefaultProject @"keyFinishAddDefaultProject"
static NSString *password = @"com.wehack.pwd";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self configAppearance];

    // 初始化AVOSCloud
    [self initAVOSCloud];

    // 初始化友盟SDK
    [self initUMengSDK];

    // 注册Crashlytics
    [Crashlytics startWithAPIKey:@"your crashlytics key"];

    // 添加默认数据, 只加一次
    [self addDefaultProject];

    return YES;
}

- (void)configAppearance {
    //[[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
            NSFontAttributeName : [UIFont systemFontOfSize:19]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate *)shareDelegate {
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (void)initAVOSCloud {
    [AVOSCloud setApplicationId:@"your leancloud key"
                      clientKey:@"your leancloud secret"];

    [AVOSCloud setLastModifyEnabled:YES];
    [AVAnalytics setChannel:[self channelID]];

    [AVUser logInWithUsernameInBackground:[self getUUID]
                                 password:password
                                    block:^(AVUser *user, NSError *error) {
                                        if (user != nil) {
                                            PCL_LOG(@"用户登陆成功: %@", [AVUser currentUser]);
                                            [ProjectManager backupUserProjects];
                                        } else {
                                            PCL_LOG(@"用户登陆失败: %@", error);
                                            [self signUp];
                                        }
                                    }];
}

- (void)initUMengSDK {
    [MobClick setAppVersion:CLIENT_VERSION];
    [MobClick setCrashReportEnabled:NO];
    [MobClick startWithAppkey:@"your umeng key" reportPolicy:SEND_INTERVAL channelId:[self channelID]];
    [MobClick updateOnlineConfig];
    [MobClick checkUpdate];
}

- (void)signUp {
    AVUser *user = [AVUser user];   
    user.username = [self getUUID];
    user.password = password;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PCL_LOG(@"用户登陆成功: %@", [AVUser currentUser]);
            [ProjectManager backupUserProjects];
        } else {
            PCL_LOG(@"注册用户失败: %@", error);
        }
    }];
}

- (NSString *)getUUID {
    NSString *retrieveUUID = [SSKeychain passwordForService:@"com.wehack.printablechecklist" account:@"uuid"];
    if (retrieveUUID.length <= 0) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        retrieveUUID = [NSString stringWithFormat:@"%@", uuidStr];
        [SSKeychain setPassword:retrieveUUID
                     forService:@"com.wehack.printablechecklist"
                        account:@"uuid"];
    }
    return retrieveUUID;
}

- (NSString *)channelID {
    //return @"develop";
    //return @"fir";
    return @"appstore";
}

- (void)addDefaultProject {
    BOOL finishAddDefaultProject = [[NSUserDefaults standardUserDefaults] boolForKey:keyFinishAddDefaultProject];
    if (!finishAddDefaultProject) {
        NSString *base64 = NSLocalizedString(@"defaultProject", @"defaultProject");
        NSData *base64Data = [base64 dataUsingEncoding:4];
        NSData *data = [[NSData alloc] initWithBase64EncodedData:base64Data options:0];
        Project *project = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [ProjectManager addProject:project];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:keyFinishAddDefaultProject];
    }
}

@end