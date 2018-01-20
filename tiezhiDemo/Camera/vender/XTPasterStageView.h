//
//  XTPasterStageView.h
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^customAction)(BOOL custom);
@interface XTPasterStageView : UIView

@property (nonatomic,copy)  customAction customActionBlock;
@property (nonatomic,assign) BOOL bottomAlpha0; /** 区分是否在自定义paster*/
@property (nonatomic,strong) UIImage *originImage ;
@property (nonatomic,strong) NSMutableArray *pasterArray;

- (void)resetPaster; // 清空paster数组，重新添加素材
- (void)addPasterWithImg:(UIImage *)imgP ;
- (UIImage *)doneEdit ;
@end
