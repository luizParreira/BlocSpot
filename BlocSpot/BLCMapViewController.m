//
//  BLCMapViewController.m
//  BlocSpot
//
//  Created by luiz parreira on 2/23/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCMapViewController.h"
#import <MapKit/MapKit.h>
#import "UIBarButtonItem+FlatUI.h"
#import "NSString+Icons.h"
#import "UIColor+FlatUI.h"
#import "UINavigationBar+FlatUI.h"


@interface BLCMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIToolbar *topView;


@end

@implementation BLCMapViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.topView = [UIToolbar new];

    self.mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:self.mapView];

    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(searchButtonPressed:)];
    

    UIBarButtonItem *listBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(listViewPressed:)];
    self.navigationItem.rightBarButtonItem = searchBarButton;
    self.navigationItem.leftBarButtonItem = listBarButton;
   [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
