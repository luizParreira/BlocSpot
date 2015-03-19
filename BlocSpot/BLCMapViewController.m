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
#import "BLCCustomCallOutView.h"
#import "BLCCallOutInnerView.h"

#import "BLCPoiTableViewController.h"
#import "BLCSearchViewController.h"
#import "BLCPointOfInterest.h"
#import "SMCalloutView.h"

#import "WYPopoverController.h"

#import "BLCCategoriesTableViewController.h"
#import "BLCPopUpCategoriesViewController.h"
// UI stuff
#import "FlatUIKit.h"
#import "UIPopoverController+FlatUI.h"


typedef NS_ENUM(NSInteger, BLCMapViewControllerState) {
    BLCMapViewControllerStateMapContent,
    BLCMapViewControllerStateAddPoi
};


@interface BLCMapViewController () <MKMapViewDelegate, UIViewControllerTransitioningDelegate,UISearchBarDelegate, UISearchControllerDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate, WYPopoverControllerDelegate, BLCCustomCreateAnnotationsViewDelegate, BLCCategoriesTableViewControllerDelegate, SMCalloutViewDelegate, BLCCallOutInnerViewDelegate, BLCPopUpCategoriesViewControllerDelegate, BLCPoiTableViewControllerDelegate> {
    
    BLCCustomCallOutView *_customCallOutView;
}


@property (nonatomic, strong) BLCPoiTableViewController *tablePoiVC;
@property (nonatomic, strong) BLCSearchViewController *searchVC;

@property (nonatomic, strong) BLCCategoriesTableViewController *categoryVC;
@property (nonatomic, strong) BLCPopUpCategoriesViewController *categoryVCpopup;

@property (nonatomic, strong) WYPopoverController *popover;
@property (nonatomic, strong) SMCalloutView *calloutView;

@property (nonatomic, strong) NSMutableArray *matchingItems;
@property (nonatomic, strong) UISearchController *searchController;


@property (nonatomic, strong)CLLocation *location;
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

@property (nonatomic, strong) NSMutableArray *poiTempArray;
@property (nonatomic, strong) NSMutableDictionary *categoryDic;

@property (nonatomic, assign) CGFloat currentLocationLat;
@property (nonatomic, assign) CGFloat currentLocationLong;


//@property (nonatomic, strong) CLLocationManager *locationManager;


@end
static NSString *viewId = @"HeartAnnotation";

@implementation BLCMapViewController

-(instancetype)init {
    self = [super init];
    if (self)
    {

    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];


    // set the tab bar color
    self.tablePoiVC =[[ BLCPoiTableViewController alloc]init];
    self.tablePoiVC.tableDelegate = self;
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
    
    if(!_categoryVC){
    self.categoryVC = [[BLCCategoriesTableViewController alloc]init];
        self.categoryVC.delegate = self;
        self.categoryVC.navigationItem.title = @"Add a Category";
    }
    self.navVC = [[UINavigationController alloc]initWithRootViewController:self.categoryVC];

    if(!_categoryVCpopup){
        self.categoryVCpopup = [[BLCPopUpCategoriesViewController alloc]init];
        self.categoryVCpopup.popupDelegate = self;
    }
    UINavigationController *navVCPopup =[[UINavigationController alloc]initWithRootViewController:self.categoryVCpopup];
    UIBarButtonItem *leftBarButtonPopup = [[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(popupBarButtonItemDonePressed:)];
    UIBarButtonItem *rightBarButtonPopup = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                         target:self
                                                                         action:@selector(cancelFilterCategoryPressed:)];
    
    self.categoryVCpopup.navigationItem.leftBarButtonItem = leftBarButtonPopup;
    self.categoryVCpopup.navigationItem.rightBarButtonItem = rightBarButtonPopup;

    self.categoryVCpopup.navigationItem.title = @"Filter by Category";
    
 
    if (!_popover){
    self.popover = [[WYPopoverController alloc]initWithContentViewController:navVCPopup];
    self.popover.delegate = self;
    self.popover.popoverContentSize = CGSizeMake(self.popover.contentViewController.view.frame.size.width, 44*7 + 20);
        
    }
    [self.mapView addAnnotations:[self createAnnotations]];


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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    [[BLCDataSource sharedInstance] addDictionary:[self calculateDistanceFromCurrentLoaction:self.locationManager.location.coordinate.latitude andLongitude:self.locationManager.location.coordinate.longitude]];
        NSLog(@"[BLCDataSource sharedInstance].distanceValuesDic : %@", [BLCDataSource sharedInstance].distanceValuesDic);

    });




}

