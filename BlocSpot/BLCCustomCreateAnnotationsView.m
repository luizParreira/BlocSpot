//
//  BLCCustomCreateAnnotationsView.m
//  BlocSpot
//
//  Created by luiz parreira on 2/26/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCCustomCreateAnnotationsView.h"
#import "IQKeyboardManager.h"
#import "JVFloatLabeledTextView.h"
#import "JVFloatLabeledTextField.h"



@interface BLCCustomCreateAnnotationsView () <UITextFieldDelegate, UITextViewDelegate, BLCCustomCreateAnnotationsViewDelegate, UIGestureRecognizerDelegate >

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) NSLayoutConstraint *tagsControlWidth;

@property (nonatomic, strong) JVFloatLabeledTextField *titleField;
@property (nonatomic, strong) JVFloatLabeledTextView *descriptionTextView;
@property (nonatomic, strong) UIView *div1;
@property (nonatomic, strong) UIView *div2;
@property (nonatomic, strong) UIView *div3;

@property (nonatomic, strong) UIColor *floatingLabelColor;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSDictionary *metrics;



@property (nonatomic, strong) UIView *categoryView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *addCategoryImageView;
@property (nonatomic, strong) UILabel *addCategoryLabel;


//add a tapgesture to present the category view
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;





@end

UIColor *floatingLabelColor ;


@implementation BLCCustomCreateAnnotationsView


+(void)load {
   floatingLabelColor = [UIColor brownColor];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAllObjects];
        [self createTopView];
        [self creatingTextField];
        [self createTextView];
        [self creadeDoneButton];
        [self creatingCategoryView];
        [self createConstraints];

        IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
        keyboardManager.keyboardDistanceFromTextField = 4;
        keyboardManager.canAdjustTextView = YES;
        keyboardManager.shouldResignOnTouchOutside =YES;
    }
    return self;
}

-(void)initializeAllObjects {
    self.titleField = [[JVFloatLabeledTextField alloc]init];

    self.descriptionTextView = [[JVFloatLabeledTextView alloc]init];

    
    
    // ARRAY STORING ALL THE COLORS LATER TO BE AVAILABLE FOR THE USER 
    
//    NSMutableArray *colorsArray = [NSMutableArray arrayWithObjects:[UIColor turquoiseColor],
//                                   [UIColor emerlandColor],
//                                   [UIColor  peterRiverColor],
//                                   [UIColor amethystColor],
//                                   [UIColor sunflowerColor],
//                                   [UIColor carrotColor],
//                                   [UIColor alizarinColor],
//                                   [UIColor concreteColor], nil];
    


    self.doneButton = [FUIButton buttonWithType:UIButtonTypeCustom];
    self.topView = [UIView new];
    self.titleLabel = [UILabel new];

    self.div1 = [UIView new];
    self.div2 = [UIView new];

    self.div3 = [UIView new];

    self.categoryView = [UIView new];
    self.addCategoryImageView = [[UIImageView alloc]init];
    self.addCategoryLabel = [[UILabel alloc]init];
    self.backView = [UIView new];
    
    
}
/*
 UIImage *image =[UIImage imageNamed:@"heart"];
 UIImageView *theImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, 44, 44)];
 theImageView.image = image;4
 theImageView.image = [theImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
 [theImageView setTintColor:[UIColor redColor]];
 UIImage *doneImage =[UIImage imageNamed:@"done-white"];
 UIImageView *doneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(24, 100, 36, 36)];
 doneImageView.image = doneImage;
 [self.view addSubview:theImageView];
 [self.view addSubview:doneImageView];
 */

