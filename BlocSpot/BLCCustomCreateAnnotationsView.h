//
//  BLCCustomCreateAnnotationsView.h
//  BlocSpot
//
//  Created by luiz parreira on 2/26/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "FlatUIKit.h"
#import "BLCCategories.h"
#import "BLCPointOfInterest.h"
#import "BLCDataSource.h"



@class BLCCustomCreateAnnotationsView, BLCCategories ;
@protocol BLCCustomCreateAnnotationsViewDelegate <NSObject>

-(void) customView:(BLCCustomCreateAnnotationsView *)view didPressDoneButton:(FUIButton *)button withTitleText:(NSString *)titleText withDescriptionText:(NSString *)descriptionText /*withCategory:(BLCCategories *)category*/;
-(void)customViewDidPressAddCategoriesView:(BLCCustomCreateAnnotationsView *)categoryView;



@end

@interface BLCCustomCreateAnnotationsView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) id <BLCCustomCreateAnnotationsViewDelegate> delegate;

@property (nonatomic, strong) BLCPointOfInterest *POI;

@property (nonatomic, strong) UIView *tagView;

@property (nonatomic, strong) NSMutableArray *colorsArray;
@property (nonatomic, strong) UIButton *colorChosen;

@property (nonatomic, strong) FUIButton *doneButton;
@property (nonatomic, strong) BLCCategories *category;
@property (nonatomic, strong) UIView *categoryView;

@property (nonatomic, strong) FUIButton *categoryButton;
@property (nonatomic, strong) UILabel *titleLabel;


-(NSAttributedString *)titleLabelStringWithCategory:(NSString *)categoryString withColor:(UIColor *)color;
@end
