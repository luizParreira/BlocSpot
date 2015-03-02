//
//  BLCCustomAnnotationView.m
//  BlocSpot
//
//  Created by luiz parreira on 2/26/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCCustomAnnotation.h"

@implementation BLCCustomAnnotation



-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
    }
    return self;
}




@end
