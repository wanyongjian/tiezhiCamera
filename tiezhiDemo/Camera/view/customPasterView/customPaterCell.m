//
//  customPaterCell.m
//  tiezhiDemo
//
//  Created by 万 on 2018/1/20.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "customPaterCell.h"

@implementation customPaterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor darkGrayColor];

    }
    return self;
}

@end