-(void)createTopView
{
    self.topView.backgroundColor = [UIColor cloudsColor];
    self.titleLabel.attributedText = [self titleLabelString];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.topView];
    [self addSubview:self.titleLabel];
    self.topView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)creatingTextField {
    
   
    self.titleField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"  Place Name", @"String naming Point of Interest")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    self.titleField.font =[UIFont flatFontOfSize:16];
    self.titleField.floatingLabel.font = [UIFont flatFontOfSize:11];
    self.titleField.floatingLabelTextColor = floatingLabelColor;
    self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.titleField.backgroundColor = [UIColor cloudsColor];
    [self addSubview:self.titleField];

    self.div1.backgroundColor = [UIColor silverColor];
    [self addSubview:self.div1];
    self.titleField.translatesAutoresizingMaskIntoConstraints = NO;
    self.div1.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}

-(void)creatingCategoryView{
    self.backView.backgroundColor = [UIColor clearColor];
    
    self.categoryView.backgroundColor = [UIColor cloudsColor];
    self.addCategoryImageView.image = [UIImage imageNamed:@"add"];
    self.addCategoryImageView.image = [_addCategoryImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.addCategoryImageView setTintColor:[UIColor midnightBlueColor]];
    
    self.addCategoryLabel.numberOfLines = 0;
    self.addCategoryLabel.font = [UIFont flatFontOfSize:16];
    self.addCategoryLabel.text = @"Category";
    self.addCategoryLabel.textColor = [UIColor midnightBlueColor];
    [self addSubview:self.categoryView];
    [self.categoryView addSubview:self.backView];
    [self.backView addSubview:self.addCategoryImageView];
    [self.backView addSubview:self.addCategoryLabel ];
    
    self.categoryView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backView.translatesAutoresizingMaskIntoConstraints = NO;
    self.addCategoryImageView.translatesAutoresizingMaskIntoConstraints= NO;
    self.addCategoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.div3.backgroundColor = [UIColor silverColor];
    [self addSubview:self.div3];
    self.div3.translatesAutoresizingMaskIntoConstraints =NO;
    
    
}

/*
-(void)creatingTagPlaceholder {
    self.tagField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"  Category", @"Tags of what category it belongs to")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    self.tagField.font =[UIFont flatFontOfSize:16];
    self.tagField.floatingLabel.font = [UIFont flatFontOfSize:11];
    self.tagField.floatingLabelTextColor = floatingLabelColor;
    self.tagField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tagField.backgroundColor = [UIColor cloudsColor];
    [self addSubview:self.tagField];
    self.div3.backgroundColor = [UIColor silverColor];
    [self addSubview:self.div3];
    self.tagField.translatesAutoresizingMaskIntoConstraints = NO;
    self.div3.translatesAutoresizingMaskIntoConstraints =NO;


}
 */

-(void)createTextView  {
    self.descriptionTextView = [[JVFloatLabeledTextView alloc] init];
    self.descriptionTextView.placeholder = NSLocalizedString(@"  Description", @"");
    self.descriptionTextView.placeholderTextColor = [UIColor darkGrayColor];
    self.descriptionTextView.font = [UIFont flatFontOfSize:16];
    self.descriptionTextView.floatingLabel.font = [UIFont flatFontOfSize:11];
    self.descriptionTextView.floatingLabelTextColor = floatingLabelColor;
    [self addSubview:self.descriptionTextView];
    
    self.descriptionTextView.delegate = self;
    self.div2.backgroundColor = [UIColor silverColor];
    [self addSubview:self.div2];
    self.descriptionTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.div2.translatesAutoresizingMaskIntoConstraints = NO;



}


-(void)creadeDoneButton {
    [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.doneButton.buttonColor = [UIColor midnightBlueColor];
    self.doneButton.shadowColor = [UIColor wetAsphaltColor];
    self.doneButton.shadowHeight = 3.0f;
    self.doneButton.cornerRadius = 6.0f;
    self.doneButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.doneButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor silverColor] forState:UIControlStateHighlighted];
    [self addSubview:self.doneButton];
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;


}


