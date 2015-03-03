//
//  BLCCategories.m
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCCategories.h"

@implementation BLCCategories


-(instancetype)initWithDictionary:(NSDictionary *)categoryDictionary{
    if (self){
        
        self.categoryName = categoryDictionary[@"categoryName"];
        self.color = categoryDictionary[@"categoryColor"];
    }
    
    return self;
}

@end
