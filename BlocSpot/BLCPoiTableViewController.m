//
//  BLCPoiTableViewController.m
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCPoiTableViewController.h"
#import "BLCMapViewController.h"
#import "BLCPoiTableViewCell.h"

#import "BLCPointOfInterest.h"
#import "BLCDataSource.h"


//UI stuff
#import "FlatUIKit.h"


@interface BLCPoiTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, BLCPoiTableViewCellDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) BLCMapViewController *mapVC;


@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *filterButton;
@property (nonatomic, strong) UIBarButtonItem * mapBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem * labelBarButton;
@end

@implementation BLCPoiTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[BLCDataSource sharedInstance] addObserver:self forKeyPath:@"annotations" options:0 context:nil];
//    [[BLCDataSource sharedInstance] addObserver:self forKeyPath:@"categories" options:0 context:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.hidesBackButton = YES;

    self.mapVC = [[BLCMapViewController alloc]init];
    [self.tableView registerClass:[BLCPoiTableViewCell class] forCellReuseIdentifier:@"Points"];
    
    // Adding a title and setting its attributes

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]};
    
    [self addLeftBarButton];
    [self addRightBarButttons];
    [self setUpSearchBar];
    
}
-(void)dealloc
{
    [[BLCDataSource sharedInstance] removeObserver:self forKeyPath:@"annotations"];
//    [[BLCDataSource sharedInstance] removeObserver:self forKeyPath:@"categories"];

}

- (void)setUpSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
}

-(void)addLeftBarButton {
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGFLOAT_MAX);

    UILabel *label = [[UILabel alloc]init];
    label.attributedText = [self titleLabelString];
    
    CGSize labelMaxSize = [label sizeThatFits:maxSize];
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelMaxSize.width, labelMaxSize.height)];
    label.frame = CGRectMake(0, 0, labelMaxSize.width, labelMaxSize.height);

    [customView addSubview:label];
    self.labelBarButton = [[UIBarButtonItem alloc] initWithCustomView:customView];


    UIImage *mapImage = [UIImage imageNamed:@"map"];
    self.mapBarButtonItem = [[UIBarButtonItem alloc]initWithImage:mapImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(mapViewPressed:)];
    [_mapBarButtonItem configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];
    [_mapBarButtonItem setTintColor:[UIColor cloudsColor]];
    self.navigationItem.leftBarButtonItems = @[_mapBarButtonItem, _labelBarButton];
    
}

#pragma mark Attributed Strings

-(NSAttributedString *)placeNameStringWithString:(NSString *)string{
    
    CGFloat placeNameFontSize = 18;
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 10.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    if (string)
    {
        
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName :[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],NSParagraphStyleAttributeName : mutableParagraphStyle}];
    
    NSRange stringRange = [string rangeOfString:string];
    [mutAttString addAttribute:NSForegroundColorAttributeName value:[UIColor midnightBlueColor] range:stringRange];
    return mutAttString;
    } else
    {
        return nil;
    }

}


-(NSAttributedString *)notesAboutPlaceStringWithString:(NSString *)string{
    
    
    NSString *baseString = string;
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    if (string){
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName :[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSParagraphStyleAttributeName : mutableParagraphStyle }];
    NSRange stringRange = [baseString rangeOfString:baseString];
    [mutAttString addAttribute:NSForegroundColorAttributeName value:[UIColor midnightBlueColor] range:stringRange];
    
    return mutAttString;
    }else return nil;
    
}


-(NSAttributedString *)howFarIsItString {

    NSString *baseString = @"< 1 min.";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName :[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] }];
    NSRange stringRange = [baseString rangeOfString:baseString];
    [mutAttString addAttribute:NSForegroundColorAttributeName value:[UIColor midnightBlueColor] range:stringRange];
    
    return mutAttString;
    
}



-(NSAttributedString *)titleLabelString  {
    
    NSString *baseString = @"BlocSpot";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];

    return mutAttString;
    
}


-(void) addRightBarButttons {
    
    UIImage *searchImage =[UIImage imageNamed:@"search"];
    
    self.searchButton = [[UIBarButtonItem alloc]initWithImage:searchImage
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(searchButtonPressed:)];
    [_searchButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                              highlightedColor:[UIColor wetAsphaltColor]
                                  cornerRadius:3];
    [_searchButton setTintColor:[UIColor cloudsColor]];
    UIImage *filterImage=[UIImage imageNamed:@"filter"];
    
    
    self.filterButton = [[UIBarButtonItem alloc]initWithImage:filterImage
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(filterButtonPressed:)];
    
    
    [_filterButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                              highlightedColor:[UIColor wetAsphaltColor]
                                  cornerRadius:3];
    [_filterButton setTintColor:[UIColor cloudsColor]];
    
    //filterButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.navigationItem.rightBarButtonItems = @[_filterButton, _searchButton];



}

