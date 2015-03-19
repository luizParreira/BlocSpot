//
//  BLCSearchResultsTableController.m
//  BlocSpot
//
//  Created by luiz parreira on 3/17/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCSearchResultsTableController.h"
#import "BLCPointOfInterest.h"
#import "BLCPoiTableViewCell.h"
@implementation BLCSearchResultsTableController

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    BLCPointOfInterest *poi = self.searchResults[indexPath.row];
//    
//    
////    [self.delegate controller:self didSelectPOI:poi];
//    // note: should not be necessary but current iOS 8.0 bug (seed 4) requires it
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
////    [self.navigationController pushViewController:self animated:YES];
//
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BLCPoiTableViewCell *cell = (BLCPoiTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Points"];
    
    BLCPointOfInterest *poi = self.searchResults[indexPath.row];
    cell.poi = poi;
    
    return cell;
}

@end
