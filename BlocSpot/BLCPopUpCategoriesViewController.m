//
//  BLCPopUpCategoriesViewController.m
//  BlocSpot
//
//  Created by luiz parreira on 3/17/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCPopUpCategoriesViewController.h"
#import "WYPopoverController.h"
#import "BLCCategoriesTableViewController.h"
#import "BLCMapViewController.h"
#import "BLCPoiTableViewController.h"
#import "BLCCategoryTaleViewCell.h"
#import "BLCMapViewController.h"
#import "BLCCustomCallOutView.h"

#import "BLCDataSource.h"

@interface BLCPopUpCategoriesViewController ()

@property (nonatomic, strong) BLCCategoriesTableViewController *categoryVCpopup;
@property (nonatomic, strong) BLCPoiTableViewController *poiTableVC;
@property (nonatomic, strong) WYPopoverController *popover;
@property (nonatomic, strong) BLCMapViewController  *mapVC;
@property (nonatomic, strong) UINavigationController *navVCPopup;

@property (nonatomic, strong) NSMutableArray *selectedCategories;
@end

@implementation BLCPopUpCategoriesViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [[BLCDataSource sharedInstance] addObserver:self forKeyPath:@"categories" options:0 context:nil];
    [self.tableView registerClass:[BLCCategoryTaleViewCell class] forCellReuseIdentifier:@"CategoryCell"];

}



-(void)dealloc
{
    [[BLCDataSource sharedInstance] removeObserver:self forKeyPath:@"categories"];

}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        BLCCategories *item = [BLCDataSource sharedInstance].categories[indexPath.row];
        [[BLCDataSource sharedInstance] deleteCategories:item];
        //        [self.tableView reloadData];
        NSLog(@"ALL CATEGORIES AFTER DELETING = %@",[BLCDataSource sharedInstance].categories);
        
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BLCCategoryTaleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    BLCCategories *categories = [BLCDataSource sharedInstance].categories[indexPath.row];
    cell.category = categories;
    NSLog(@"[BLCDataSource sharedInstance].categories *** %@ ***", [BLCDataSource sharedInstance].categories);

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    BLCCategoryTaleViewCell *cell = (BLCCategoryTaleViewCell *)[tableView cellForRowAtIndexPath:indexPath ];
    cell.state = BLCCategoryTaleViewCellStateSelectedYES;

    BLCCategories *categories = [BLCDataSource sharedInstance].categories[indexPath.row];
    self.selectedCategories = [NSMutableArray new];
    [self.selectedCategories addObject:categories];
    NSLog(@"[self.parentViewController.parentViewController.parentViewController  :%@ ]", self.parentViewController.parentViewController );
    [self.popupDelegate getSelectedCategories:self.selectedCategories andProceed:YES];

    [self.popupDelegate getSelectedCategories:self.selectedCategories andProceed:NO];

    [cell setNeedsDisplay];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BLCCategoryTaleViewCell *cell = (BLCCategoryTaleViewCell *)[tableView cellForRowAtIndexPath:indexPath ];
    BLCCategories *categories = [BLCDataSource sharedInstance].categories[indexPath.row];
    [self.selectedCategories removeObject:categories];
    cell.state = BLCCategoryTaleViewCellStateUnSelectedNOT;
    [cell setNeedsDisplay];
    
    
}

@end
