//
//  BLCCategoryTaleViewCell.m
//  BlocSpot
//
//  Created by luiz parreira on 3/3/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCCategoryTaleViewCell.h"
#import "FlatUIKit.h"


@interface BLCCategoryTaleViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer* singleTapRecognizer;

@property (nonatomic, strong) NSLayoutConstraint *categoryLabelHeight;




@end
@implementation BLCCategoryTaleViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
            
            // LABEL
            self.categoryLabel = [UILabel new];
            self.categoryLabel.numberOfLines = 0;
            self.categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
            self.categoryLabel.attributedText = [self categoryLabelAttributedString];
            [self.contentView addSubview:self.categoryLabel];

            // CELL

            [self configureFlatCellWithColor:[UIColor cloudsColor]
                         selectedColor:[UIColor cloudsColor]
                       roundingCorners:UIRectCornerAllCorners];

            self.cornerRadius = 5.0f; // optional
            self.separatorHeight = 2.0f; // optional


            //TAG IMAGE
            self.tagImageView = [[UIImageView alloc]init];
            self.image = [UIImage imageNamed:@"heart_outlined"];
            self.tagImageView.image = self.image ;

            self.tagImageView.image = [_tagImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.tagImageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:_tagImageView];
        
            self.tagImageViewFull = [[UIImageView alloc]init];
            self.image1 = [UIImage imageNamed:@"heart"];
            self.tagImageViewFull.image = self.image1 ;

            self.tagImageViewFull.image = [_tagImageViewFull.image imageWithRenderingMode:  UIImageRenderingModeAlwaysTemplate];
        
            self.tagImageViewFull.translatesAutoresizingMaskIntoConstraints = NO;
        
            [self.contentView addSubview:_tagImageViewFull];
//            [self.tagImageView1 setHidden:YES];
        
            
            [self createConstraints];
        
        }

            return self;
        }

#pragma Attributed String

- (NSAttributedString *) categoryLabelAttributedString {
        NSString *categoryName = self.category.categoryName;
        NSString *baseString = NSLocalizedString([categoryName uppercaseString], @"Label of category");
        NSRange range = [baseString rangeOfString:baseString];
        
        NSMutableAttributedString *baseAttributedString = [[NSMutableAttributedString alloc] initWithString:baseString];
        
        [baseAttributedString addAttribute:NSFontAttributeName value:[UIFont boldFlatFontOfSize:16] range:range];
        [baseAttributedString addAttribute:NSKernAttributeName value:@1.3 range:range];
        [baseAttributedString addAttribute:NSForegroundColorAttributeName value:self.category.color range:range];
        return baseAttributedString;
        

}



-(void)createConstraints

{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(  _categoryLabel,_tagImageView, _tagImageViewFull);
    


    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tagImageView(==44)]|"
                                                                           options:kNilOptions
                                                                           metrics:nil
                                                                             views:viewDictionary]];
    ;
    

    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tagImageView(==44)]|"
                                                                           options:kNilOptions
                                                                           metrics:nil
                                                                             views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tagImageViewFull(==44)]|"
                                                                                 options:kNilOptions
                                                                                 metrics:nil
                                                                                   views:viewDictionary]];
        ;
        
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tagImageViewFull(==44)]|"
                                                                                 options:kNilOptions
                                                                                 metrics:nil
                                                                                   views:viewDictionary]];


    


    
    [self.contentView addConstraints:({
        @[ [NSLayoutConstraint
            constraintWithItem:_categoryLabel
            attribute:NSLayoutAttributeCenterX
            relatedBy:NSLayoutRelationEqual
            toItem:self.contentView
            attribute:NSLayoutAttributeCenterX
            multiplier:1.f constant:0.f],
           
           [NSLayoutConstraint
            constraintWithItem:_categoryLabel
            attribute:NSLayoutAttributeCenterY
            relatedBy:NSLayoutRelationEqual
            toItem:self.contentView
            attribute:NSLayoutAttributeCenterY
            multiplier:1.f constant:0] ];
    })];
}

//-(void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    
//    if (selected){
//        [self.delegate didSelectCell:self];
//        
//    }
//    
//}
-(void)setState:(BLCCategoryTaleViewCellState)state {
    [self checkState];
}


-(void)checkState
{
    switch (self.state) {
                
        case BLCCategoryTaleViewCellStateUnSelectedNOT: {
            [self.tagImageView setHidden:NO];
            [self.tagImageViewFull setHidden:YES];
        } break;
        case BLCCategoryTaleViewCellStateSelectedYES: {
            [self.tagImageView setHidden:YES];
            [self.tagImageViewFull setHidden:NO];
            
                
            } break;
        }

}

@end