- (NSMutableArray *)createAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (BLCPointOfInterest *poi in [BLCDataSource sharedInstance].annotations)
    {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(poi.customAnnotation.latitude, poi.customAnnotation.longitude);
        poi.customAnnotation = [[BLCCustomAnnotation alloc]initWithCoordinate:coord];
        [annotations addObject:poi.customAnnotation];
    }
    return annotations;
    
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
//    _labelBarButton = [[UIBarButtonItem alloc] initWithCustomView:customView];

    UIImage *listImage = [UIImage imageNamed:@"list"];
    self.listBarButtonItem = [[UIBarButtonItem alloc]initWithImage:listImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(listViewPressed:)];
    [_listBarButtonItem setTintColor:[UIColor cloudsColor]];
    self.navigationItem.leftBarButtonItem = _listBarButtonItem;
    self.navigationItem.titleView = customView;
    
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
-(void)zoomToCoordinate:(CLLocationCoordinate2D )coordinate radius:(CGFloat)radius {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, radius*2, radius*2);
    [self.mapView setRegion:region];
    
}

#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
    self.currentLocationLat = self.location.coordinate.latitude;
    self.currentLocationLong = self.location.coordinate.longitude;


    [self fetchVenuesForLocation:_location];
    [self zoomToLocation:_location radius:2000];
    [self.locationManager stopUpdatingLocation];
    NSDate* eventDate = _location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];


    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              _location.coordinate.latitude,
              _location.coordinate.longitude);
        

    }
}

// HELPER METHOD

-(NSDictionary *)calculateDistanceFromCurrentLoaction:(CGFloat )lat andLongitude:(CGFloat )longitude
{
    
    NSMutableDictionary *tempDic = [NSMutableDictionary new];
    
    for (BLCPointOfInterest *poi in [BLCDataSource sharedInstance].annotations)
    {
        CGFloat poiLatitude = poi.customAnnotation.latitude;
        CGFloat poiLongitude = poi.customAnnotation.longitude;
        NSLog(@"POI LATITUDE: %f", poiLatitude);
        NSLog(@"POI LONGITUDE: %f", poiLongitude);

        CLLocation *desiredLocation = [[CLLocation alloc] initWithLatitude:poiLatitude longitude:poiLongitude];
        NSLog(@"LOCATION LATITUDE: %f",lat);
        NSLog(@"LOCATION LONGITUDE: %f",longitude);
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:lat longitude:longitude];

        CLLocationDistance distance = [currentLocation distanceFromLocation:desiredLocation];
        
        NSLog(@"DISTANCE %f", distance);
        
        NSNumber *distanceNumber = [NSNumber numberWithFloat:distance];
        [tempDic setObject:distanceNumber forKey:poi.placeName];
    }
    NSLog(@"TEMP DIC: %@", tempDic);
    return tempDic;
}


#pragma mark Attributed String
-(NSAttributedString *)titleLabelString  {
    
    NSString *baseString = @"Create a BlocSpot";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutAttString;
    
}

#pragma mark creat TabBar buttons
-(void) createTabBarButtons {

    UIImage *filterImage=[UIImage imageNamed:@"filter"];

    
    self.filterButton = [[UIBarButtonItem alloc]initWithImage:filterImage
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(filterButtonPressed:)];
    
    [_filterButton setTintColor:[UIColor cloudsColor]];
    [_filterButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];


    [self.navigationItem setRightBarButtonItem:_filterButton];
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
    [self.locationManager stopMonitoringSignificantLocationChanges];
}


#pragma mark BLCCustomAnnotationsViewDelegate

-(void)customView:(BLCCustomCreateAnnotationsView *)view
didPressDoneButton:(FUIButton *)button
    withTitleText:(NSString *)titleText
withDescriptionText:(NSString *)descriptionText
{
    
    [self.params setObject:titleText forKey:@"placeName"];
    [self.params setObject:descriptionText forKey:@"notes"];
    [self.params setObject:self forKey:NSStringFromSelector(@selector(buttonState))];
    BLCCustomAnnotation *annotation = [[BLCCustomAnnotation alloc]initWithCoordinate:_coords];
    [self.params setObject:annotation forKey:@"annotation"];
    self.poi = [[BLCPointOfInterest alloc] initWithDictionary:self.params];
    [[BLCDataSource sharedInstance] addPoi:self.poi];
    [[BLCDataSource sharedInstance] addPoi:self.poi toCategoryArray:self.params[@"category"]];
    [self setState:BLCMapViewControllerStateMapContent animated:YES];
 
    [self.mapView addAnnotation:annotation];
    self.createAnnotationView.titleLabel.attributedText = [self titleLabelString];
    


}

