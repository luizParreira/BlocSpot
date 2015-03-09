//
//  BLCCategoryTaleViewCell.h
//  BlocSpot
//
//  Created by luiz parreira on 3/3/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BLCCategories.h"

typedef NS_ENUM(NSInteger, BLCCategoryTaleViewCellState) {
    BLCCategoryTaleViewCellStateSelectedYES,
    BLCCategoryTaleViewCellStateUnSelectedNOT
};
@class BLCCategoryTaleViewCell;
@protocol BLCCategoryTaleViewCellDelegate <NSObject>

-(void)didSelectCellWithView:(UIView *)contentView;


@end
@interface BLCCategoryTaleViewCell : UITableViewCell

@property (nonatomic, assign) id<BLCCategoryTaleViewCellDelegate> delegate;

@property (nonatomic, assign) BLCCategoryTaleViewCellState state;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UIImageView *tagImageViewFull;

@property (nonatomic, strong)BLCCategories *category;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, assign) BOOL isSelected;




@end
