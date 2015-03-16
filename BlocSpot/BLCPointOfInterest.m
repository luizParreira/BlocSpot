//
//  BLCPointOfInterest.m
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCPointOfInterest.h"

@implementation BLCPointOfInterest


-(instancetype) initWithDictionary:(NSDictionary *)pointDictionary {
    self = [super init];
    if (self) {
        // Use this space to parse the point data by using a dictionary
        
        self.placeName = pointDictionary[@"placeName"];
        self.notes = pointDictionary[@"notes"];
        self.category = pointDictionary[@"category"];
        self.customAnnotation = pointDictionary[@"annotation"];
//        self.categoriesCreatedArray = pointDictionary[@"categoriesCreatedArray"];
//        self.visited = pointDictionary[@"visited"];
//        self.userHasVisited = [pointDictionary[@"user_has_visited"] boolValue];
        self.buttonState = self.userHasVisited ? BLCVisitButtonSelectedYES : BLCVisitButtonSelectedNO;
        NSLog(@"pointDictionary =%@", pointDictionary);
        
    }
    return self;
    
}

#pragma mark NSCoding


-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.placeName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(placeName))];
        self.notes = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(notes))];
        self.category = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(category))];
        self.customAnnotation = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(customAnnotation))];
        self.visited = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(visited))];
//        self.userHasVisited = [aDecoder decodeBoolForKey:@"user_has_visited"];
        self.buttonState = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(buttonState))];
//        self.categoriesCreatedArray = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(categoriesCreatedArray))];
    
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.placeName forKey:NSStringFromSelector(@selector(placeName))];
    [aCoder encodeObject:self.notes forKey:NSStringFromSelector(@selector(notes))];
    [aCoder encodeObject:self.category forKey:NSStringFromSelector(@selector(category))];
    [aCoder encodeObject:self.customAnnotation forKey:NSStringFromSelector(@selector(customAnnotation))];
//    [aCoder encodeObject:self.visited forKey:NSStringFromSelector(@selector(visited))];
//    [aCoder encodeBool:self.userHasVisited forKey:@"user_has_visited"];
    [aCoder encodeInteger:self.buttonState forKey:NSStringFromSelector(@selector(buttonState))];

//    [aCoder encodeObject:self.categoriesCreatedArray forKey:NSStringFromSelector(@selector(categoriesCreatedArray))];
}

@end