-(void)createTapGesture {
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    self.tapGesture.delegate = self;
    self.tapGesture.numberOfTapsRequired = 1;
    [self.categoryView addGestureRecognizer:self.tapGesture];
    [self.backView addGestureRecognizer:self.tapGesture];
    [self.addCategoryImageView addGestureRecognizer:self.tapGesture];
    [self.addCategoryLabel addGestureRecognizer:self.tapGesture];
    
}


#pragma mark Attributed Strings



-(NSAttributedString *)titleLabelString  {
    
    NSString *baseString = NSLocalizedString(@"Create a BlocSpot", @"title to the topview");
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutAttString;
    
}

// Creating  auto layout constraints for each view

-(void)createConstraints  {


    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleField, _descriptionTextView, _doneButton, _div1, _div2,_div3, _categoryView,_addCategoryImageView, _addCategoryLabel,_backView  ,_topView, _titleLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topView]|"
                                                                 options:kNilOptions
                                                                 metrics:self.metrics
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleField]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_div1]-|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descriptionTextView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_div2]-|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_categoryView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_div3]-|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_doneButton]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel(==44)][_div3(==0.5)][_titleField(==44)][_div1(==0.5)][_descriptionTextView(==100)][_div2(==0.5)][_categoryView(==44)][_doneButton(==44)]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView(==44)][_div3(==0.5)][_titleField(==44)][_div1(==0.5)][_descriptionTextView(==100)][_div2(==0.5)][_categoryView(==44)][_doneButton(==44)]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                views:viewDictionary]];
//    [self.categoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backView]|"
//                                                                 options:kNilOptions
//                                                                 metrics:nil
//                                                                   views:viewDictionary]];
//    [self.categoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backView]"
//                                                                              options:kNilOptions
//                                                                              metrics:nil
//                                                                                views:viewDictionary]];
    [self.categoryView addConstraints:({
        @[ [NSLayoutConstraint
            constraintWithItem:_backView
            attribute:NSLayoutAttributeCenterX
            relatedBy:NSLayoutRelationEqual
            toItem:self.categoryView
            attribute:NSLayoutAttributeCenterX
            multiplier:1.f constant:0.f],
           
           [NSLayoutConstraint
            constraintWithItem:_backView
            attribute:NSLayoutAttributeCenterY
            relatedBy:NSLayoutRelationEqual
            toItem:self.categoryView
            attribute:NSLayoutAttributeCenterY
            multiplier:1.f constant:0] ];
    })];
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_addCategoryImageView]-[_addCategoryLabel]|"
                                                                              options:kNilOptions
                                                                              metrics:nil
                                                                                views:viewDictionary]];
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_addCategoryImageView]|"
                                                                              options:kNilOptions
                                                                              metrics:nil
                                                                                views:viewDictionary]];
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_addCategoryLabel]|"
                                                                          options:kNilOptions
                                                                          metrics:nil
                                                                            views:viewDictionary]];



    
}


-(void)layoutSubviews  {
    
    [super layoutSubviews];
    
    
}
-(void)setPOI:(BLCPointOfInterest *)POI
{
    _POI = POI;
    _POI.placeName = _titleField.text;
    _POI.notes = _descriptionTextView.text;
    //_POI.category = [_tagsControl.tags lastObject];
    
    
}



#pragma mark UIbutton actions

-(void)doneButtonPressed:(FUIButton *)sender {
    [self.delegate customView:self
           didPressDoneButton:self.doneButton
                withTitleText:self.titleField.text
          withDescriptionText:self.descriptionTextView.text
                      withTag:nil];
}

#pragma mark UITapGestureRecognizer action

-(void)tapFired:(UITapGestureRecognizer *)sender
{
    
    //TO DO : present the table view from the top down representing current categories and the opportunity to create more
}


#pragma mark UITextViewDelegate UITextFieldDelegate

//-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self.titleField becomeFirstResponder];
//    [self.tagsControl becomeFirstResponder];
//}
//-(void)textViewDidBeginEditing:(UITextView *)textView {
//    [self.descriptionTextView becomeFirstResponder];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
