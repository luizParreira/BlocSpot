//
//  BLCPointOfInterest.h
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, PAPointOfInterestVisitedState) {
    PAPointOfInterestDidNotVisit  = 0,
    PAPointOfInterestDidVisit     = 1,
};

@interface BLCPointOfInterest : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableArray *categoriesList;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *notes;


@property (nonatomic, assign) PAPointOfInterestVisitedState visitState;




@end
