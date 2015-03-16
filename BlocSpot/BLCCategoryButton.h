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

/**
 The current state of the like button. Setting to BLCLikeButtonNotLiked or BLCLikeButtonLiked will display an empty heart or a heart, respectively. Setting to BLCLikeButtonLiking or BLCLikeButtonUnliking will display an activity indicator and disable button taps until the button is set to BLCLikeButtonNotLiked or BLCLikeButtonLiked.
 */
@property (nonatomic, assign) BLCVisitButtonSelected vistButtonState;
@property (nonatomic, strong) UIImageView *alreadyVisitedImageView;


@end