-(void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [BLCDataSource sharedInstance].annotations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLCPoiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Points" forIndexPath:indexPath];
    
    BLCPointOfInterest *poi = [BLCDataSource sharedInstance].annotations[indexPath.row];
    
    cell.nameOfPlace.attributedText = [self placeNameStringWithString:poi.placeName];
    cell.notesAboutPlace.attributedText = [self notesAboutPlaceStringWithString:poi.notes];
    cell.howFarIsIt.attributedText = [self howFarIsItString];
//    [cell.categoryButton setImage:[self returnImageColored].image forState:UIControlStateNormal];
    [cell.categoryButton setTintColor:poi.category.color];

    if ([poi.visited isEqualToString:@"1"]){
            cell.categoryButton.vistButtonState = BLCVisitButtonSelectedYES;
            
    } else
    {
        cell.categoryButton.vistButtonState = BLCVisitButtonSelectedNO;
    }
    
//    if (cell.state == BLC)

    
    return cell;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BLCPointOfInterest *poi = [BLCDataSource sharedInstance].annotations[indexPath.row];
        [[BLCDataSource sharedInstance] deletePointOfInterest:poi];
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BLCPointOfInterest *POI = [[BLCPointOfInterest alloc]init];
   //return [BLCPoiTableViewCell heightForPointOfInterestCell:POI width:CGRectGetWidth(self.view.bounds)];
    return 100;
}

// HELPER FUNCTION
-(UIImageView *)returnImageColored
{
    UIImageView *imageView = [UIImageView new];
    UIImage *image = [UIImage imageNamed:@"heart"];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.image = image;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return imageView;
    
}


#pragma mark BLCPoiTableViewCellDelegate

-(void)cellDidPressOnButton:(BLCPoiTableViewCell *)cell {
    
    
    for (BLCPointOfInterest *poi in [BLCDataSource sharedInstance].annotations){
        
        if (poi.customAnnotation == cell.customAnnotation){
            if ([poi.visited isEqualToString:@"0"]) {
                poi.visited = @"1";
                cell.categoryButton.vistButtonState = BLCVisitButtonSelectedYES;
                
            }else
            {
                poi.visited = @"0";
                cell.categoryButton.vistButtonState = BLCVisitButtonSelectedNO;
                
            }
        }
    }

    
}


#pragma mark UITabBar button actions
-(void)searchButtonPressed:(id)sender{
    
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:.75
          initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
                         _searchBar.alpha = 1.0;
                         // remove other buttons
                         
                         self.navigationItem.rightBarButtonItems = nil;
                         self.navigationItem.leftBarButtonItems = nil;
                         self.navigationItem.titleView = _searchBar;
                         [_searchBar becomeFirstResponder];
                         
                         
                         
                     } completion:^(BOOL finished) {
                         
                         // add the search bar (which will start out hidden).
                         
                         
                     }];
}


-(void)mapViewPressed:(id)sender {
    if (self.mapVC){
        [self.navigationController pushViewController:self.mapVC animated:YES];
    }
}

#pragma mark UISearchBarDelegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.9
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:kNilOptions
                     animations:^{
                         
                         
                     } completion:^(BOOL finished) {
                         _searchBar.alpha = 0.0;
                         
                         self.navigationItem.titleView = nil;
                         self.navigationItem.leftBarButtonItems = @[_mapBarButtonItem, _labelBarButton];
                         self.navigationItem.rightBarButtonItems =@[_filterButton, _searchButton];
                         
                     }];
    
    
}

#pragma mark Key-Value Observing

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [BLCDataSource sharedInstance] && ([keyPath isEqualToString:@"annotations"])) {
        // Nothing… YET
        int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
        
        if (kindOfChange == NSKeyValueChangeSetting) {
            // Someone set a brand new images array
            [self.tableView reloadData];
        } else if (kindOfChange == NSKeyValueChangeInsertion ||
                   kindOfChange == NSKeyValueChangeRemoval ||
                   kindOfChange == NSKeyValueChangeReplacement) {
            // We have an incremental change: inserted, deleted, or replaced images
            
            // Get a list of the index (or indices) that changed
            NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
            
            // Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
            NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
            [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexPathsThatChanged addObject:newIndexPath];
            }];
            
            // Call `beginUpdates` to tell the table view we're about to make changes
            [self.tableView beginUpdates];
            
            // Tell the table view what the changes are
            if (kindOfChange == NSKeyValueChangeInsertion) {
                [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeRemoval) {
                [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeReplacement) {
                [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            // Tell the table view that we're done telling it about changes, and to complete the animation
            [self.tableView endUpdates];
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
