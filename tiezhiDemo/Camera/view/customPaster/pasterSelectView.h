//
//  pasterSelectView.h
//  tiezhiDemo
//
//  Created by 万 on 2018/1/24.
//  Copyright © 2018年 wan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^pasterSelect)(NSString *path) ;
@interface pasterSelectView : UIView

@property (nonatomic,copy) pasterSelect pasterSelectBlock;
@end
