//
//  BLCSearchBarViewController.m
//  BlocSpot
//
//  Created by luiz parreira on 2/25/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCSearchViewController.h"

@interface BLCSearchViewController () 



@end

@implementation BLCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchResults"];
    
    [self.view addSubview:_tableView];
    [self createConstraints];
    
    
}


-(void)createConstraints  {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_tableView, _searchBar);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    /*
    [self.navigationController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_searchBar]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.navigationController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_searchBar]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResults" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BLCPointOfInterest *POI = [[BLCPointOfInterest alloc]init];
    //return [BLCPoiTableViewCell heightForPointOfInterestCell:POI width:CGRectGetWidth(self.view.bounds)];
    return 100;
}

- (void) searchBarSearchButtonClicked:(UISearchBar*) theSearchBar
{
    _searchBar = theSearchBar;
    [theSearchBar resignFirstResponder];
    [theSearchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchBar = searchBar;
    self.tableView.hidden = NO;
    [searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _searchBar = searchBar;
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
