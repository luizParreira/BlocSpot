//
//  BLCMapViewController.m
//  BlocSpot
//
//  Created by luiz parreira on 2/23/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCMapViewController.h"
#import "BLCCustomAnnotation.h"
#import "BLCCustomCreateAnnotationsView.h"
#import "BLCComposePlacesViewController.h"
#import "CustomIOS7AlertView.h"


#import "BLCPoiTableViewController.h"
#import "BLCSearchViewController.h"
#import "BLCDataSource.h"
#import "BLCPointOfInterest.h"
#import "FPPopoverController.h"
#import "SMCalloutView.h"

#import "WYPopoverController.h"

// UI stuff
#import "FlatUIKit.h"
#import "UIPopoverController+FlatUI.h"

typedef NS_ENUM(NSInteger, BLCMapViewControllerState) {
    BLCMapViewControllerStateMapContent,
    BLCMapViewControllerStateAddPoi
};


@interface BLCMapViewController () <MKMapViewDelegate, UIViewControllerTransitioningDelegate,UISearchBarDelegate, UISearchControllerDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate, BLCCustomCreateAnnotationsViewDelegate, FPPopoverControllerDelegate, UIPopoverControllerDelegate, WYPopoverControllerDelegate >

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) BLCPoiTableViewController *tablePoiVC;
@property (nonatomic, strong) BLCSearchViewController *searchVC;

@property (nonatomic, strong) BLCCustomAnnotation *customAnnotation;
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

@property (nonatomic, strong) BLCPointOfInterest *poi;


@property (nonatomic, strong) NSMutableDictionary *params;


@property (nonatomic, assign) CLLocationCoordinate2D coords;
@property (nonatomic, strong) MKAnnotationView *annotationView;


@property (nonatomic, assign)CGPoint point;

@property (nonatomic, assign) BLCMapViewControllerState state;


@end
static NSString *viewId = @"HeartAnnotation";

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
    self.navigationItem.hidesBackButton = YES;

    // create a mapview
    self.mapView = [[MKMapView alloc]init];
    self.mapView.userInteractionEnabled =YES;
    [self.mapView setDelegate:self];
    [self.view addSubview:self.mapView ];
    self.mapView.showsUserLocation = YES;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;

    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    self.tapGesture.delegate = self;
    self.tapGesture.numberOfTapsRequired = 1;
    
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(addAnnotation:)];
    self.longPress.delegate = self;
    self.longPress.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:self.longPress];
    
    [self.mapView addGestureRecognizer:self.tapGesture];
    
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
    
    [self updateLocation];
    [self createConstraints];

    [self createTabBarButtons];
    [self createListViewBarButton];
    [self setUpSearchBar];

    
    
    self.annotationView = (MKAnnotationView*)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:viewId];
//    self.composePlacesVC = [[BLCComposePlacesViewController alloc]init];
//    self.popOver = [[WYPopoverController alloc]initWithContentViewController:_composePlacesVC];
//    self.popOver.delegate = self;
    
    //View that will create a new POI
    self.createAnnotationView = [[BLCCustomCreateAnnotationsView alloc]init];
    self.state = BLCMapViewControllerStateMapContent;

    

}
- (void)setUpSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
}


-(void)layoutViews {
    CGFloat padding = 10;

    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat yOffset = 0.f;
    
    
    
    switch (self.state) {
        case BLCMapViewControllerStateMapContent: {
            
            [self.createAnnotationView setHidden:YES];
            self.mapView.scrollEnabled = YES;

        } break;
        case BLCMapViewControllerStateAddPoi: {
        
            [self.mapView addSubview:self.createAnnotationView];
            self.createAnnotationView.translatesAutoresizingMaskIntoConstraints = NO;
            NSLog(@"viewHeight = %f", viewHeight );
            [self.createAnnotationView setHidden:NO];
            self.mapView.scrollEnabled = NO;
            [self setLayoutOfCreateAnnotationView];
    
            
            yOffset = 70.f;
        } break;
            
    }


}

// Hide tab bar when lanscape mode
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (self.state == BLCMapViewControllerStateAddPoi) {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
            [self.navigationController.navigationBar setHidden:YES];
        }   else{
            [self.navigationController.navigationBar setHidden:NO];
        }
    }
    
}

-(void) setLayoutOfCreateAnnotationView
{
    [self.mapView addConstraints:({
        @[ [NSLayoutConstraint
            constraintWithItem:_createAnnotationView
            attribute:NSLayoutAttributeCenterX
            relatedBy:NSLayoutRelationEqual
            toItem:self.mapView
            attribute:NSLayoutAttributeCenterX
            multiplier:1.f constant:0.f],
           
           [NSLayoutConstraint
            constraintWithItem:_createAnnotationView
            attribute:NSLayoutAttributeCenterY
            relatedBy:NSLayoutRelationEqual
            toItem:self.mapView
            attribute:NSLayoutAttributeCenterY
            multiplier:1.f constant:0] ];
    })];
    NSLayoutConstraint *viewHeightConstraint = [NSLayoutConstraint constraintWithItem:_createAnnotationView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:(44*4)+ 100];
    [self.mapView addConstraint:viewHeightConstraint ];
    NSLayoutConstraint *viewWidthConstraint = [NSLayoutConstraint constraintWithItem:_createAnnotationView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:CGRectGetWidth(self.view.bounds)- 20];
    [self.mapView addConstraint:viewWidthConstraint];
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

#pragma mark - Overrides

-(void)setState:(BLCMapViewControllerState)state animated:(BOOL)animated {
    _state = state;
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self layoutViews];
                         }];
        
    } else {
        [self layoutViews];
    }

}
-(void)setState:(BLCMapViewControllerState)state{
    [self setState:state animated:NO];
}

