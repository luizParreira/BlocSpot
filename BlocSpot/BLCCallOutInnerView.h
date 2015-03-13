//
//  BLCCallOutInnerView.h
//  BlocSpot
//
//  Created by luiz parreira on 3/13/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BLCCustomAnnotation.h"



@interface BLCCallOutInnerView : UIView
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *categoryLabel;

@property (nonatomic, strong) id<MKAnnotation> customAnnotation;


-(id)initForAnnotation:(id<MKAnnotation>)annotation;
@end
