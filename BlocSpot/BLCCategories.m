//
//  BLCCategories.m
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCCategories.h"

@implementation BLCCategories


-(instancetype)initWithName:(NSString *)categoryName withColor:(UIColor *)color {
    if (self){
        
        self.categoryName = categoryName;
        self.color = color;
    }
    
    return self;
}

@end
