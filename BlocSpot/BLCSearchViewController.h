//
//  BLCSearchBarViewController.h
//  BlocSpot
//
//  Created by luiz parreira on 2/25/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCSearchViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchBarController;
@property (nonatomic, assign) BOOL isSearching;



@end
