//
// Created by Nick on 15/5/3.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "SettingsViewController.h"
#import "PCLConstants.h"
#import "MobClick.h"
#import "UIKitHelper.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@property(weak, nonatomic) IBOutlet UITableViewCell *tellFriendsCell;
@property(weak, nonatomic) IBOutlet UITableViewCell *rateCell;
@property(weak, nonatomic) IBOutlet UITableViewCell *supportCell;
//@property(weak, nonatomic) IBOutlet UITableViewCell *versionCell;
@property(weak, nonatomic) IBOutlet UITableViewCell *twitterCell;
@property(weak, nonatomic) IBOutlet UITableViewCell *snapCell;
@property(weak, nonatomic) IBOutlet UITableViewCell *snapProCell;
@property(nonatomic, strong) UILabel *versionLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Settings", @"Settings");

    self.tellFriendsCell.textLabel.text = NSLocalizedString(@"Tell friends", @"Tell friends");
    self.rateCell.textLabel.text = NSLocalizedString(@"Rate in AppStore", @"Rate in AppStore");
    self.supportCell.textLabel.text = NSLocalizedString(@"Email to support", @"Email to support");
    self.twitterCell.textLabel.text = NSLocalizedString(@"Follow us on Twitter", @"Follow us on Twitter");

    self.snapCell.detailTextLabel.text = NSLocalizedString(@"Free", @"Free");
    self.snapProCell.detailTextLabel.text = NSLocalizedString(@"$0.99", @"$0.99");

    //self.versionCell.textLabel.text = NSLocalizedString(@"Current verison", @"Current verison");
    //self.versionCell.detailTextLabel.text = CLIENT_VERSION;
    
    self.tableView.tableFooterView = self.versionLabel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self tellFriends];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self goRating];
        } else if (indexPath.row == 1) {
            [self sendMail];
        } else if (indexPath.row == 2) {
            [self goTwitter];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self goSnap];
        } else if (indexPath.row == 1) {
            [self goSnapPro];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tellFriends {
    [MobClick event:@"tellFriends"];
    NSString *URLString = @"https://itunes.apple.com/us/app/shan-yin-zui-hao-yong-ke-da/id991595690?mt=8";
    NSString *textToShare = [NSString stringWithFormat:NSLocalizedString(@"Check out 'Flash' app! The best printable check list. It's free from %@", @"Check out 'Flash' app! The best printable check list. It's free from %@"), URLString];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[textToShare]
                                                  applicationActivities:nil];
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)
                               inView:self.view
             permittedArrowDirections:UIPopoverArrowDirectionAny
                             animated:YES];
    }
}

- (void)sendMail {
    [MobClick event:@"sendMail"];

    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.navigationBar.tintColor = [UIColor whiteColor];
        picker.mailComposeDelegate = self;
        [picker setSubject:NSLocalizedString(@"Feedback for Flash", @"Feedback for Flash")];
        [picker setToRecipients:@[@"oxtiger@gmail.com"]];
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please set up an account for sending mail on your device", @"Please set up an account for sending mail on your device")
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"Confirm", @"Confirm"), nil];
        [alert show];
    }
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Notifies users about errors associated with the interface
    NSString *message = nil;
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            message = NSLocalizedString(@"draft has been saved", @"draft has been saved");
            break;
        case MFMailComposeResultSent:
            message = NSLocalizedString(@"mail has been scheduled to be sent", @"mail has been scheduled to be sent");
            break;
        case MFMailComposeResultFailed:
            message = NSLocalizedString(@"failed to send", @"failed to send");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    if (message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }
}

- (void)goSnap {
    [MobClick event:@"goSnap"];
    [self openURL:@"https://itunes.apple.com/app/apple-store/id849104717?pt=74623800&ct=flash&mt=8"];
}

- (void)goSnapPro {
    [MobClick event:@"goSnapPro"];
    [self openURL:@"https://itunes.apple.com/app/apple-store/id967317148?pt=74623800&ct=flash&mt=8"];
}

- (void)goTwitter {
    [MobClick event:@"goTwitter"];
    [self openURL:@"https://twitter.com/suchuanyi"];
}

- (void)goRating {
    [MobClick event:@"goRating"];
    [self openURL:@"https://itunes.apple.com/us/app/shan-yin-zui-hao-yong-ke-da/id991595690?mt=8"];
}

- (void)openURL:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.font = [UIFont systemFontOfSize:13.0f];
        _versionLabel.textColor = [UIColor colorWithRed:195/255.0f green:195/255.0f blue:195/255.0f alpha:1];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *versionText = [NSString stringWithFormat:@"%@-%@(%@)", version, build, [AppDelegate shareDelegate].channelID];
        _versionLabel.text = versionText;
        
        CGSize versionSize = PCL_TEXTSIZE(_versionLabel.text, _versionLabel.font);
        _versionLabel.frame = CGRectMake((self.view.frame.size.width - versionSize.width) / 2, 0, versionSize.width, versionSize.height);
    }
    return _versionLabel;
}

@end