//
//  PasterItemView.m
//  tiezhiDemo
//
//  Created by 万 on 2017/12/18.
//  Copyright © 2017年 wan. All rights reserved.
//

#import "PasterItemView.h"

@interface PasterItemView ()

@end

@implementation PasterItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
- (void)setImgPath:(NSString *)imgPath{
    _imgPath = imgPath;
    _imgName = [imgPath lastPathComponent];
    [self.button setBackgroundImage:[UIImage imageWithContentsOfFile:imgPath] forState:UIControlStateNormal];
    
}
- (void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    [self.button setBackgroundImage:Image_Paster(imgName) forState:UIControlStateNormal];
}

- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc]init];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)buttonAction:(UIButton *)sender{
    if (self.pasterSelectBlock) {
        self.pasterSelectBlock(self.imgName);
    }
}
@end
