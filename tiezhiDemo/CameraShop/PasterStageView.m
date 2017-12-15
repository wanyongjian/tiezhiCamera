//
//  PasterStageView.m
//  tiezhiDemo
//
//  Created by 万 on 2017/12/13.
//  Copyright © 2017年 wan. All rights reserved.
//

#import "PasterStageView.h"

@implementation PasterStageView

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addPater];
    }
    return self;
}


- (void)addPater{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self addSubview:view];
    view.backgroundColor = [UIColor darkGrayColor];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [view addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:self];
    sender.view.center = CGPointMake(sender.view.center.x+point.x, sender.view.center.y+point.y);
    NSLog(@"------ %f,%f",point.x,point.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self];
}
@end
