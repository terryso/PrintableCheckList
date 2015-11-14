//
//  TextEditViewController.m
//  PrintableCheckList
//
//  Created by Nick on 15/5/2.
//  Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "TextEditViewController.h"
#import "SZTextView.h"

@interface TextEditViewController()

@property (weak, nonatomic) IBOutlet SZTextView *textView;

@end

@implementation TextEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.isPresent) {
        UIBarButtonItem *closeBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeTextView:)];
        self.navigationItem.leftBarButtonItem = closeBarItem;
    }

    if (self.originText.length > 0) {
        self.textView.text = self.originText;
    }

    if (self.placeholder.length > 0) {
        self.textView.placeholder = self.placeholder;
    }

    self.navigationItem.rightBarButtonItem.enabled = self.textView.text.length > 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
}

- (IBAction)saveText:(id)sender {
    [self.delegate textEditViewController:self didSaveText:self.textView.text];
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)closeTextView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = textView.text.length > 0;
}

@end
