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
    NSString *_path;
    NSMutableArray *_annotations;


}

+(instancetype) sharedInstance;

@property (nonatomic, strong) NSString *path;

@property (nonatomic, strong) BLCPointOfInterest *pointOfInterest;


// To be implemented on the data regarding the list of venues
+(void)fetchPlacesWithName:(NSString *)searchTerm withLocationCoordinate:(CLLocationCoordinate2D *)coordinate completion:(BLCSearchListCompletionBlock)completionHandler;

-(NSArray *)annotations;
-(void)addPointOfInterest:(BLCPointOfInterest *)poi;

-(void) saveItemToDisk;


@end
