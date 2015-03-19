//
//  BLCCategoriesTableViewController.h
//  BlocSpot
//
//  Created by luiz parreira on 3/3/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BLCCategoriesTableViewControllerState) {
    BLCCategoriesTableViewControllerAddCategory,
    BLCCategoriesTableViewControllerShowView
};


@class BLCCategoriesTableViewController, BLCCategories;
@protocol BLCCategoriesTableViewControllerDelegate <NSObject>


-(void)controllerDidDismiss:(BLCCategoriesTableViewController *)controller;
-(void)category:(BLCCategories *)categories;

@end
@interface BLCCategoriesTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource >



@property (nonatomic, strong) id <BLCCategoriesTableViewControllerDelegate> delegate;
@property (nonatomic, assign) BLCCategoriesTableViewControllerState state;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *colorsCollectionView;

@property (nonatomic, strong)  NSMutableArray *colorsArray;
@property (nonatomic, strong)  NSMutableArray *colorsArraySimilar;

@property (nonatomic, strong) UIColor *categoryChosenColor;

@property (nonatomic, strong) NSMutableDictionary *categories;

@property (nonatomic, strong) NSMutableArray *categoriesCreated;

@property (nonatomic, strong) NSMutableArray *selectedCategories;
@property (nonatomic, strong) NSMutableArray *imageViewSelected;






@end
