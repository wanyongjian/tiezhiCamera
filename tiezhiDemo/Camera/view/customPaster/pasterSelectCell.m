//
//  pasterSelectCell.m
//  tiezhiDemo
//
//  Created by 万 on 2018/1/24.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "pasterSelectCell.h"

@interface pasterSelectCell()

@property (nonatomic,strong) UIImageView *imgView;
@end


@implementation pasterSelectCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.imgView];
        [self layoutViews];
    }
    return self;
}

- (void)setPaterPath:(NSString *)paterPath{
//    _imgName = [imgPath lastPathComponent];
    self.imgView.image = [UIImage imageWithContentsOfFile:paterPath];
}

- (void)layoutViews{
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}

@end
