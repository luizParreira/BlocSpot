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



@interface BLCCustomAnnotation : NSObject <MKAnnotation, NSCoding>
    
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
//@property (nonatomic, strong) UIColor *backgroundColor;


- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate ;

-(id)initWithArray:(NSArray *)array;


@end
