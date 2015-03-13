//
//  BLCCategories.h
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BLCCategoriesState) {
    BLCCategoriesUnselectedState,
    BLCCategoriesSelectedState
};
@interface BLCCategories : NSObject <NSCoding>
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, assign) BLCCategoriesState state;
@property (nonatomic, strong) NSArray *selectedCategory;
@property (nonatomic, strong) NSMutableArray *pointsOfInterest;
@property (nonatomic, strong) NSMutableArray *colorList;
@property (nonatomic, strong) UIImageView *categoryImage;

@property (nonatomic, strong) NSDictionary *categoryDictionaryAccessor;

-(instancetype)initWithDictionary:(NSDictionary *)categoryDictionary;

-(UILabel *)returnLabel;

@end
