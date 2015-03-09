//
//  BLCColorsCollectionCell.m
//  BlocSpot
//
//  Created by luiz parreira on 3/4/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCColorsCollectionCell.h"



@implementation BLCColorsCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // initializing the image
        self.colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.specifiedSize, self.specifiedSize)];
        self.colorViewWithImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.specifiedSize, self.specifiedSize)];
        self.colorViewWithImage.layer.cornerRadius = 6.0f;
        self.colorViewWithImage.contentMode = UIViewContentModeScaleAspectFill;
        self.colorViewWithImage.clipsToBounds = YES;

        self.colorView.layer.cornerRadius = 6.0f;
        self.colorView.contentMode = UIViewContentModeScaleAspectFill;
        self.colorView.clipsToBounds = YES;
        
        self.checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.specifiedSize - 8, self.specifiedSize -8)];
        self.checkImageView.image = [UIImage imageNamed:@"done"];
        self.checkImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.checkImageView.image = [_checkImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.checkImageView setTintColor:[UIColor cloudsColor]];

        [self.contentView addSubview:self.colorView];
        [self.contentView addSubview:self.colorViewWithImage];
        [self.colorView addSubview:self.checkImageView];


    }
    return self;
    
}




-(void) setSpecifiedSize:(CGFloat)specifiedSize {
    
    self.colorView.frame = CGRectMake(0, 0, specifiedSize, specifiedSize);
    self.colorViewWithImage.frame = CGRectMake(0, 0, specifiedSize, specifiedSize);
    self.checkImageView.frame = CGRectMake(0, 0, specifiedSize-8, specifiedSize-8);

}




- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Change your UI
    if(selected){
        [self.colorView addSubview:self.checkImageView];

    }
}

@end
