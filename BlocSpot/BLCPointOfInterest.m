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
        //self.category = pointDictionary[@"category"];
        self.customAnnotation = pointDictionary[@"annotation"];
        
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
        //self.category = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(category))];
        self.customAnnotation = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(customAnnotation))];
    
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.placeName forKey:NSStringFromSelector(@selector(placeName))];
    [aCoder encodeObject:self.notes forKey:NSStringFromSelector(@selector(notes))];
    //[aCoder encodeObject:self.category forKey:NSStringFromSelector(@selector(category))];
    [aCoder encodeObject:self.customAnnotation forKey:NSStringFromSelector(@selector(customAnnotation))];
}

@end
