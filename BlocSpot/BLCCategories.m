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
//        self.isSelected = categoryDictionary[@"selected"];
        self.pointsOfInterest = categoryDictionary[@"pointsOfInterest"];
        self.categoryImage = categoryDictionary[@"categoryImage"];
//        self.categoryDictionaryAccessor = categoryDictionary;
    }
    
    return self;
}



#pragma mark NSCoding


-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.categoryName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(categoryName))];
         self.color = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(color))];
        self.pointsOfInterest = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(pointsOfInterest))];
        self.categoryImage = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(categoryImage))];

    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.categoryName forKey:NSStringFromSelector(@selector(categoryName))];
    [aCoder encodeObject:self.color forKey:NSStringFromSelector(@selector(color))];
    [aCoder encodeObject:self.pointsOfInterest forKey:NSStringFromSelector(@selector(pointsOfInterest))];
    [aCoder encodeObject:self.categoryImage forKey:NSStringFromSelector(@selector(categoryImage))];

    
 }


@end
