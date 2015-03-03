//
//  BLCDataSource.m
//  BlocSpot
//
//  Created by luiz parreira on 2/23/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCDataSource.h"


@interface BLCDataSource ()



@end

@implementation BLCDataSource 



+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *documentsDirectory = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        _path = [documentsDirectory stringByAppendingPathComponent:@"point_of_interest.dat"] ;
        NSLog(@"Saving bookmarks in %@", _path);
    }
    
    return self;
}
- (void)loadPointsOfInterests {
    _annotations = [NSKeyedUnarchiver unarchiveObjectWithFile:_path];
    if (!_annotations) {
        _annotations = [NSMutableArray array];
    }
}

-(NSArray *)annotations {
    if (!_annotations) {
        [self loadPointsOfInterests];
    }
    return _annotations;
}

-(void)addPointOfInterest:(BLCPointOfInterest *)poi {
    if (!_annotations){
        [self loadPointsOfInterests];
        NSLog(@"Adding PointOfInterest: [name: %@] [description: %@] [custom annotation : %@]", poi.placeName, poi.notes, poi.customAnnotation);
        
        [_annotations addObject:poi];
        [NSKeyedArchiver archiveRootObject:_annotations toFile:_path];
        NSLog(@"ALL ANNOTATIONS = %@",_annotations);
    }
}

@end
