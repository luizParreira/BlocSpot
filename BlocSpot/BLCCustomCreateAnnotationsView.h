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
#import "TLTagsControl.h"
#import "BLCCategories.h"
#import "BLCPointOfInterest.h"



@class BLCCustomCreateAnnotationsView ;
@protocol BLCCustomCreateAnnotationsViewDelegate <NSObject>

-(void) customView:(BLCCustomCreateAnnotationsView *)view didPressDoneButton:(FUIButton *)button withTitleText:(NSString *)titleText withDescriptionText:(NSString *)descriptionText withTag:(NSString *)tag;

@end

@interface BLCCustomCreateAnnotationsView : UIView

@property (nonatomic, strong) id <BLCCustomCreateAnnotationsViewDelegate> delegate;

@property (nonatomic, strong) BLCPointOfInterest *POI;

@property (nonatomic, strong) UIView *tagView;

@property (nonatomic, strong) NSMutableArray *colorsArray;
@property (nonatomic, strong) UIButton *colorChosen;
//@property (nonatomic, strong) FUITextField *tagNameTextField;

@property (nonatomic, strong) FUIButton *doneButton;
@property (nonatomic, strong) BLCCategories *category;
@property (nonatomic, strong) TLTagsControl *tagsControl;


@end
