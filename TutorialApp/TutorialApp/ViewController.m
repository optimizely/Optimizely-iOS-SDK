//
//  ViewController.m
//  TutorialApp
//
//  Created by Tony Zhang on 9/22/14.
//  Copyright (c) 2014 Optimizely. All rights reserved.
//

#import "ViewController.h"
#import <Optimizely/Optimizely.h>

@interface ViewController ()
//@property (nonatomic) NSArray *items;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.items = @[@"Visual Editor", @"Live Variables", @"Code Blocks"];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Style Optly Onboarding modal
    self.optlyOnboardModal.layer.cornerRadius = 5;
    
    // Style for instructions
    self.optlyInstructLabel.font = [UIFont fontWithName:@"Gotham-Light" size:14];
    
    // Style for Optimizely Next CTA
    [self.optlyNextBtn setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.optlyNextBtn.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    [self.optlyNextBtn.layer setShadowOffset:CGSizeMake(0.5, 0.5)];
    [self.optlyNextBtn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.optlyNextBtn.layer setShadowOpacity:0.5];
    self.optlyNextBtn.layer.cornerRadius = 5;
    CGRect      buttonFrame = self.optlyNextBtn.frame;
    buttonFrame.size = CGSizeMake(300, 200);
    self.optlyNextBtn.frame = buttonFrame;
    [self.optlyNextBtn.titleLabel setFont:[UIFont fontWithName:@"Gotham-Medium" size:16]];

    
    // Welcome to Optimizely Tutorial App font
    self.optlyWelcomeLabel.font = [UIFont fontWithName:@"Gotham-Light" size:18];
    
    self.navigationItem.title = @"Optimizely";
    self.navigationController.navigationBar.topItem.title = @"Optimizely";
    
    // [OPTIMIZELY] Below is an example of if you want to tag
    // ids manually
    self.optlyNextBtn.optimizelyId = @"Next Button";
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"Optimizely";
    self.navigationController.navigationBar.topItem.title = @"Optimizely";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
