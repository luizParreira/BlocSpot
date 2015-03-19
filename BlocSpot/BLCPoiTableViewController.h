//
//  BLCPoiTableViewController.h
//  BlocSpot
//
//  Created by luiz parreira on 2/24/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLCPoiTableViewController, BLCPointOfInterest ;
@protocol  BLCPoiTableViewControllerDelegate <NSObject>


-(void)didSelectPOI:(BLCPointOfInterest *)poi;
@end
@interface BLCPoiTableViewController : UITableViewController 

@property (nonatomic, weak) id <BLCPoiTableViewControllerDelegate> tableDelegate;


@end
