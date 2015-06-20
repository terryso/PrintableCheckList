//
// Created by Nick on 15/5/2.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "MobClick.h"
#import "ItemsViewController.h"
#import "Project.h"
#import "Item.h"
#import "ProjectManager.h"
#import "PreviewViewController.h"
#import "PrintManager.h"
#import "PCLConstants.h"

@interface ItemsViewController()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ItemsViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.project.title;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self loadDataSource:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (!editing) {
        self.project.items = self.items;
        [ProjectManager saveProject:self.project];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editItem"]) {
        [MobClick event:@"editItem"];

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Item *item = self.items[indexPath.row];

        TextEditViewController *teVC = [segue destinationViewController];
        teVC.delegate = self;
        teVC.originModel = item;
        teVC.originText = item.title;
        teVC.title = NSLocalizedString(@"Edit Item", @"Edit Item");
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Item *item = self.items[indexPath.row];
    cell.textLabel.text = item.title;

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray *itemsCopy = [NSMutableArray arrayWithArray:self.items];
    Item *item = self.items[sourceIndexPath.row];
    [itemsCopy removeObject:item];
    [itemsCopy insertObject:item atIndex:destinationIndexPath.row];
    self.items = itemsCopy;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TextEditViewController

- (void)textEditViewController:(TextEditViewController *)controller didSaveText:(NSString *)text {
    Item *item = nil;
    if (controller.originModel) {
        item = controller.originModel;
        NSString *itemText = [text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        itemText = [itemText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        itemText = [itemText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        item.title = itemText;
        [self.project saveItem:item];
    } else {
        NSArray *items = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        for (NSString *itemText in items) {
            item = [[Item alloc] init];
            item.itemId = [NSString stringWithFormat:@"%@", @([[NSDate date] timeIntervalSince1970])];
            item.title = itemText;
            [self.project addItem:item];
        }
    }
    [ProjectManager saveProject:self.project];

    [self loadDataSource:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [MobClick event:@"print"];

        UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
        printController.delegate = self;

        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = self.project.title;
        printInfo.duplex = UIPrintInfoDuplexNone;
        printController.printInfo = printInfo;
        printController.showsPageRange = NO;

        NSString *printText = [PrintManager printTextForProject:self.project];
        UIMarkupTextPrintFormatter *formatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:printText];
        formatter.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10); // 1" margins
        printController.printFormatter = formatter;

        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                PCL_LOG(@"FAILED! due to error in domain %@ with error code %lu", error.domain, (long)error.code);
            }
        };

        //if iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [printController presentAnimated:YES completionHandler:completionHandler];
        }
        //if iPad
        else {
            // Change Rect to position Popover
            [printController presentFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)
                                      inView:self.view
                                    animated:YES
                           completionHandler:completionHandler];
        }

    } else if (buttonIndex == 1) {
        [MobClick event:@"preview"];

        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PreviewViewController *previewVC = [mainStory instantiateViewControllerWithIdentifier:@"previewView"];
        previewVC.project = self.project;
        [self.navigationController pushViewController:previewVC animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Event Handlers

- (IBAction)addItem:(id)sender {
    [MobClick event:@"addItem"];

    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TextEditViewController *teVC = [mainStory instantiateViewControllerWithIdentifier:@"textEditView"];
    teVC.isPresent = YES;
    teVC.delegate = self;
    teVC.title = NSLocalizedString(@"New Item", @"New Item");
    teVC.placeholder = NSLocalizedString(@"One item per line", @"One item per line");

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:teVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)showActions:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Print", @"Print"), NSLocalizedString(@"Preview", @"Preview"), nil];
    [actionSheet showInView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helper Methods

- (void)loadDataSource:(BOOL)moveToBottom {
    self.items = [NSMutableArray arrayWithArray:self.project.items];
    [self.tableView reloadData];

    if (self.items.count > 0 && moveToBottom) {
        NSIndexPath *bottom = [NSIndexPath indexPathForRow:self.items.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:bottom atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

@end