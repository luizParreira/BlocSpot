//
//  BLCCustomCreateAnnotationsView.m
//  BlocSpot
//
//  Created by luiz parreira on 2/26/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCCustomCreateAnnotationsView.h"


@interface BLCCustomCreateAnnotationsView () <UITextFieldDelegate, UITextViewDelegate, BLCCustomCreateAnnotationsViewDelegate>

@property (nonatomic, strong) NSLayoutConstraint *tagsControlWidth;
@end

@implementation BLCCustomCreateAnnotationsView


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAllObjects];
        [self creatingTextField];
        [self createTextView];
        [self creadeDoneButton];
        [self addingSubviews];
        [self createConstraints];

    }
    return self;
}

-(void)initializeAllObjects {
    self.titleField = [FUITextField new];
    self.descriptionTextView = [UITextView new];
    
    NSMutableArray *colorsArray = [NSMutableArray arrayWithObjects:[UIColor turquoiseColor],
                                   [UIColor emerlandColor],
                                   [UIColor  peterRiverColor],
                                   [UIColor amethystColor],
                                   [UIColor sunflowerColor],
                                   [UIColor carrotColor],
                                   [UIColor alizarinColor],
                                   [UIColor concreteColor], nil];
    
    self.tagView = [UIView new];
    self.tagsControl = [[TLTagsControl alloc]init];
    self.tagsControl.mode = TLTagsControlModeEdit;
    self.doneButton = [FUIButton buttonWithType:UIButtonTypeCustom];

    
}
-(void)creatingTextField {
    self.titleField.font = [UIFont flatFontOfSize:16];
    self.titleField.backgroundColor = [UIColor clearColor];
    self.titleField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.titleField.textFieldColor = [UIColor whiteColor];
    self.titleField.borderColor = [UIColor turquoiseColor];
    self.titleField.borderWidth = 2.0f;
   // self.titleField.cornerRadius = 3.0f;
    
    
    
}

-(void)createTextView  {
    
    self.descriptionTextView.delegate = self;
    //self.descriptionTextView.layer.cornerRadius = 3;
    //self.descriptionTextView.layer.borderWidth = 1;
    self.descriptionTextView.layer.borderColor = [UIColor colorWithRed:0.427 green:0.034 blue:0.010 alpha:1.000].CGColor;
    [self.descriptionTextView setFont:[UIFont flatFontOfSize:14]];
}
-(void)creadeDoneButton {
    [self.doneButton setAttributedTitle:[self doneAttributedString] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.doneButton.buttonColor = [UIColor turquoiseColor];
    self.doneButton.shadowColor = [UIColor greenSeaColor];
    self.doneButton.shadowHeight = 3.0f;
    self.doneButton.cornerRadius = 6.0f;
    self.doneButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.doneButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
}


-(void)addingSubviews {
   
    [self addSubview:self.titleField];

    [self addSubview:self.descriptionTextView];
    [self addSubview:self.tagsControl];
    [self addSubview:self.doneButton];
    self.titleField.translatesAutoresizingMaskIntoConstraints = NO;

    
    self.descriptionTextView.translatesAutoresizingMaskIntoConstraints = NO;

    self.tagsControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;



}

#pragma mark Attributed Strings

-(NSAttributedString *)doneAttributedString{
    
    NSString *baseString = @"DONE";
    
    NSMutableAttributedString *muttString= [[NSMutableAttributedString alloc]initWithString:baseString];
    return muttString;
    
}

-(void)setTagsControl:(TLTagsControl *)tagsControl {
    _tagsControl = tagsControl;
    
}

-(void)createConstraints  {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleField, _descriptionTextView, _tagsControl, _doneButton);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleField]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descriptionTextView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    /*[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tagsControl]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];*/
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_doneButton]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleField(==44)][_descriptionTextView(==100)][_tagsControl(==44)]-[_doneButton(==44)]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                views:viewDictionary]];

    self.tagsControlWidth = [NSLayoutConstraint constraintWithItem:_tagsControl
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:100];
    
    [self addConstraint:self.tagsControlWidth];
    
}


-(void)layoutSubviews  {
    
    [super layoutSubviews];
    
    self.tagsControlWidth.constant = CGRectGetWidth(self.titleField.frame);
    
}
-(void)setPOI:(BLCPointOfInterest *)POI
{
    _POI = POI;
    _POI.placeName = _titleField.text;
    _POI.notes = _descriptionTextView.text;
    _POI.category = [_tagsControl.tags lastObject];
    
    
}



#pragma mark UIbutton actions

-(void)doneButtonPressed:(FUIButton *)sender {
    [self.delegate customView:self
           didPressDoneButton:self.doneButton
                withTitleText:self.titleField.text
          withDescriptionText:self.descriptionTextView.text
                      withTag:[self.tagsControl.tags lastObject]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
