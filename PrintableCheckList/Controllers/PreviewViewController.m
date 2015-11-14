
//
// Created by Nick on 15/5/3.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "PreviewViewController.h"
#import "Project.h"
#import "PrintManager.h"

@interface PreviewViewController()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Preview", @"Preview");

    NSString *html = [PrintManager printTextForProject:self.project];
    [self.webView loadHTMLString:html baseURL:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
}

@end