//
//  LandingTableViewController.m
//  TutorialApp
//
//  Created by Tony Zhang on 9/22/14.
//  Copyright (c) 2014 Optimizely. All rights reserved.
//

#import "LandingTableViewController.h"
#import "VariationTableViewCell.h"

@interface LandingTableViewController ()
@property (nonatomic) NSArray *items;
@property (nonatomic) NSArray *itemDescs;
@property (nonatomic) NSArray *imageList;
@end

@implementation LandingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Optimizely logo for status bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallWhiteLogoforStatusBar.png"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    self.items = @[@"Visual Editor", @"Live Variables", @"Code Blocks"];
    self.itemDescs = @[@"Make changes, no code needed", @"Change your users' experience", @"Test entirely custom features"];
    self.imageList = @[@"visualEditorIcon.png", @"liveVariablesIcon.png", @"codeBlocksIcon.png"];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // Set background image for the table view
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VariationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"default"];

    cell.variationTitleLabel.font = [UIFont fontWithName:@"Gotham-Medium" size:20];
    cell.variationDescLabel.font = [UIFont fontWithName:@"Gotham-Light" size:12];
    
    cell.variationTitleLabel.text = self.items[indexPath.row];
    cell.variationDescLabel.text = self.itemDescs[indexPath.row];
    
    cell.iconVariationImg.image = [UIImage imageNamed:self.imageList[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *viewController;
    switch (indexPath.row) {
        case 0: // Visual Editor
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"VisualEditorViewController"];
            break;
        case 1: // Live Variables
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"LiveVariablesViewController"];
            break;
        case 2: // Code Blocks
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"CodeBlocksViewController"];
            break;
    }
    
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end

