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
        
        self.placeName = pointDictionary[@"place"];
        self.notes = pointDictionary[@"description"];
        self.category = pointDictionary[@"category"];
        self.customAnnotation = pointDictionary[@"annotation"];
    }
    return self;
    
}

#pragma mark NSCoding


-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.placeName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(placeName))];
        self.notes = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(description))];
        self.category = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(category))];
        self.customAnnotation = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(annotation))];
    
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.placeName forKey:NSStringFromSelector(@selector(placeName))];
    [aCoder encodeObject:self.notes forKey:NSStringFromSelector(@selector(description))];
    [aCoder encodeObject:self.category forKey:NSStringFromSelector(@selector(category))];
    [aCoder encodeObject:self.customAnnotation forKey:NSStringFromSelector(@selector(annotation))];
}

@end
