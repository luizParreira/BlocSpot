//
//  BLCCategoryButton.h
//  BlocSpot
//
//  Created by luiz parreira on 3/14/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLCVisitButtonSelected) {
    BLCVisitButtonSelectedNO = 0,
    BLCVisitButtonSelectedYES = 1
};


@interface BLCCategoryButton : UIButton


@property (nonatomic, assign) BLCVisitButtonSelected vistButtonState;
@property (nonatomic, strong) UIImageView *alreadyVisitedImageView;


@end
