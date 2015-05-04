//
// Created by Nick on 15/5/2.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TextEditViewController.h"

@class Project;

@interface ItemsViewController : UITableViewController <TextEditViewControllerDelegate, UIActionSheetDelegate, UIPrintInteractionControllerDelegate>

@property (nonatomic, strong) Project *project;

@end