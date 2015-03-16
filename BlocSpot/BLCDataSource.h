//
//  BLCDataSource.h
//  BlocSpot
//
//  Created by luiz parreira on 2/23/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BLCPointOfInterest.h"


typedef void (^BLCSearchListCompletionBlock)(NSArray *places, NSError *error);

@interface BLCDataSource : NSObject {
    NSString *_annotationsPath;
    NSString *_categoriesPath;
}

+(instancetype) sharedInstance;


@property (nonatomic, weak, readonly) NSArray *annotations;
@property (nonatomic, weak, readonly) NSArray *categories;



// To be implemented on the data regarding the list of venues
+(void)fetchPlacesWithName:(NSString *)searchTerm withLocationCoordinate:(CLLocationCoordinate2D *)coordinate completion:(BLCSearchListCompletionBlock)completionHandler;


// KVO METHODS
-(void)deleteCategories:(BLCCategories *)category;
-(void)addCategories:(BLCCategories *)category;

-(void)addPoi:(BLCPointOfInterest *)poi;
-(void) deletePointOfInterest:(BLCPointOfInterest *)poi;
-(void)replaceAnnotation:(BLCPointOfInterest *)poi withOtherPOI:(BLCPointOfInterest *)otherPOI;

-(void)toggleVisitedOnPOI:(BLCPointOfInterest *)poi;


@end
