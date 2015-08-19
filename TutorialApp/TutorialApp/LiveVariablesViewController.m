//
//  LiveVariablesViewController.m
//  TutorialApp
//
//  Created by Tony Zhang on 9/24/14.
//  Copyright (c) 2014 Optimizely. All rights reserved.
//

#import "LiveVariablesViewController.h"
#import "DiscountCollectionReusableView.h"
#import <Optimizely/Optimizely.h>

#define kCellsPerRow 2

@interface LiveVariablesViewController ()

@end

@implementation LiveVariablesViewController


// [OPTIMIZELY] Examples of how to declare live variables (Part 1 of 2)
OptimizelyVariableKeyForNumber(liveVariableNumberofItems, [NSNumber numberWithInt: 4]);
OptimizelyVariableKeyForNumber(liveVariableDiscount, [NSNumber numberWithFloat: 0.10]);
OptimizelyVariableKeyForBool(liveVariableBool, NO);



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // Add title for View Controller and make it such that back button has no text
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = @"Live Variables";
    self.navigationController.title = @"Live Variables";
    
    // Create list of objects
    self.storeItems = [NSMutableDictionary dictionary];
    [self.storeItems setObject:[NSArray arrayWithObjects:@"3.99", @"6.99", @"9.99", @"12.99", @"15.99", @"18.99", nil] forKey:@"originalprice"];
    [self.storeItems setObject:[NSArray arrayWithObjects:@"Standard Widget", @"Standard Widget Pack", @"Deluxe Widget", @"Deluxe Widget Pack", @"Premium Widget", @"Premium Widget Pack", nil] forKey:@"productname"];
    [self.storeItems setObject:[NSArray arrayWithObjects:@"gear1.png", @"gear2.png", @"gear3.png", @"gear4.png", @"gear6.png", @"gear5.png", nil] forKey:@"productimg"];
    
    [Optimizely registerCallbackForVariableWithKey:liveVariableNumberofItems callback:^(NSString *key, id value){
        NSLog(@"The order of sales items has changed: %@ is now %@\n", key, value);
        [self.collectionView reloadData];
    }];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.collectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    CGFloat cellWidth = availableWidthForCells / kCellsPerRow;
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = @"Live Variables";
    self.navigationController.title = @"Live Variables";
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // [OPTIMIZELY] Examples of how to use live variable values (Part 2 of 2)
    if ([[Optimizely numberForKey:liveVariableNumberofItems] integerValue] > 6) {
        return 6;
    }
    else {
        return [[Optimizely numberForKey:liveVariableNumberofItems] integerValue];
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CollectionCell";
    
    //TODO: Do something different for each image/label
    //      Right now they all look the same
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Round corners of each item
    cell.layer.cornerRadius = 5;
    
    // Set Product Name
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:1];
    title.text = [self.storeItems objectForKey:@"productname"][(long)indexPath.row];
    title.font = [UIFont fontWithName:@"Gotham-Medium" size:10];
    
    // Set Image
    UIImageView *im = (UIImageView *)[cell.contentView viewWithTag:2];
    im.image = [UIImage imageNamed:[self.storeItems objectForKey:@"productimg"][(long)indexPath.row]];
    
    // Orig price
    UILabel *origPrice = (UILabel *)[cell.contentView viewWithTag:3];
    origPrice.text = [self.storeItems objectForKey:@"originalprice"][(long)indexPath.row];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:origPrice.text
                                                                           attributes:attributes];
    
    origPrice.attributedText = attributedString;
    
    
    //origPrice.font = [UIFont fontWithName:@"Gotham-Medium" size:10];
    
    // Sale price
    self.salePrice = (UILabel *)[cell.contentView viewWithTag:4];
    
    float origPriceVal = [[self.storeItems objectForKey:@"originalprice"][(long)indexPath.row] floatValue];
    NSLog(@"%.02f",origPriceVal);
    
    // [OPTIMIZELY] Examples of how to use live variable values (Part 2 of 2)
    float discountPrice = origPriceVal - (origPriceVal * [[Optimizely numberForKey:liveVariableDiscount] floatValue]);
    
    
    self.salePrice.text = [NSString stringWithFormat:@"$%.02f", discountPrice];
    //origPrice.font = [UIFont fontWithName:@"Gotham-Medium" size:10];
    
    // force layout
    [self.salePrice setNeedsLayout];
    [self.salePrice layoutIfNeeded];
    
    // get the fitting size
    CGSize s = [self.salePrice systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
    NSLog( @"fittingSize: %@", NSStringFromCGSize( s ));
    
    // force layout
    [origPrice setNeedsLayout];
    [origPrice layoutIfNeeded];
    
    // get the fitting size
    CGSize s_origPrice = [origPrice systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
    NSLog( @"fittingSize: %@", NSStringFromCGSize( s ));
    
    // force layout
    [im setNeedsLayout];
    [im layoutIfNeeded];
    
    // get the fitting size
    CGSize s_im = [origPrice systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
    NSLog( @"fittingSize: %@", NSStringFromCGSize( s ));
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        DiscountCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        // [OPTIMIZELY] Examples of how to use live variable values (Part 2 of 2)
        float discountVal = [[Optimizely numberForKey:liveVariableDiscount] floatValue];
        NSString *title = [[NSString alloc]initWithFormat:@"TAKE %0.0f%% OFF FROM NOW UNTIL 9/15",discountVal * 100];
        headerView.discountLabel.text = title;
        [headerView.discountLabel center];
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    float origPriceVal = [[self.storeItems objectForKey:@"originalprice"][(long)indexPath.row] floatValue];
    NSLog(@"%.02f",origPriceVal);
    
    // [OPTIMIZELY] Example of how to use live variable values (Part 2 of 2)
    float discountPrice = origPriceVal - (origPriceVal * [[Optimizely numberForKey:liveVariableDiscount] floatValue]);
    discountPrice = discountPrice * 100;
    int discountPrice_int = (int) discountPrice;
    
    // [OPTIMIZELY] Example of how to use revenue tracking goal
    [Optimizely trackRevenue:discountPrice_int];
    
    // [OPTIMIZELY] Example of how to use track event
    [Optimizely trackEvent:@"item_selected"];
}



@end
