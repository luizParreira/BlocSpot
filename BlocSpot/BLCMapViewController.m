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
#import "CustomIOS7AlertView.h"


#import "BLCPoiTableViewController.h"
#import "BLCSearchViewController.h"
#import "BLCPointOfInterest.h"
#import "FPPopoverController.h"
#import "SMCalloutView.h"

#import "WYPopoverController.h"

#import "BLCCategoriesTableViewController.h"

// UI stuff
#import "FlatUIKit.h"
#import "UIPopoverController+FlatUI.h"

typedef NS_ENUM(NSInteger, BLCMapViewControllerState) {
    BLCMapViewControllerStateMapContent,
    BLCMapViewControllerStateAddPoi
};


@interface BLCMapViewController () <MKMapViewDelegate, UIViewControllerTransitioningDelegate,UISearchBarDelegate, UISearchControllerDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate, FPPopoverControllerDelegate, UIPopoverControllerDelegate, WYPopoverControllerDelegate, BLCCustomCreateAnnotationsViewDelegate, BLCCategoriesTableViewControllerDelegate  >

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) BLCPoiTableViewController *tablePoiVC;
@property (nonatomic, strong) BLCSearchViewController *searchVC;

@property (nonatomic, strong) BLCCategoriesTableViewController *categoryVC;
@property (nonatomic, strong) BLCCategoriesTableViewController *categoryVCpopup;

@property (nonatomic, strong) WYPopoverController *popover;

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
@property (nonatomic, strong) BLCCategories *category;



@property (nonatomic, strong) NSMutableDictionary *params;


@property (nonatomic, assign) CLLocationCoordinate2D coords;
@property (nonatomic, strong) MKAnnotationView *annotationView;


@property (nonatomic, assign)CGPoint point;

@property (nonatomic, assign) BLCMapViewControllerState state;

@property (nonatomic, strong)UINavigationController *navVC;

@property (nonatomic, strong) UIColor *pinColor;

@property (nonatomic, strong) UIImageView *heartImageView;






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
//    [self loadAnnotations];
    self.mapView.showsUserLocation = YES;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;

    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    self.tapGesture.delegate = self;
    self.tapGesture.numberOfTapsRequired = 1;
    
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(createAnnotation:)];
    self.longPress.delegate = self;
    self.longPress.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:self.longPress];
    
    [self.mapView addGestureRecognizer:self.tapGesture];
    

    [self updateLocation];
    [self createConstraints];

    [self createTabBarButtons];
    [self createListViewBarButton];
    [self setUpSearchBar];
    if(!_categoryVC){
    self.categoryVC = [[BLCCategoriesTableViewController alloc]init];
        self.categoryVC.delegate = self;
    }
    
    if(!_categoryVCpopup){
        self.categoryVCpopup = [[BLCCategoriesTableViewController alloc]init];
        self.categoryVCpopup.delegate = self;
    }
    self.navVC = [[UINavigationController alloc]initWithRootViewController:self.categoryVC];
    UINavigationController *navVCPopup =[[UINavigationController alloc]initWithRootViewController:self.categoryVCpopup];
    UIBarButtonItem *leftBarButtonPopup = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(popupBarButtonItemDonePressed:)];
    self.categoryVCpopup.navigationItem.leftBarButtonItem = leftBarButtonPopup;

    if (!_popover){
    self.popover = [[WYPopoverController alloc]initWithContentViewController:navVCPopup];
    self.popover.delegate = self;
    self.popover.popoverContentSize = CGSizeMake(self.popover.contentViewController.view.frame.size.width, 44*7 + 20);
        

        
    }
    _annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:viewId];


    //View that will create a new POI
    if (!_createAnnotationView) {
    self.createAnnotationView = [[BLCCustomCreateAnnotationsView alloc]init];
    self.createAnnotationView.delegate = self;
    
    }
    if (!_category){
        self.category = [[BLCCategories alloc]init];
    }
    
    
    self.state = BLCMapViewControllerStateMapContent;
    if(!self.params){
        self.params = [NSMutableDictionary new];
    }
}


- (void)setUpSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
}


