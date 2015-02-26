//
//  BLCMapViewController.m
//  BlocSpot
//
//  Created by luiz parreira on 2/23/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCMapViewController.h"

#import "BLCPoiTableViewController.h"
#import "BLCSearchViewController.h"

// UI stuff
#import "UIBarButtonItem+FlatUI.h"
#import "NSString+Icons.h"
#import "UIFont+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UINavigationBar+FlatUI.h"


@interface BLCMapViewController () <MKMapViewDelegate, UIViewControllerTransitioningDelegate,UISearchBarDelegate, UISearchControllerDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) BLCPoiTableViewController *tablePoiVC;
@property (nonatomic, strong) BLCSearchViewController *searchVC;
@property (nonatomic, strong) NSMutableArray *matchingItems;


@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) CLLocation *currentLocation;


@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *filterButton;
@property (nonatomic, strong) UIBarButtonItem * listBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem * labelBarButton;


@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;


@end

@implementation BLCMapViewController

-(instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    // set the tab bar color
    self.tablePoiVC =[[ BLCPoiTableViewController alloc]init];
   // [CLLocationManager requestWhenInUseAuthorization];
    
    // create a mapview
    self.mapView = [[MKMapView alloc]init];
    self.mapView.userInteractionEnabled =YES;
    [self.mapView setDelegate:self];
    [self.view addSubview:self.mapView ];
    self.mapView.showsUserLocation = YES;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    //[self gettingLocation];
    
    self.locationManager=[[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    self.tapGesture.delegate = self;
    self.tapGesture.numberOfTapsRequired = 1;
    
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressFired:)];
    self.longPress.delegate = self;
    [self.view addGestureRecognizer:self.longPress];
    
    [self.view addGestureRecognizer:self.tapGesture];
    // Code to change an icons color
    /*
    UIImage *image =[UIImage imageNamed:@"heart"];
    UIImageView *theImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, 44, 44)];
    theImageView.image = image;4
    theImageView.image = [theImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [theImageView setTintColor:[UIColor redColor]];
    UIImage *doneImage =[UIImage imageNamed:@"done-white"];
    UIImageView *doneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(24, 100, 36, 36)];
    doneImageView.image = doneImage;
    [self.view addSubview:theImageView];
    [self.view addSubview:doneImageView];
    */
    
    
    [self createConstraints];
    [self createTabBarButtons];
    [self createListViewBarButton];
    [self setUpSearchBar];
     self.searchVC = [[BLCSearchViewController alloc]init];
    
}
- (void)setUpSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
}

-(void)gettingLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];

}




-(void)createListViewBarButton {
    UILabel *label = [[UILabel alloc]init];
    label.attributedText = [self titleLabelString];

    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGFLOAT_MAX);
    CGSize labelMaxSize = [label sizeThatFits:maxSize];

    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelMaxSize.width, labelMaxSize.height)];
    label.frame = CGRectMake(0, 0, labelMaxSize.width, labelMaxSize.height);

    [customView addSubview:label];
    _labelBarButton = [[UIBarButtonItem alloc] initWithCustomView:customView];

    UIImage *listImage = [UIImage imageNamed:@"list"];
    self.listBarButtonItem = [[UIBarButtonItem alloc]initWithImage:listImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(listViewPressed:)];
    [_listBarButtonItem setTintColor:[UIColor cloudsColor]];
    self.navigationItem.leftBarButtonItems = @[_listBarButtonItem, _labelBarButton];
    
    [_listBarButtonItem configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];

}

-(NSAttributedString *)titleLabelString  {
    
    NSString *baseString = @"BlocSpot Map";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutAttString;
    
}

-(void) createTabBarButtons {
    UIImage *searchImage =[UIImage imageNamed:@"search"];

    self.searchButton   = [[UIBarButtonItem alloc]initWithImage:searchImage
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(searchButtonPressed:)];
    
    UIImage *filterImage=[UIImage imageNamed:@"filter"];

    
    self.filterButton = [[UIBarButtonItem alloc]initWithImage:filterImage
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(filterButtonPressed:)];
    
    [_filterButton setTintColor:[UIColor cloudsColor]];
    [_searchButton setTintColor:[UIColor cloudsColor]];
    [_filterButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];
    [_searchButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];

    [self.navigationItem setRightBarButtonItems:@[_filterButton, _searchButton]];
}

-(void)createConstraints {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mapView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    
     
     
}

#pragma mark tap gesture recognizer

-(void)tapFired:(UITapGestureRecognizer *)sender {
    [_searchBar resignFirstResponder];
    _searchBar.alpha = 0.0;
    self.navigationItem.titleView = nil;
    self.navigationItem.leftBarButtonItems = @[_listBarButtonItem, _labelBarButton];
    self.navigationItem.rightBarButtonItems =@[_filterButton, _searchButton];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.isEditing == NO;
}

-(void) longPressFired: (UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        
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




-(void)listViewPressed:(id)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:self.tablePoiVC animated:NO];

}
-(void)filterButtonPressed:(id)sender {
    
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
                         self.navigationItem.leftBarButtonItems = @[_listBarButtonItem, _labelBarButton];
                         self.navigationItem.rightBarButtonItems =@[_filterButton, _searchButton];

                     }];

    
}

#pragma mark MapViewDelegate
/*
-(void)mapView:(MKMapView *)mapV didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"map new location: %f %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    CLLocationCoordinate2D location = userLocation.coordinate;
    
    MKCoordinateRegion region;
    region.center = location;
    MKCoordinateSpan span;
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    region.span=span;
    
    [mapV setRegion:region animated:TRUE];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error.description);
}
 */
@end
