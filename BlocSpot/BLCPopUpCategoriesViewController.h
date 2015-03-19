//
//  BLCPopUpCategoriesViewController.h
//  BlocSpot
//
//  Created by luiz parreira on 3/17/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCCategoriesTableViewController.h"

@class BLCPopUpCategoriesViewController;
@protocol BLCPopUpCategoriesViewControllerDelegate <NSObject>


-(void)getSelectedCategories:(NSArray *)categories andProceed:(BOOL)proceed;


@end
@interface BLCPopUpCategoriesViewController : BLCCategoriesTableViewController

@property (nonatomic, strong)NSObject <BLCPopUpCategoriesViewControllerDelegate> *popupDelegate;

@property (nonatomic, strong) NSArray *filteredCategories;

@end
