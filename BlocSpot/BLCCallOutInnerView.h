//
//  BLCCallOutInnerView.h
//  BlocSpot
//
//  Created by luiz parreira on 3/13/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "BLCCustomAnnotation.h"
#import "BLCCategoryButton.h"
#import "BLCPointOfInterest.h"

@class BLCCallOutInnerView;

@protocol BLCCallOutInnerViewDelegate <NSObject>

-(void)calloutView:(BLCCallOutInnerView *)view didPressVisitedButton:(BLCCategoryButton *)button ;

@end

@interface BLCCallOutInnerView : UIView

@property (nonatomic, strong) NSObject <BLCCallOutInnerViewDelegate> *delegate;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *visitIndicatorImage;
@property (nonatomic, strong) BLCCategoryButton *visitIndicatorButton;

//@property (nonatomic, assign) BLCVisitButtonSelected *buttonState;

@property (nonatomic, strong) BLCPointOfInterest *poi;



-(void)setVisitIndicatorImage:(UIImageView *)visitIndicatorImage withColor:(UIColor *)color;
@end
