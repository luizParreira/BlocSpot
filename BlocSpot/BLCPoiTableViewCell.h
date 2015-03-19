//
//  BLCPoiTableViewCell.h
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCPointOfInterest.h"
#import "BLCCategoryButton.h"
#import <MapKit/MapKit.h>

@class  BLCPoiTableViewCell;

@protocol BLCPoiTableViewCellDelegate <NSObject>

-(void)cellDidPressOnButton:(BLCPoiTableViewCell *)cell;

@end


@interface BLCPoiTableViewCell : UITableViewCell

@property (nonatomic, strong) id <BLCPoiTableViewCellDelegate> delegate;

@property (nonatomic, strong) UILabel *howFarIsIt;


@property (nonatomic, strong) BLCCategoryButton *categoryButton;
@property (nonatomic, strong) BLCPointOfInterest *poi;

@end
