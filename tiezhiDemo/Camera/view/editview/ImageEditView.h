//
//  ImageEditView.h
//  tiezhiDemo
//
//  Created by 万 on 2018/1/14.
//  Copyright © 2018年 wan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasterEditView.h"
typedef void(^saveImg)(UIImage *image);

@interface ImageEditView : UIView

@property (nonatomic, strong) PasterEditView *editView;
@property (nonatomic, copy) saveImg saveImgBlock;
- (void)animation;
@end
