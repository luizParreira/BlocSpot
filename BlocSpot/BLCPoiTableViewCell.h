//
//  BLCPoiTableViewCell.h
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCPointOfInterest.h"

@interface BLCPoiTableViewCell : UITableViewCell



+(CGFloat) heightForPointOfInterestCell:(BLCPointOfInterest *)point width:(CGFloat)width;

@end
