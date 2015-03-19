//
//  BLCPointOfInterest.h
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BLCCustomAnnotation.h"
#import "BLCCategories.h"
#import "BLCCategoryButton.h"




@interface BLCPointOfInterest : NSObject <NSCoding>

@property (nonatomic, strong) BLCCategories *category;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) BLCCustomAnnotation *customAnnotation;
@property (nonatomic, assign) BOOL userHasVisited;
@property (nonatomic, assign) BLCVisitButtonSelected buttonState;

-(instancetype) initWithDictionary:(NSDictionary *)mediaDictionary;



@end