-(void)layoutViews {

    
    
    
    switch (self.state) {
        case BLCMapViewControllerStateMapContent: {
            
            [self.createAnnotationView setHidden:YES];
            [self.createAnnotationView resignFirstResponder];
            self.mapView.scrollEnabled = YES;
            [self.navigationController.navigationBar setHidden:NO];


        } break;
        case BLCMapViewControllerStateAddPoi: {
            [self.createAnnotationView removeGestureRecognizer:self.tapGesture];
            [self.mapView addSubview:self.createAnnotationView];
            self.createAnnotationView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.createAnnotationView setHidden:NO];
            self.mapView.scrollEnabled = NO;
            [self setLayoutOfCreateAnnotationView];
            [self.navigationController.navigationBar setHidden:YES];

            
        } break;
    }


}

// Hide tab bar when both landscape andmode
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (self.state == BLCMapViewControllerStateAddPoi) {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
            [self.navigationController.navigationBar setHidden:YES];
        }   else{
            [self.navigationController.navigationBar setHidden:YES];
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

-(void) setLayoutCategoriesVC
{
    [self.mapView addConstraints:({
        @[ [NSLayoutConstraint
            constraintWithItem:_categoryVC
            attribute:NSLayoutAttributeCenterX
            relatedBy:NSLayoutRelationEqual
            toItem:self.mapView
            attribute:NSLayoutAttributeCenterX
            multiplier:1.f constant:0.f],
           
           [NSLayoutConstraint
            constraintWithItem:_categoryVC
            attribute:NSLayoutAttributeCenterY
            relatedBy:NSLayoutRelationEqual
            toItem:self.mapView
            attribute:NSLayoutAttributeCenterY
            multiplier:1.f constant:0] ];
    })];
    NSLayoutConstraint *viewHeightConstraint = [NSLayoutConstraint constraintWithItem:_categoryVC
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:(44*4)+ 100];
    [self.mapView addConstraint:viewHeightConstraint ];
    NSLayoutConstraint *viewWidthConstraint = [NSLayoutConstraint constraintWithItem:_categoryVC
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


// TO DO
-(void)fetchVenuesForLocation:(CLLocation *)location {
    
}

-(void)zoomToLocation:(CLLocation *)location radius:(CGFloat)radius {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius*2, radius*2);
    [self.mapView setRegion:region];
    
}

#pragma mark Attributed String
-(NSAttributedString *)titleLabelString  {
    
    NSString *baseString = @"BlocSpot Map";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutAttString;
    
}

#pragma mark creat TabBar buttons
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




#pragma mark BLCCustomAnnotationsViewDelegate

-(void)customView:(BLCCustomCreateAnnotationsView *)view
didPressDoneButton:(FUIButton *)button
    withTitleText:(NSString *)titleText
withDescriptionText:(NSString *)descriptionText
//withCategory:(BLCCategories *)category
{
    
    
    [self.params setObject:titleText forKey:@"placeName"];
    [self.params setObject:descriptionText forKey:@"notes"];
    
//    NSLog(@"self.params before initializing POI [%@]", self.params);
    
    self.poi = [[BLCPointOfInterest alloc] initWithDictionary:self.params];
    [[BLCDataSource sharedInstance] addPointOfInterest:self.poi];

    self.customAnnotation = [[BLCCustomAnnotation alloc]initWithCoordinate:_coords];
    [self.params setObject:self.customAnnotation forKey:@"annotation"];
    [self setState:BLCMapViewControllerStateMapContent animated:YES];
    [self.mapView addAnnotation:self.customAnnotation ];
    

    [self.mapView  reloadInputViews];
    
    // set the title lablel of the custom view back to its real title
    self.createAnnotationView.titleLabel.attributedText = [self titleLabelString];
    BLCCategories *category = self.params[@"category"];
    [[BLCDataSource sharedInstance] addPointOfInterest:self.poi toCategoryArray:category];
    
}

-(void)customViewDidPressAddCategoriesView:(UIView *)categoryView
{
    NSLog(@"tap being fired DELEGATE");
    self.comingFromAddAnnotationState  =YES;


    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:.75
          initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
                         
                         [self.navigationController presentViewController:self.navVC animated:NO completion:nil];
                        
                         
                         //
                     } completion:^(BOOL finished) {
                         
                         
                         
                     }];
}

#pragma mark BLCCategoriesViewControllerDelegate

