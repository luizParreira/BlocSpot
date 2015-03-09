//
//  BLCColorsCollectionCell.h
//  BlocSpot
//
//  Created by luiz parreira on 3/4/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"


@interface BLCColorsCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UIView *colorViewWithImage;

@property (nonatomic, strong) UIImageView *checkImageView;

@property (nonatomic, assign) CGFloat specifiedSize;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) UIColor *backgroundColor;


- (void)setSelected:(BOOL)selected;
@end
