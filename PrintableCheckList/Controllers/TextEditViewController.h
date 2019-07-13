//
//  TextEditViewController.h
//  PrintableCheckList
//
//  Created by Nick on 15/5/2.
//  Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextEditViewController;
@class SZTextView;

@protocol TextEditViewControllerDelegate <NSObject>

- (void)textEditViewController:(TextEditViewController *)controller didSaveText:(NSString *)text;

@end

@interface TextEditViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) id<TextEditViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *originText;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) id originModel;
@property (nonatomic, assign) BOOL isPresent;

@end
