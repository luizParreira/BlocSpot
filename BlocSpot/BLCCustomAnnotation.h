//
//  BLCCustomAnnotationView.h
//  BlocSpot
//
//  Created by luiz parreira on 2/26/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BLCCustomCreateAnnotationsView.h"
#import "BLCPointOfInterest.h"



@interface BLCCustomAnnotation : NSObject <MKAnnotation>
    
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;



@end
