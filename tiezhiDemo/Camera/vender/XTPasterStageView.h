//
//  XTPasterStageView.h
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XTPasterStageView : UIView

@property (nonatomic,strong) UIImage *originImage ;
@property (nonatomic,strong) NSMutableArray *pasterArray;

- (void)resetPaster; // 清空paster数组，重新添加素材
- (void)addPasterWithImg:(UIImage *)imgP ;
- (UIImage *)doneEdit ;
@end
