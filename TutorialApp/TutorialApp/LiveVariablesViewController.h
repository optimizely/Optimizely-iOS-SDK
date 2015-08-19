//
//  LiveVariablesViewController.h
//  TutorialApp
//
//  Created by Tony Zhang on 9/24/14.
//  Copyright (c) 2014 Optimizely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveVariablesViewController : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property NSMutableDictionary *storeItems;
@property (weak, nonatomic) IBOutlet UICollectionReusableView *headerView;
@property UILabel *salePrice;



@end