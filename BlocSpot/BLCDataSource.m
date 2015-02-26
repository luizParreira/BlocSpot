//
//  BLCDataSource.m
//  BlocSpot
//
//  Created by luiz parreira on 2/23/15.
//  Copyright (c) 2015 LP. All rights reserved.
//

#import "BLCDataSource.h"

@implementation BLCDataSource



+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(instancetype)init {
    self = [super init];
    if (self){
        
        
        
        
    }
    return self;
    
}

@end
