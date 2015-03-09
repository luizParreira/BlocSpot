//
//  BLCCustomCallOutView.m
//  BlocSpot
//
//  Created by luiz parreira on 3/8/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCCustomCallOutView.h"
#import <QuartzCore/QuartzCore.h>
#import "FlatUIKit.h"
#define  Arror_height 15

@interface BLCCustomCallOutView ()



@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *categoryLabel;

@property (nonatomic, strong) UIView *backButtonsView;
@property (nonatomic, strong) UIButton *mapDirections;
@property (nonatomic, strong) UIButton *share;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *lineDivide;
@property (nonatomic, strong) UIButton *visitIndicatorButton;



@end


@implementation BLCCustomCallOutView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 80, 200);
        // CREATE THE TOPVIEW THAT WILL HOLD THE topView view, the title label, the "visited / not visited" button
        // and a line dividing them both
        
        self.topView = [UIView new];
        self.topView.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor cloudsColor];
        [self addSubview:self.topView];
        
        
        self.lineDivide = [UIView new];
        self.lineDivide.backgroundColor = [UIColor silverColor];
        self.lineDivide.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.lineDivide];
        
        self.visitIndicatorButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.visitIndicatorButton setImage:[UIImage imageNamed:@"heart_full"] forState:UIControlStateNormal];
        [self.visitIndicatorButton addTarget:self action:@selector(visitIndicatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.visitIndicatorButton];
        self.visitIndicatorButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        // start with the labels - > the background UIView - > then the UIButtons
        self.descriptionLabel = [UILabel new];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.descriptionLabel];
        
        
        self.categoryLabel = [UILabel new];
        self.categoryLabel.numberOfLines = 0;
        self.categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.categoryLabel];
        
        

        self.backButtonsView = [UIView new];
        self.backButtonsView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.backButtonsView];
        
        // CREATE 3 buttons and add them as subview of backButtonsView
        // 1- MAP DIRECTIONS
        self.mapDirections =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.mapDirections setImage:[UIImage imageNamed:@"directions_arrow"] forState:UIControlStateNormal];
        [self.mapDirections addTarget:self action:@selector(mapDirectionsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButtonsView addSubview:self.mapDirections];
        self.mapDirections.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
        // 2- SHARE
        self.share =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.mapDirections setImage:[UIImage imageNamed:@"directions_arrow"] forState:UIControlStateNormal];
        [self.share addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButtonsView addSubview:self.share];
        self.share.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
        // 3- DELETE BUTTON
        self.deleteButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"delete_bin"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButtonsView addSubview:self.deleteButton];
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [self createConstraints];
        
    }
    return self;
}

-(void)createConstraints
{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_topView, _lineDivide, _visitIndicatorButton,_descriptionLabel, _categoryLabel, _backButtonsView, _mapDirections, _share, _deleteButton);
    
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descriptionLabel]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_categoryLabel]-[_backButtonsView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_lineDivide]-|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView(==44)][_lineDivide(==0.5)][_descriptionLabel]-[_categoryLabel]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView(==44)][_lineDivide(==0.5)][_descriptionLabel]-[_backButtonsView]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    
    [self.backButtonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_mapDirections(==44)][_share(==44)][_deleteButton(==44)]-|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self.backButtonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapDirections(==44)]"
                                                                                 options:kNilOptions
                                                                                 metrics:nil
                                                                                   views:viewDictionary]];
    [self.backButtonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_share(==44)]"
                                                                                 options:kNilOptions
                                                                                 metrics:nil
                                                                                   views:viewDictionary]];
    [self.backButtonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_deleteButton(==44)]"
                                                                                 options:kNilOptions
                                                                                 metrics:nil
                                                                                   views:viewDictionary]];
    
}
-(void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
    //    CGContextSetLineWidth(context, 1.0);
    //     CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    //    [self getDrawPath:context];
    //    CGContextStrokePath(context);
    
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    // midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    //  self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

@end
