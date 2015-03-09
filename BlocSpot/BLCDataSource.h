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
    NSString *_categoryPath;
    NSMutableArray *_annotations;
    NSMutableArray *_categories;
    NSMutableArray *_categoryPOI;


}

+(instancetype) sharedInstance;

@property (nonatomic, strong) NSString *path;



// To be implemented on the data regarding the list of venues
+(void)fetchPlacesWithName:(NSString *)searchTerm withLocationCoordinate:(CLLocationCoordinate2D *)coordinate completion:(BLCSearchListCompletionBlock)completionHandler;

-(NSArray *)annotations;
-(NSArray *)categories;
-(NSArray *)categoryPOI;


-(void)addPointOfInterest:(BLCPointOfInterest *)poi;
-(void)addCategory:(BLCCategories *)categories;
-(void)removeCategory:(BLCCategories *)category;
-(void)removePointOfInterest:(BLCPointOfInterest *)poi;
-(void)category:(BLCCategories *)categories addPointOfInterest:(BLCPointOfInterest *)poi;
-(void)addPointOfInterest:(BLCPointOfInterest *)poi toCategoryArray:(BLCCategories *)category;



@end
