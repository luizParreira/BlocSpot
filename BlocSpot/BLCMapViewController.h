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

@interface BLCMapViewController : UIViewController <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;


@end
