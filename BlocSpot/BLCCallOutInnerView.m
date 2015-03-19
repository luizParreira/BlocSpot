//
//  BLCCallOutInnerView.m
//  BlocSpot
//
//  Created by luiz parreira on 3/13/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCCallOutInnerView.h"
#import "FlatUIKit.h"

@interface BLCCallOutInnerView ()


@property (nonatomic, strong) UIView *backButtonsView;
@property (nonatomic, strong) UIButton *mapDirections;
@property (nonatomic, strong) UIButton *share;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *lineDivide;

@end
@implementation BLCCallOutInnerView


-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        //        self.buttonState = poi.buttonState;
//        self.frame = CGRectMake(0, 0, 300, 80);
        self.topView = [UIView new];
//        self.topView.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor cloudsColor];
        [self addSubview:self.topView];
        
        
        self.lineDivide = [UIView new];
        self.lineDivide.backgroundColor = [UIColor silverColor];
//        self.lineDivide.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.lineDivide];
        
        
        
        
        self.visitIndicatorButton =[[BLCCategoryButton alloc]init];
//        [self.visitIndicatorButton setImage:self.visitIndicatorImage.image forState:UIControlStateNormal];
        [self.visitIndicatorButton addTarget:self action:@selector(visitIndicatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:self.visitIndicatorButton];
//        self.visitIndicatorButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        // start with the labels - > the background UIView - > then the UIButtons
        self.titleLabel = [UILabel new];
        self.titleLabel.numberOfLines = 0;
//        self.titleLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self.topView addSubview:self.titleLabel];
        
        self.descriptionLabel = [UILabel new];
        self.descriptionLabel.numberOfLines = 0;
//        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.descriptionLabel];
        
        
        self.categoryLabel = [UILabel new];
        self.categoryLabel.numberOfLines = 0;
//        self.categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.categoryLabel.layer.cornerRadius = 3;
        self.categoryLabel.layer.borderWidth = 2;
        [self addSubview:self.categoryLabel];
        
        
        
        self.backButtonsView = [UIView new];
//        self.backButtonsView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.backButtonsView];
        
        // CREATE 3 buttons and add them as subview of backButtonsView
        // 1- MAP DIRECTIONS
        self.mapDirections =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.mapDirections setImage:[self returnImageColoredWithName:@"navigation_arrow"].image forState:UIControlStateNormal];
        [self.mapDirections addTarget:self action:@selector(mapDirectionsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButtonsView addSubview:self.mapDirections];
//        self.mapDirections.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
        // 2- SHARE
        self.share =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.share setImage:[self returnImageColoredWithName:@"share"].image  forState:UIControlStateNormal];
        [self.share addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButtonsView addSubview:self.share];
//        self.share.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
        // 3- DELETE BUTTON
        self.deleteButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[self returnImageColoredWithName:@"delete_bin"].image forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButtonsView addSubview:self.deleteButton];
//        self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        
//        [self createConstraints];
        [self layoutIfNeeded];
        
        
        
    }
    return self;
}

-(UIImageView *)returnImageColoredWithName:(NSString *)name
{
    UIImageView *imageView = [UIImageView new];
    UIImage *image = [UIImage imageNamed:name];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width-10, self.frame.size.height-10);
    imageView.image = image;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return imageView;
    
}


