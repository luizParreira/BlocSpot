//
//  BLCCustomCallOutAnnotation.h
//  BlocSpot
//
//  Created by luiz parreira on 3/13/15.
//  Copyright (c) 2015 LP. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BLCCustomCallOutAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;


- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
