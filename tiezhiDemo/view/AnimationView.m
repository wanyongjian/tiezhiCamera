//
//  AnimationView.m
//  tiezhiDemo
//
//  Created by 万 on 2017/12/19.
//  Copyright © 2017年 wan. All rights reserved.
//

#import "AnimationView.h"
@interface AnimationView()

@property (nonatomic, strong) UIImageView *dogImg;
@property (nonatomic, strong) UIImageView *catImg;
@end

@implementation AnimationView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.dogImg];
        [self addSubview:self.catImg];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_dogImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(60);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100*960/550.0);
    }];
    
    [_catImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-60);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100*624/502.0);
    }];
}

- (UIImageView *)dogImg{
    if (!_dogImg) {
        _dogImg = [[UIImageView alloc]initWithImage:Image_Paster(@"dog")];
    }
    return _dogImg;
}

- (UIImageView *)catImg{
    if (!_catImg) {
        _catImg = [[UIImageView alloc]initWithImage:Image_Paster(@"cat")];
    }
    return _catImg;
}
@end