-(void)customViewDidPressAddCategoriesView:(UIView *)categoryView
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:.75
          initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
                         
                         [self.navigationController presentViewController:self.navVC animated:NO completion:nil];

                     } completion:^(BOOL finished) {
                         
                         
                         
                     }];
}

#pragma mark BLCCategoriesViewControllerDelegate

-(void)controllerDidDismiss:(BLCCategoriesTableViewController *)controller
{

    [self.navVC dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)category:(BLCCategories *)categories {
    _category = categories;

    [self.params setObject:categories forKey:@"category"];

    
    self.createAnnotationView.titleLabel.attributedText = [self.createAnnotationView titleLabelStringWithCategory:categories.categoryName withColor:categories.color];
    
    [self.categoryVC dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark BLCPopUpCategoriesTableViewControllerDelegate

-(void)getSelectedCategories:(NSArray *)categories andProceed:(BOOL)proceed
{
    if (proceed)
    {
        self.catArray = [NSMutableArray new];
        self.catArray = [NSMutableArray arrayWithArray:[self filterAnnotationsFromCategories:categories]];
    }
}

-(NSMutableArray *)filterAnnotationsFromCategories:(NSArray *)categories
{
    NSMutableArray *mutArray = [NSMutableArray new];
    
    for (BLCCategories *category in categories)
    {
        
        [mutArray addObjectsFromArray:category.pointsOfInterest];
        
    }
    NSMutableArray *annotationArray =[NSMutableArray new];

    for (BLCPointOfInterest *poi in mutArray)
    {
        for (BLCPointOfInterest *dataPOI in [BLCDataSource sharedInstance].annotations)
        {
            if ([poi.placeName isEqualToString:[NSString stringWithFormat:@"%@", dataPOI.placeName]] && [poi.notes isEqualToString:[NSString stringWithFormat:@"%@", dataPOI.notes]])
            {
                BLCCustomAnnotation *annotation = [[BLCCustomAnnotation alloc]initWithCoordinate:CLLocationCoordinate2DMake(poi.customAnnotation.latitude, poi.customAnnotation.longitude)];
                
                
                BLCCustomCallOutView *view = [[BLCCustomCallOutView alloc] initWithAnnotation:annotation reuseIdentifier:@"HeartAnnotation"];
                [view setTintColor:poi.category.color];
                
                [annotationArray addObject:view];
                
                
            }
        }
        
    }
    
    
    return annotationArray;
    

}
#pragma mark BLCPoiTableViewControllerDelegate


-(void)didSelectPOI:(BLCPointOfInterest *)poi
{
    NSMutableArray *mutArray = [NSMutableArray new];

    for (BLCPointOfInterest *dataPOI in [BLCDataSource sharedInstance].annotations)
    {
    
        if ([poi.placeName isEqualToString:[NSString stringWithFormat:@"%@",dataPOI.placeName]] &&[poi.notes isEqualToString:[NSString stringWithFormat:@"%@",dataPOI.notes]])
        {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(dataPOI.customAnnotation.latitude, dataPOI.customAnnotation.longitude);
            BLCCustomAnnotation *annotation = [[BLCCustomAnnotation alloc]initWithCoordinate:coordinate];
            BLCCustomCallOutView *calloutView = [[BLCCustomCallOutView alloc]initWithAnnotation:annotation reuseIdentifier:viewId];
            [mutArray addObject:calloutView];
        }


    }

    [self.mapView showAnnotations:mutArray animated:YES];

}

#pragma mark tap gesture recognizer

-(void)tapFired:(UITapGestureRecognizer *)sender
{

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

-(void)popupBarButtonItemDonePressed:(id)sender
{
    if (self.catArray)
    {
        [self.mapView showAnnotations:self.catArray animated:YES];
        [self.popover dismissPopoverAnimated:YES];
        [self.catArray removeAllObjects];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];

    }
}
-(void)cancelFilterCategoryPressed:(id)sender
{
    [self.popover dismissPopoverAnimated:YES];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];


}
-(void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController
{
    [self.navigationItem.leftBarButtonItem setEnabled:YES];

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
    [self.navigationController pushViewController:self.tablePoiVC animated:YES];

}
-(void)filterButtonPressed:(id)sender
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:.75
          initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
                    [self.navigationItem.leftBarButtonItem setEnabled:NO];
                    [self.popover presentPopoverFromBarButtonItem:self.filterButton
                                    permittedArrowDirections:WYPopoverArrowDirectionDown
                                                    animated:NO];
                         
                     } completion:^(BOOL finished) {
                         
                         
                         
                     }];
}






