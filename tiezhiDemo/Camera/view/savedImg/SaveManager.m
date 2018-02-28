//
//  SaveManager.m
//  tiezhiDemo
//
//  Created by 万 on 2018/2/17.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "SaveManager.h"

@implementation SaveManager

+ (SaveManager *)sharedManager
{
    static SaveManager *ManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ManagerInstance = [[self alloc] init];
    });
    return ManagerInstance;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [@[] mutableCopy];
    }
    return _imageArray;
}
@end
