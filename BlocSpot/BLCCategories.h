//
//  BLCCategories.h
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BLCCategories : NSObject <NSCoding>
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSMutableArray *pointsOfInterest;


-(instancetype)initWithDictionary:(NSDictionary *)categoryDictionary;


@end
