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


typedef void (^BLCSearchListCompletionBlock)(NSArray *places, NSError *error);
@interface BLCDataSource : NSObject

+(instancetype) sharedInstance;

@property (nonatomic, strong) NSMutableArray *annotations;

// To be implemented on the data regarding the list of venues
+(void)fetchPlacesWithName:(NSString *)searchTerm withLocationCoordinate:(CLLocationCoordinate2D *)coordinate completion:(BLCSearchListCompletionBlock)completionHandler;


-(void)createAnnotations;

@end
