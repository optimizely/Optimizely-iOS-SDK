//
//  CodeBlocksViewController.m
//  TutorialApp
//
//  Created by Pamela Ongchin on 11/18/14.
//  Copyright (c) 2014 Optimizely. All rights reserved.
//

#import "CodeBlocksViewController.h"
#import <Optimizely/Optimizely.h>
#import "VisualEditorViewController.h"
#import "CodeBlocksOnboardViewController.h"


@interface CodeBlocksViewController ()

@end

@implementation CodeBlocksViewController

// [OPTIMIZELY] Example how to declare a code block
OptimizelyCodeBlocksKeyWithBlockNames(OnboardingFunnel,
                                      @"Add Onboarding Stage");

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.signIn.layer.cornerRadius = 5;
    
    // Add title for View Controller and make it such that back button has no text
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = @"Code Blocks";
    self.navigationController.title = @"Code Blocks";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Add title for View Controller (so that name doesn't show up in Back button)
    self.title = @"Code Blocks";
    self.navigationController.title = @"Code Blocks";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)signInAccount:(id)sender {
    
    // [OPTIMIZELY] Examples of how to implement code blocks (different flow)
    [Optimizely codeBlocksWithKey:OnboardingFunnel
                     blockOne:^{
                         UIStoryboard *storyboard = self.storyboard;
                         CodeBlocksOnboardViewController *viewController = [[CodeBlocksOnboardViewController alloc] init];
                         viewController = [storyboard instantiateViewControllerWithIdentifier:@"CodeBlocksOnboardViewController"];
                         [self.navigationController pushViewController:viewController animated:YES];
                     }
                     defaultBlock:^{
                         UIStoryboard *storyboard = self.storyboard;
                         VisualEditorViewController *viewController = [[VisualEditorViewController alloc] init];
                         viewController = [storyboard instantiateViewControllerWithIdentifier:@"VisualEditorViewController"];
                         [self.navigationController pushViewController:viewController animated:YES];
                     }];
    
}

@end