#pragma mark NSAttributedStrings
- (NSAttributedString *)categoryLabelAttributedString{
    NSString *aString = [NSString stringWithFormat:@"  %@  ", self.poi.category.categoryName];
    
    NSString *baseString = NSLocalizedString([aString uppercaseString], @"Label of category");
    NSRange range = [baseString rangeOfString:baseString];
    if (baseString) {
    NSMutableAttributedString *baseAttributedString = [[NSMutableAttributedString alloc] initWithString:baseString];
    UIColor *color = [UIColor new];
    color = self.poi.category.color;
    [baseAttributedString addAttribute:NSFontAttributeName value:[UIFont boldFlatFontOfSize:16] range:range];
    [baseAttributedString addAttribute:NSKernAttributeName value:@1.3 range:range];
    [baseAttributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return baseAttributedString;
    }return nil;
    
    
}

-(NSAttributedString *)calloutTtitleString {
    NSString *aString = [NSString stringWithFormat:@"%@", self.poi.placeName];
    UIColor *color = [UIColor new];
    color = self.poi.category.color;
    if (aString){
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:aString attributes:@{NSForegroundColorAttributeName:color ,NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutAttString;
    } return nil;
    
}

-(NSAttributedString *)descriptionString  {
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    NSString *aString = [NSString stringWithFormat:@"%@", self.poi.notes];

    if (aString) {
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:aString
                                                                                     attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont flatFontOfSize:16],NSParagraphStyleAttributeName : mutableParagraphStyle}];
    
    return mutAttString;
    } return nil;
}


-(void)setPoi:(BLCPointOfInterest *)poi
{
    _poi = poi;
    _visitIndicatorButton.vistButtonState = _poi.buttonState;
    self.titleLabel.attributedText = [self calloutTtitleString];
    self.descriptionLabel.attributedText = [self descriptionString];
    self.categoryLabel.attributedText = [self categoryLabelAttributedString];
    [self.visitIndicatorButton setTintColor:poi.category.color];
    [self.mapDirections setTintColor:poi.category.color];
    [self.share setTintColor:poi.category.color];
    [self.deleteButton setTintColor:poi.category.color];
    self.categoryLabel.layer.borderColor = poi.category.color.CGColor;


}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10;
    CGFloat width = CGRectGetWidth(self.bounds);
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:maxSize];
    CGSize categoryLabelMaxSize = [self.categoryLabel sizeThatFits:maxSize];
    
    CGFloat topHeight = 44;
    self.topView.frame = CGRectMake(0, 0, width, topHeight);
    
    
    self.titleLabel.frame = CGRectMake(padding, topHeight/2 - titleLabelSize.height/2, titleLabelSize.width, titleLabelSize.height);
    self.visitIndicatorButton.frame = CGRectMake(width - topHeight, CGRectGetMinY(self.titleLabel.frame) - 10 , 44, 44);

    
    self.lineDivide.frame = CGRectMake(padding, CGRectGetMaxY(self.topView.frame), width - padding*2, 0.5);
    
    self.descriptionLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.lineDivide.frame), width - padding*2, 88);
    
    self.categoryLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.descriptionLabel.frame) + padding, categoryLabelMaxSize.width, categoryLabelMaxSize.height);
    
    
    CGFloat buttonSize = 30;
    
    self.backButtonsView.frame = CGRectMake(CGRectGetMaxX(self.lineDivide.frame) - (buttonSize *3 +padding+5), CGRectGetMinY(self.categoryLabel.frame)- 5 , buttonSize *3 +padding +5, buttonSize );

    self.mapDirections.frame = CGRectMake(5, 0, buttonSize , buttonSize);
    self.share.frame = CGRectMake(CGRectGetMaxX(self.mapDirections.frame)+5, 0, buttonSize, buttonSize);
    self.deleteButton.frame = CGRectMake(CGRectGetMaxX(self.share.frame) +5, 0, buttonSize, buttonSize);
    
    
    
}

#pragma mark UIButton Actions

-(void)visitIndicatorButtonPressed:(UIButton *)sender
{
    [self.delegate calloutView:self didPressVisitedButton:self.visitIndicatorButton];
    
    
}
-(void)mapDirectionsButtonPressed:(UIButton *)sender
{
    [sender setHighlighted:YES];
    [self.delegate calloutViewdidPressMapDirectionsButton:self];
}

-(void)shareButtonPressed:(UIButton *)sender
{
    [sender setHighlighted:YES];
    
    [self.delegate calloutViewdidPressShareButton:self];


}

-(void)deleteButtonPressed:(UIButton *)sender
{
    [sender setHighlighted:YES];
    [self.delegate calloutViewdidPressDeleteButton:self];

}

@end
