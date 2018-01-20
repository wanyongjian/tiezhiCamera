//
//  XTPasterView.h
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTPasterStageView.h"
#import "PasterEditView.h"

@class XTPasterView ;
typedef void(^firstResponder)(int pasterID);
typedef void(^removePaster)(int pasterID);


@interface XTPasterView : UIView

@property (nonatomic,copy) firstResponder firstResponderBlock;
@property (nonatomic,copy) removePaster removePasterBlock;
@property (nonatomic,assign) CGFloat rotateAngel;
@property (nonatomic,strong)    UIImage *imagePaster ;
@property (nonatomic)           int     pasterID ;
@property (nonatomic)           BOOL    onFirstResponder ;

- (void)AddToEditView:(PasterEditView *)editView;
- (instancetype)initWithStageView:(XTPasterStageView *)bgView pasterID:(int)pasterID img:(UIImage *)img ;
- (void)remove ;
@end
