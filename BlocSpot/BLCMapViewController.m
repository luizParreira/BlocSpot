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
#import "BLCCustomCallOutView.h"

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


@interface BLCMapViewController () <MKMapViewDelegate, UIViewControllerTransitioningDelegate,UISearchBarDelegate, UISearchControllerDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate, WYPopoverControllerDelegate, BLCCustomCreateAnnotationsViewDelegate, BLCCategoriesTableViewControllerDelegate  > {
    
    BLCCustomCallOutView *_customCallOutView;
}

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) BLCPoiTableViewController *tablePoiVC;
@property (nonatomic, strong) BLCSearchViewController *searchVC;

@property (nonatomic, strong) BLCCategoriesTableViewController *categoryVC;
@property (nonatomic, strong) BLCCategoriesTableViewController *categoryVCpopup;

@property (nonatomic, strong) WYPopoverController *popover;

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



@property (nonatomic, strong) NSMutableArray *annotationsArray;

@property (nonatomic, strong)UIColor *chosenColor;

@property (nonatomic, assign)BOOL isCateforyCreated;

@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) NSMutableArray *imageMutArray;

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
    
    self.category = [[BLCCategories alloc]init];
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

//
    for (BLCPointOfInterest *poi in [BLCDataSource sharedInstance].annotations){
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(poi.customAnnotation.latitude, poi.customAnnotation.longitude);
        BLCCustomAnnotation *annotation = [[BLCCustomAnnotation alloc]initWithCoordinate:coord];

        [self.mapView addAnnotation:annotation];
    }


    self.categoryImageView = [[UIImageView alloc]init];



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


#pragma mark create constraints
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

-(void)dealloc {
    self.locationManager = nil;
//    _coords = nil;
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
    BLCCustomAnnotation *annotation = [[BLCCustomAnnotation alloc]initWithCoordinate:_coords];
    [self.params setObject:annotation forKey:@"annotation"];
    
    self.poi = [[BLCPointOfInterest alloc] initWithDictionary:self.params];
    NSLog(@"SELF.POI *** %@ ***", self.poi);
    [[BLCDataSource sharedInstance] addPointOfInterest:self.poi];



    [self setState:BLCMapViewControllerStateMapContent animated:YES];
 
    [self.mapView addAnnotation:annotation];
    
    
    // set the title lablel of the custom view back to its real title
    self.createAnnotationView.titleLabel.attributedText = [self titleLabelString];
    
    [[BLCDataSource sharedInstance] addPointOfInterest:self.poi toCategoryArray:self.poi.category];


//    _chosenColor = nil;
    
}
//-(void)setChosenColor:(UIColor *)chosenColor {
//    [self setChosenColor:chosenColor];
//    self.isCateforyCreated =NO;
//    
//}
-(void)customViewDidPressAddCategoriesView:(UIView *)categoryView
{
    NSLog(@"tap being fired DELEGATE");

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


-(void)category:(BLCCategories *)categories withImageView:(UIImageView *)imageView {
    _category = categories;
    self.imageMutArray = [NSMutableArray new];
    [self.imageMutArray addObject:imageView];
    self.categoryImageView = imageView;
    [self.params setObject:categories forKey:@"category"];

    
    self.createAnnotationView.titleLabel.attributedText = [self.createAnnotationView titleLabelStringWithCategory:categories.categoryName withColor:categories.color];
//    [self reloadInputViews];

}
//+(void)load {
//    BLCMapViewController *mapVC = [[BLCMapViewController alloc]init];
//    chosenColor = mapVC.category.color;
//}

//-(void)returnColorForCategory:(BLCCategories *)category {
//    
//    if (category){
//    
//        return category.color;
//    }
//    return nil;
//    
//    
//}


-(void)getImageView:(UIImageView *)imageView
{
    
}

-(void) addImageView:(UIImageView *)imageView asSubviewOf:(MKAnnotationView *)annotationView
{
    
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



#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{

    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if([annotation isKindOfClass:[BLCCustomAnnotation class]])

    {
    
        _annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:viewId];

        _annotationView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:viewId];
        _annotationView.canShowCallout = NO;
        _annotationView.opaque = NO;
        [_annotationView addSubview:[self.imageMutArray lastObject]];
        
        
    }   else {
        [mapView.userLocation setTitle:@"I am here"];
    }
    return _annotationView;
    
}

// helper function
//-(UIImageView *)returnImageColored
//{
//    UIImageView *imageView = [UIImageView new];
//    UIImage *image = [UIImage imageNamed:@"heart"];
//    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    imageView.image = image;
//    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    
//    for (BLCCategories *category in [BLCDataSource sharedInstance].categories){
//    //    UIImage *image = [UIImage imageNamed:@"heart"];
//        if (category == _category){
//            imageView = category.categoryImage;
//            [imageView setTintColor:category.color];
//
//        }
//    }
//        
//        
//
//    
////    chosenColor = nil;
//    return imageView;
//    
//}



//
//-(void)mapViewWillStartRenderingMap:(MKMapView *)mapView {
//
//}
//-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
//{
//    [mapView addAnnotations:[self annotationsViewArray]];
//
//    
//}

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
