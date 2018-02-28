//
//  XTPasterStageView.h
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^hideMore)(void);
@interface XTPasterStageView : UIView

//@property (nonatomic,strong) UIImage *originImage ;
@property (nonatomic,strong) NSMutableArray *pasterArray;
@property (nonatomic,copy) hideMore hideMoreBlock;
- (void)resetPaster; // 清空paster数组，重新添加素材
- (void)addPasterWithImgPath:(NSString *)path;
//- (UIImage *)doneEdit ;
@end
