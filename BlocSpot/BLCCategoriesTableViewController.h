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


@class BLCCategoriesTableViewController, BLCCategories, BLCCategoryTaleViewCell;
@protocol BLCCategoriesTableViewControllerDelegate <NSObject>

-(void)didSelectCell:(BLCCategoryTaleViewCell *)cell;
//-(void)controller:(BLCCategoriesTableViewController *)controller didPressDoneToSelectView:(UIView *)view;
-(void)controllerDidDismiss:(BLCCategoriesTableViewController *)controller;
-(void)category:(BLCCategories *)categoriesChosen;

-(void)controllerDidChoose:(UIColor *)color;

-(void)didCompleteWithImageView:(UIImageView *)image;
@end
@interface BLCCategoriesTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource >



@property (nonatomic, strong) id <BLCCategoriesTableViewControllerDelegate> delegate;
@property (nonatomic, assign) BLCCategoriesTableViewControllerState state;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *colorsCollectionView;
@property (nonatomic, strong)  NSMutableArray *colorsArray;
@property (nonatomic, strong)  NSMutableArray *colorsArraySimilar;

@property (nonatomic, strong) UIColor *categoryChosenColor;

@property (nonatomic, strong) NSDictionary *categories;

@property (nonatomic, strong) NSMutableArray *categoriesCreated;

@property (nonatomic, strong) NSMutableArray *selectedCategories;
@property (nonatomic, strong) NSMutableArray *selectedCell;




@end
