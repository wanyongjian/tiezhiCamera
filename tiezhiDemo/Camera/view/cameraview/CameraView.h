//
//  CameraView.h
//  tiezhiDemo
//
//  Created by 万 on 2018/1/22.
//  Copyright © 2018年 wan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraView : UIView

- (void)start;
- (void)shotImage:(void(^)(UIImage *image))Image;
- (void)switchCam;
- (void)light;
@end