#pragma Location delegate methods call

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        self.locationManager=[[CLLocationManager alloc] init];
        self.locationManager.delegate=self;
        
        self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
        [self.locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

-(void)updateLocation {
    [self.locationManager startUpdatingLocation];

}

-(void)fetchVenuesForLocation:(CLLocation *)location {
    
}

-(void)zoomToLocation:(CLLocation *)location radius:(CGFloat)radius {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius*2, radius*2);
    [self.mapView setRegion:region];
    
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


// Setting auto Layout constraints



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
    self.locationManager = nil;

}


-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    
     
     
}
#pragma BLCCustomAnnotationsViewDelegate

-(void)customView:(BLCCustomCreateAnnotationsView *)view
didPressDoneButton:(FUIButton *)button
    withTitleText:(NSString *)titleText
withDescriptionText:(NSString *)descriptionText
          withTag:(NSString *)tag
{
    [self.createAnnotationView resignFirstResponder];
    self.params = [NSDictionary mutableCopy];
    
    [self.params setObject:titleText forKey:@"place"];
    [self.params setObject:descriptionText forKey:@"description"];
    [self.params setObject:tag forKey:@"category"];
    NSLog(@"params = %@", self.params);
}

#pragma mark tap gesture recognizer

-(void)tapFired:(UITapGestureRecognizer *)sender
{
    [_searchBar resignFirstResponder];
    _searchBar.alpha = 0.0;
    self.navigationItem.titleView = nil;
    self.navigationItem.leftBarButtonItems = @[_listBarButtonItem, _labelBarButton];
    self.navigationItem.rightBarButtonItems =@[_filterButton, _searchButton];
    [self setState:BLCMapViewControllerStateMapContent animated:NO];
}


-(void) addAnnotation: (UILongPressGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self setState:BLCMapViewControllerStateAddPoi animated:YES];
    
        self.point = [sender locationInView:self.mapView];
        self.coords = [self.mapView convertPoint:self.point toCoordinateFromView:self.mapView];
        
        self.customAnnotation = [[BLCCustomAnnotation alloc]initWithCoordinate:_coords];
        [self.params setObject:self.customAnnotation forKey:@"annotation"];
        
        self.poi = [[BLCPointOfInterest alloc] initWithDictionary:self.params];
        
        [self.mapView addAnnotation:self.poi.customAnnotation];
        
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

                         
                    self.navigationItem.rightBarButtonItems = nil;
                    self.navigationItem.leftBarButtonItems = nil;
                    self.navigationItem.titleView = _searchBar;
                    [_searchBar becomeFirstResponder];


        
    } completion:^(BOOL finished) {
        


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
    te
    [mapV setRegion:region animated:TRUE];
}
*/
//
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    MKAnnotationView* newAnnotation = [views firstObject];
//}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // this part is boilerplate code used to create or reuse a pin annotation
    _annotationView = [[MKAnnotationView alloc]
                          initWithAnnotation:annotation reuseIdentifier:viewId];
    
    // set your custom image
    _annotationView.image = [UIImage imageNamed:@"heart"];
    return _annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    //SMCalloutView *callOutView = [[SMCalloutView alloc] init];
    //callOutView.contentView = composePlacesVC.view;
    //[callOutView presentCalloutFromRect:self.view.frame inView:mapView constrainedToView:mapView permittedArrowDirections:SMCalloutArrowDirectionUp animated:YES];
//    self.popOver.popoverContentSize = self.composePlacesVC.view.bounds.size;
//    
//    [self.popOver presentPopoverFromRect:view.frame
//                                  inView:mapView
//                permittedArrowDirections:WYPopoverArrowDirectionAny
//                                animated:YES
//                                 options:WYPopoverAnimationOptionScale
//                              completion:nil];

    
    //   EXTERNAL LIBRARY POPOVER
//    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:composePlacesVC ];
//    popover.delegate = self;
//    popover.border = NO;
//    popover.arrowDirection = FPPopoverArrowDirectionIsVertical(FPPopoverArrowDirectionUp);
//    popover.origin = view.frame.origin;
//    //[popover setShadowsHidden:YES];
//    [popover presentPopoverFromPoint:view.frame.origin];
    
    
    
    

}

#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    [self fetchVenuesForLocation:location];
    [self zoomToLocation:location radius:2000];
    [self.locationManager stopUpdatingLocation];

}

@end
