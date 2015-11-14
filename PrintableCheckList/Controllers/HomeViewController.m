//
//  HomeViewController.m
//  PrintableCheckList
//
//  Created by Nick on 15/4/21.
//  Copyright (c) 2015 WeHack Studio. All rights reserved.
//


#import "HomeViewController.h"
#import "ProjectManager.h"
#import "Project.h"
#import "ItemsViewController.h"
#import "MobClick.h"


@interface HomeViewController ()

@property (nonatomic, strong) NSMutableArray *projects;

@end

@implementation HomeViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - left cycles

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataSource:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    if (!editing) {
        [ProjectManager saveAllProjects:self.projects];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showItems"]) {
        [MobClick event:@"showItems"];

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Project *project = self.projects[indexPath.row];
        [(ItemsViewController *) [segue destinationViewController] setProject:project];
    } else if ([[segue identifier] isEqualToString:@"settingsView"]) {
        [MobClick event:@"settings"];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.tintColor = [UIColor lightGrayColor];
    [detailButton setImage:[UIImage imageNamed:@"Flat-iOS7-Button-Details-N"] forState:UIControlStateNormal];
    [detailButton setImage:[UIImage imageNamed:@"Flat-iOS7-Button-Details-P"] forState:UIControlStateHighlighted];
    detailButton.frame = CGRectMake(0, 0, 33, 33);
    [detailButton addTarget:self action:@selector(editProject:) forControlEvents:UIControlEventTouchUpInside];
    detailButton.tag = indexPath.row;
    cell.accessoryView = detailButton;

    Project *project = self.projects[indexPath.row];
    cell.textLabel.text = project.title;

    NSInteger itemsCount = project.items.count;
    if (itemsCount != 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ items", @(itemsCount)];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ item", @(itemsCount)];
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Project *project = self.projects[indexPath.row];
        //[ProjectManager deleteProject:project];
        [self.projects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray *projectsCopy = [NSMutableArray arrayWithArray:self.projects];
    Project *project = self.projects[sourceIndexPath.row];
    [projectsCopy removeObject:project];
    [projectsCopy insertObject:project atIndex:destinationIndexPath.row];
    self.projects = projectsCopy;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TextEditViewControllerDelegate

- (void)textEditViewController:(TextEditViewController *)controller didSaveText:(NSString *)text {
    NSString *projectText = [text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    projectText = [projectText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    projectText = [projectText stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    Project *project;
    if (controller.originModel) {
        project = controller.originModel;
        project.title = projectText;
        [ProjectManager saveProject:project];
    } else {
        project = [[Project alloc] init];
        project.title = projectText;
        project.projectId = [NSString stringWithFormat:@"%@", @([[NSDate date] timeIntervalSince1970])];
        [ProjectManager addProject:project];
    }

    [self loadDataSource:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Event Handlers

- (void)editProject:(id)sender {
    [MobClick event:@"editProject"];

    UIButton *detailButton = sender;
    Project *project = self.projects[detailButton.tag];

    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TextEditViewController *teVC = [mainStory instantiateViewControllerWithIdentifier:@"textEditView"];
    teVC.originText = project.title;
    teVC.originModel = project;
    teVC.delegate = self;
    teVC.title = NSLocalizedString(@"Edit List", @"Edit List");

    [self.navigationController pushViewController:teVC animated:YES];
}

- (IBAction)addProject:(id)sender {
    [MobClick event:@"addProject"];
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TextEditViewController *teVC = [mainStory instantiateViewControllerWithIdentifier:@"textEditView"];
    teVC.isPresent = YES;
    teVC.delegate = self;
    teVC.title = NSLocalizedString(@"New List", @"New List");

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:teVC];
    [self presentViewController:nav animated:YES completion:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helper Methods

- (void)loadDataSource:(BOOL)moveToBottom {
    self.projects = [ProjectManager allProjects];
    [self.tableView reloadData];

    if (self.projects.count > 0 && moveToBottom) {
        NSIndexPath *bottom = [NSIndexPath indexPathForRow:self.projects.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:bottom atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

@end