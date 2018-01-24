//
//  PasterItemView.h
//  tiezhiDemo
//
//  Created by 万 on 2017/12/18.
//  Copyright © 2017年 wan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^pasterSelect)(NSString *imgName);

@interface PasterItemView : UIView
@property (nonatomic, copy)pasterSelect pasterSelectBlock;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,copy) NSString *imgName;
@property (nonatomic,copy) NSString *imgPath;
@end
