//
//  BLCMapViewController.h
//  BlocSpot
//
//  Created by luiz parreira on 2/23/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BLCCustomCreateAnnotationsView.h"
#import "BLCDataSource.h"



@interface BLCMapViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) BLCCustomCreateAnnotationsView *createAnnotationView;


@property (nonatomic, strong) BLCDataSource *dataSource;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong)NSMutableArray *catArray;


@property (nonatomic, assign) BOOL comingFromAddAnnotationState;
@property (nonatomic, assign) BOOL comingFromMapViewState;


@end
