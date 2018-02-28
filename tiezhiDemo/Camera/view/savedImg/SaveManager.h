//
//  SaveManager.h
//  tiezhiDemo
//
//  Created by 万 on 2018/2/17.
//  Copyright © 2018年 wan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveManager : NSObject

@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UIImage *currentImage;
+ (SaveManager *)sharedManager;
@end
