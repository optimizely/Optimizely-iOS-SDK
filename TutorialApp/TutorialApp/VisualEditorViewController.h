//
//  VisualEditorViewController.h
//  TutorialApp
//
//  Created by Tony Zhang on 9/24/14.
//  Copyright (c) 2014 Optimizely. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface VisualEditorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *optlyEmailField;
@property (weak, nonatomic) IBOutlet UITextField *optlyPhoneField;
@property (weak, nonatomic) IBOutlet UITextField *optlyPassField;
@property (weak, nonatomic) IBOutlet UIButton *optlyWidgetsCTA;
@property (weak, nonatomic) IBOutlet UIScrollView *optlyFormScrollView;

@end
