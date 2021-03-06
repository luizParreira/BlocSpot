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
        self.latitude = self.coordinate.latitude;
        self.longitude = self.coordinate.longitude;
        
    }
    return self;
}


-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.latitude = [aDecoder decodeFloatForKey:@"latitude"];
        self.longitude = [aDecoder decodeFloatForKey:@"longitude"];

    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:self.latitude forKey:@"latitude"];
    [aCoder encodeFloat:self.longitude forKey:@"longitude"];
    
}
@end
