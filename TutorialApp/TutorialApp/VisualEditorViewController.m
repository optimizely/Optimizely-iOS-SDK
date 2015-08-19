//
//  VisualEditorViewController.m
//  TutorialApp
//
//  Created by Tony Zhang on 9/24/14.
//  Copyright (c) 2014 Optimizely. All rights reserved.
//

#import "VisualEditorViewController.h"
#import <Optimizely/Optimizely.h>

@interface VisualEditorViewController ()

@end

@implementation VisualEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Add title for View Controller and make it such that back button has no text
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.optlyWidgetsCTA.layer.cornerRadius = 5;
    self.optlyPassField.secureTextEntry = YES;
    
    // [OPTIMIZELY] Below is an example of if you want to tag
    // views manually http://developers.optimizely.com/ios/#tag%20your%20views
    self.optlyWidgetsCTA.optimizelyId = @"Widgets Next Button";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.title = @"Visual Editor";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)emailActive:(id)sender {
    [self.optlyEmailField canBecomeFirstResponder];
}
- (IBAction)phoneActive:(id)sender {
    [self.optlyPhoneField canBecomeFirstResponder];
}
- (IBAction)passActive:(id)sender {
    [self.optlyPassField canBecomeFirstResponder];
}



-(void)dismissKeyboard {
    [self.optlyEmailField resignFirstResponder];
    [self.optlyPhoneField resignFirstResponder];
    [self.optlyPassField resignFirstResponder];
}


- (IBAction)widgetsCTATapped:(id)sender {
    [self dismissKeyboard];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -150.0f;  // Move form up to accommodate keyboard
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

@end