#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    [mapView.userLocation setTitle:@"I am here"];
    
    BLCCustomCallOutView *annotationView  = (BLCCustomCallOutView *)[mapView dequeueReusableAnnotationViewWithIdentifier:viewId];

    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if([annotation isKindOfClass:[BLCCustomAnnotation class]])

    {
        if (!annotationView){
        annotationView = [[BLCCustomCallOutView alloc]
                           initWithAnnotation:annotation reuseIdentifier:viewId];
        }else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        [annotationView setTintColor:_category.color];
        annotationView.canShowCallout = NO;

        [annotationView addSubview:[self returnImageColored]];
 
    
    }
    return annotationView;
}


-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views   {
     for (MKAnnotationView *view in views)
    {
         id <MKAnnotation> annotation = [view annotation];
        for (BLCPointOfInterest *poi in [BLCDataSource sharedInstance].annotations)
        {
            if (poi.customAnnotation == annotation){
                [view setTintColor:poi.category.color];
            }
        }
    }

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"ViewWidth %f", CGRectGetWidth(self.view.bounds));

    mapView.scrollEnabled =NO;

    for (BLCPointOfInterest *poi in [BLCDataSource sharedInstance].annotations)
    {
        if (poi.customAnnotation == view.annotation){
            BLCCallOutInnerView *innerView = [[BLCCallOutInnerView alloc]init];
            innerView.delegate = self;
            innerView.poi  = poi;
            //            innerView.visitIndicatorButton.vistButtonState = poi.buttonState;
            innerView.frame = CGRectMake(0, 0, 280, 188);
            self.calloutView = [[SMCalloutView alloc]init];
            self.calloutView.contentView =innerView; ;
            
            
            NSLog(@"poi.buttonState coming from the database %i", poi.buttonState);
            
            [self.calloutView presentCalloutFromRect:view.frame inView:mapView constrainedToView:mapView permittedArrowDirections:SMCalloutArrowDirectionAny animated:YES];
        }


    
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    mapView.scrollEnabled = YES;
    [self.calloutView dismissCalloutAnimated:YES];
    
}



// helper function
-(UIImageView *)returnImageColored
{
    UIImageView *imageView = [UIImageView new];
    UIImage *image = [UIImage imageNamed:@"heart"];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.image = image;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    return imageView;
    
}




#pragma mark BLCCallOutInnerViewDelegate

-(void)calloutView:(BLCCallOutInnerView *)view didPressVisitedButton:(BLCCategoryButton *)button 
{
    if (view.visitIndicatorButton.vistButtonState == BLCVisitButtonSelectedYES)
    {
        [[BLCDataSource sharedInstance] toggleVisitedOnPOI:view.poi];
        
        view.visitIndicatorButton.vistButtonState = BLCVisitButtonSelectedNO;
    } else
    {
        [[BLCDataSource sharedInstance] toggleVisitedOnPOI:view.poi];
        view.visitIndicatorButton.vistButtonState = BLCVisitButtonSelectedYES;
    }
    
}

-(void)calloutViewdidPressDeleteButton:(BLCCallOutInnerView *)view
{
    [[BLCDataSource sharedInstance] deletePointOfInterest:view.poi];
    [self.mapView removeAnnotation:view.poi.customAnnotation];
    [self.calloutView dismissCalloutAnimated:YES];

}
-(void)calloutViewdidPressShareButton:(BLCCallOutInnerView *)view
{
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[view.poi.placeName, view.poi.notes, view.poi.customAnnotation] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}


-(void)calloutViewdidPressMapDirectionsButton:(BLCCallOutInnerView *)view
{

    
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(view.poi.customAnnotation.latitude,view.poi.customAnnotation.longitude);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:view.poi.placeName];
        
        // Set the directions mode to "Driving"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }

}



@end