-(void)controllerDidDismiss:(BLCCategoriesTableViewController *)controller
{

    [self.navVC dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)category:(BLCCategories *)categories  {
    

    [self.params setObject:categories forKey:@"category"];
    self.pinColor = [[UIColor alloc]init];
    self.pinColor = categories.color;
    self.createAnnotationView.titleLabel.attributedText = [self.createAnnotationView titleLabelStringWithCategory:categories.categoryName withColor:categories.color];

}

-(void)didCompleteWithImageView:(UIImageView *)image {
    self.heartImageView = [[UIImageView alloc]init];
    _heartImageView.image = image.image;
    

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


-(void) createAnnotation: (UILongPressGestureRecognizer *)sender
{
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self setState:BLCMapViewControllerStateAddPoi animated:YES];
    
        self.point = [sender locationInView:self.mapView];
        self.coords = [self.mapView convertPoint:self.point toCoordinateFromView:self.mapView];

//        self.customAnnotation = [[BLCCustomAnnotation alloc]initWithCoordinate:_coords ];
//        [self.params setObject:self.customAnnotation forKey:@"annotation"];
        
    }
}

#pragma mark UITabBar button actions

-(void)searchButtonPressed:(id)sender
{
    
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
-(void)listViewPressed:(id)sender
{
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
-(void)filterButtonPressed:(id)sender
{


    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:.75
          initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
                         [self.navVC.navigationItem.leftBarButtonItem setEnabled:NO];
                    [_popover presentPopoverFromBarButtonItem:self.filterButton
                                    permittedArrowDirections:WYPopoverArrowDirectionDown
                                                    animated:NO];
                         
//
                     } completion:^(BOOL finished) {
                         
                         
                         
                     }];
}
-(void)popupBarButtonItemDonePressed:(id)sender
{
    [self.popover dismissPopoverAnimated:YES];
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


-(UIImageView *)returnImageColored
{
    UIImage *image = [UIImage imageNamed:@"heart"];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imageView setTintColor:[UIColor yellowColor]];
    return imageView;
    
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{

    if(annotation != mapView.userLocation && [annotation isKindOfClass:[BLCCustomAnnotation class]])

    {
        //static NSString *defaultPinID = @"com.invasivecode.pin";
//        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:viewId];
        
        _annotationView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:viewId];
        _annotationView.canShowCallout = NO;
        _annotationView.image = _heartImageView.image;
//        [_annotationView setTintColor:[UIColor redColor]];
        _annotationView.annotation = self.customAnnotation;

//        _annotationView.tintColor = [UIColor yellowColor];
//        _annotationView.backgroundColor = [UIColor clearColor];
        [_annotationView addSubview:[self returnImageColored]];
        _annotationView.image = [self returnImageColored].image;
        }
//        [pinView setTintColor:_customAnnotation.backgroundColor];
    
    else {
        [mapView.userLocation setTitle:@"I am here"];
    }
    return _annotationView;
    
    
}


-(void)mapViewWillStartRenderingMap:(MKMapView *)mapView
{
    _mapView = mapView;
  //  NSMutableArray *tempArray = [NSMutableArray array];
    
        for (BLCPointOfInterest *poi in [BLCDataSource sharedInstance].annotations)
        {
//                [self.pinView setTintColor:poi.category.color];
                
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(poi.customAnnotation.latitude, poi.customAnnotation.longitude);
            BLCCustomAnnotation *annotation = [[BLCCustomAnnotation alloc]initWithCoordinate:coord];
//                UIImageView *tempImageView = [[UIImageView alloc]init];
//            tempImageView.image = [tempImageView.image imageWithRenderingMode:  UIImageRenderingModeAlwaysTemplate];
//                
//            [tempImageView setTintColor:poi.category.color];
           // [tempArray addObject:poi.customAnnotation];
//                MKAnnotationView *view = [MKAnnotationView]
            _annotationView = [[MKAnnotationView alloc]
                               initWithAnnotation:annotation reuseIdentifier:viewId];
 
            [_annotationView setTintColor:poi.category.color];
                [mapView addAnnotation:annotation];
            
            

        }
    
       // [mapView addAnnotations:tempArray];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //TO DO - Method to implement the view of the custom annotationView

    
    

}

#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    [self fetchVenuesForLocation:location];
    [self zoomToLocation:location radius:2000];
    [self.locationManager stopUpdatingLocation];

}




@end
