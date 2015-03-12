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
        _path = [documentsDirectory stringByAppendingPathComponent:@"point_of_interest_path.dat"] ;
        _categoryPath = [documentsDirectory stringByAppendingPathComponent:@"categories_the_path.dat"];
        NSLog(@"Saving annotations in %@", _path);
        NSLog(@"Saving categories in %@", _categoryPath);

    }
    
    return self;
}
- (void)loadPointsOfInterests {
    _annotations = [NSKeyedUnarchiver unarchiveObjectWithFile:_path];
    if (!_annotations) {
        _annotations = [NSMutableArray array];
    }
}

-(void)loadCategories  {
    _categories = [NSKeyedUnarchiver unarchiveObjectWithFile:_categoryPath];
    if (!_categories){
        _categories = [NSMutableArray array];
    }
}

-(NSArray *)annotations {
    if (!_annotations) {
        [self loadPointsOfInterests];
    }
    return _annotations;
}
-(NSArray *)categories {
    if (!_categories){
        [self loadCategories];
    }
    return _categories;
    
}
// Adding objects methods
-(void)addPointOfInterest:(BLCPointOfInterest *)poi {
        [self loadPointsOfInterests];
        NSLog(@"Adding PointOfInterest: [name: %@] [description: %@] [custom annotation : %@] [category name: %@] [Category Color: %@]", poi.placeName, poi.notes, poi.customAnnotation, poi.category.categoryName, poi.category.color);
        
        [_annotations addObject:poi];
        [NSKeyedArchiver archiveRootObject:_annotations toFile:_path];
        NSLog(@"ALL ANNOTATIONS = %@",_annotations);
    
}

-(void)addCategory:(BLCCategories *)categories {
    [self loadCategories];
    NSLog(@"Adding Category:[category name: %@] [Category Color: %@]", categories.categoryName, categories.color);
    
    [_categories addObject:categories];
    [NSKeyedArchiver archiveRootObject:_categories toFile:_categoryPath];
    NSLog(@"ALL CATEGORIES BEFORE= %@",_categories);
    
}

// deleting objects methods

-(void)removePointOfInterest:(BLCPointOfInterest *)poi
{
    [self loadPointsOfInterests];
    
    [_annotations removeObject:poi];
    [NSKeyedArchiver archiveRootObject:_annotations toFile:_path];
    
}

-(void)removeCategory:(BLCCategories *)category
{
    [self loadCategories];
    
    [_categories removeObject:category];
    [NSKeyedArchiver archiveRootObject:_categories toFile:_categoryPath];
    
}

-(void)addPointOfInterest:(BLCPointOfInterest *)poi toCategoryArray:(BLCCategories *)category
{
    [category.pointsOfInterest addObject:poi];
    NSLog(@"CATEGORY.POINTSOFINTEREST *** %@ ***", category.pointsOfInterest);

    
}

@end
