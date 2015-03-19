//
//  BLCCategoryButton.m
//  BlocSpot
//
//  Created by luiz parreira on 3/14/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCCategoryButton.h"
@interface BLCCategoryButton ()


@property (nonatomic, strong) NSString *imageName;
//@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation BLCCategoryButton
- (instancetype) init {
    self = [super init];
    
    if (self) {

//        [self addSubview:self.alreadyVisitedImageView];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        self.vistButtonState = BLCVisitButtonSelectedNO;

    }
    
    return self;
}



-(void)setVistButtonState:(BLCVisitButtonSelected)vistButtonState {
    _vistButtonState = vistButtonState;
    NSString *imageName;
    switch (_vistButtonState) {
        case BLCVisitButtonSelectedNO:
//            [self.imageView removeFromSuperview];
            imageName = @"heart";

            break;
        case BLCVisitButtonSelectedYES:
            imageName = @"heart_outlined";
            

    }
    [self setImage:[self returnImageColoredWithName:imageName].image forState:UIControlStateNormal];


    
}


// HELPER FUNCTION
-(UIImageView *)returnImageColoredWithName:(NSString *)name
{
    UIImageView *imageView = [UIImageView new];
    UIImage *image = [UIImage imageNamed:name];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width-10, self.frame.size.height-10);
    imageView.image = image;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return imageView;
    
}


@end
