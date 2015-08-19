//
//  VariationTableViewCell.h
//  TutorialApp
//
//  Created by Pamela Ongchin on 11/7/14.
//  Copyright (c) 2014 Optimizely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VariationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconVariationImg;
@property (weak, nonatomic) IBOutlet UILabel *variationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *variationDescLabel;

@end
