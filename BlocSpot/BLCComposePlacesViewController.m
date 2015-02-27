//
//  BLCComposePlacesViewController.m
//  BlocSpot
//
//  Created by luiz parreira on 2/26/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCComposePlacesViewController.h"
#import "BLCCustomCreateAnnotationsView.h"

@interface BLCComposePlacesViewController ()
@property (nonatomic, strong) BLCCustomCreateAnnotationsView *createAnnotations;
@end

@implementation BLCComposePlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.createAnnotations = [[BLCCustomCreateAnnotationsView alloc] init];
    _createAnnotations.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.userInteractionEnabled =YES;
    [self.view addSubview:_createAnnotations];
    [self createConstraints];
    
    
}
-(void)createConstraints {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_createAnnotations);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_createAnnotations]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_createAnnotations]"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
