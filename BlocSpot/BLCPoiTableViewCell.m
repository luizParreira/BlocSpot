//
//  BLCPoiTableViewCell.m
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCPoiTableViewCell.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import "UIFont+FlatUI.h"

@interface  BLCPoiTableViewCell ()


@property (nonatomic,strong) NSLayoutConstraint *arrowImageHeight;

@property (nonatomic,strong) NSLayoutConstraint *categoryButtonHeight;
@property (nonatomic,strong) NSLayoutConstraint *categoryButtonWidth;

@property (nonatomic, strong) NSLayoutConstraint *howFarIsItWidth;


@property (nonatomic, strong) UILabel *nameOfPlace;
@property (nonatomic, strong) UILabel *notesAboutPlace;
@property (nonatomic, strong) UILabel *howFarIsIt;

@property (nonatomic, strong) UIButton *categoryButton;

// Image corresponding the arrow that makes clear that by touching the cell user will get taken to another screen
@property (nonatomic, strong) UIImageView *arrowImage;


@property (nonatomic, strong) BLCPointOfInterest *pointOfInterest;



@end


static UIFont *lightFont;
static UIFont *normalFont;
static UIFont *boldFont;
static UIColor *backgroundColor;
static UIColor *standardLetterCollors;




@implementation BLCPoiTableViewCell


+ (void) load {
    lightFont =[UIFont lightFlatFontOfSize:11];
    normalFont =[UIFont flatFontOfSize:11];
    boldFont = [UIFont boldFlatFontOfSize:11];
    //lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    //normalFont = [UIFont fontWithName:@"HelveticaNeue" size:11];
    //boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    
    backgroundColor = [UIColor cloudsColor];
    //backgroundColor = [UIColor wetAsphaltColor];
    standardLetterCollors  = [UIColor midnightBlueColor];
    //standardLetterCollors = [UIColor cloudsColor];
}

#pragma mark Initialization

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        self.contentView.backgroundColor = backgroundColor;
        [self addNameOfPlaceLabel];
        [self addNotesAboutPlaceLabel];
        [self addHowFarIsItLabel];
        [self addCategoryButton];
        [self addArrowImage];
        [self createConstraints];
        
    }
    
    return self;

}


-(void)addNameOfPlaceLabel {
    self.nameOfPlace = [UILabel new];
    self.nameOfPlace .textAlignment = NSTextAlignmentLeft;
    self.nameOfPlace .numberOfLines  =0;
    [self.contentView addSubview: self.nameOfPlace ];
    self.nameOfPlace.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.nameOfPlace.attributedText = [self placeNameString];

}

-(void)addNotesAboutPlaceLabel {
    self.notesAboutPlace = [UILabel new];
    self.notesAboutPlace .textAlignment = NSTextAlignmentLeft;
    self.notesAboutPlace .numberOfLines  =0;
    [self.contentView addSubview: self.notesAboutPlace ];
    self.notesAboutPlace.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.notesAboutPlace.attributedText = [self notesAboutPlaceString];

    
}
-(void)addHowFarIsItLabel {
    self.howFarIsIt = [UILabel new];
    self.howFarIsIt .textAlignment = NSTextAlignmentLeft;
    self.howFarIsIt .numberOfLines  =0;
    [self.contentView addSubview: self.howFarIsIt ];
    self.howFarIsIt.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.howFarIsIt.attributedText = [self howFarIsItString];

}

// Category button going to be a Model button itself
-(void)addCategoryButton {
    self.categoryButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.categoryButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    [self.categoryButton addTarget:self action:@selector(categoryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.categoryButton];
    self.categoryButton.translatesAutoresizingMaskIntoConstraints = NO;

}

-(void)addArrowImage {
    self.arrowImage = [[UIImageView alloc]init];
    
    self.arrowImage.image = [UIImage imageNamed:@"arrow-right"];
    [self.contentView addSubview:self.arrowImage];
    self.arrowImage.translatesAutoresizingMaskIntoConstraints = NO;

}

#pragma mark Attributed Strings 

-(NSAttributedString *)placeNameString {
    
    CGFloat placeNameFontSize = 18;
    
    NSString *baseString = @"Picanha Grill Sao Paulo";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName :[normalFont fontWithSize:placeNameFontSize]}];
    NSRange stringRange = [baseString rangeOfString:baseString];
    [mutAttString addAttribute:NSForegroundColorAttributeName value:standardLetterCollors range:stringRange];
    return mutAttString;
    
}


-(NSAttributedString *)notesAboutPlaceString {
    
    CGFloat notesPlaceFontSize = 15;
    
    NSString *baseString = @"pretty cool place  apparently Mr Fulano told that I should come and check out, maybe let me know when I am around";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName :[lightFont fontWithSize:notesPlaceFontSize]}];
    NSRange stringRange = [baseString rangeOfString:baseString];
    [mutAttString addAttribute:NSForegroundColorAttributeName value:standardLetterCollors range:stringRange];
    
    return mutAttString;
    
}


-(NSAttributedString *)howFarIsItString {
    CGFloat fontSize = 11;
    
    NSString *baseString = @"< 1 min.";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName :[lightFont fontWithSize:fontSize]}];
    NSRange stringRange = [baseString rangeOfString:baseString];
    [mutAttString addAttribute:NSForegroundColorAttributeName value:standardLetterCollors range:stringRange];
    
    return mutAttString;
    
}


-(void)createConstraints {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_nameOfPlace, _notesAboutPlace, _howFarIsIt, _categoryButton, _arrowImage);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_categoryButton]-[_nameOfPlace]-[_arrowImage]-|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_categoryButton]-[_notesAboutPlace]-[_arrowImage(==28)]-|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_categoryButton][_howFarIsIt]-|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_nameOfPlace][_notesAboutPlace]-|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];

    //Arrow Image Constraints
    self.arrowImageHeight = [NSLayoutConstraint constraintWithItem:_arrowImage
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:100];
    
    NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:_arrowImage
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.contentView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0];
    
    [self.contentView addConstraints:@[self.arrowImageHeight,centerConstraint]];
    
    //Category Button
    
    self.categoryButtonHeight = [NSLayoutConstraint constraintWithItem:_categoryButton
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:100];
    self.categoryButtonWidth = [NSLayoutConstraint constraintWithItem:_categoryButton
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:100];
    [self.contentView addConstraints:@[self.categoryButtonHeight, self.categoryButtonWidth]];
    
    // How far is it label Width
    self.howFarIsItWidth =[NSLayoutConstraint constraintWithItem:_howFarIsIt
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1
                                                        constant:100];
    [self.contentView addConstraint:self.howFarIsItWidth];
    
     }




-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    CGSize howFarIsItLabelSize = [self.howFarIsIt sizeThatFits:maxSize];
    
    self.arrowImageHeight.constant = 28;
    
    self.categoryButtonHeight.constant = 30;
    self.categoryButtonWidth.constant = 30;
    
    self.howFarIsItWidth.constant = howFarIsItLabelSize.width ;
}



/*
-(void)setPointOfInterest:(BLCPointOfInterest *)pointOfInterest {
    _pointOfInterest = pointOfInterest;
    self.nameOfPlace.attributedText = [self placeNameString];
    
    self.notesAboutPlace.attributedText = [self notesAboutPlaceString];
    self.howFarIsIt.attributedText = [self howFarIsItString];


}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
