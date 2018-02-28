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
//        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.imgView];
        [self layoutViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1;

    }else{
        self.layer.borderWidth = 0;
    }
}
- (void)setPaterPath:(NSString *)paterPath{
//    _imgName = [imgPath lastPathComponent];
//    self.imgView.image = [UIImage imageWithContentsOfFile:paterPath];
    NSURL *url = [NSURL fileURLWithPath:paterPath];
    [self.imgView sd_setImageWithURL:url];
    
}

- (void)layoutViews{
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

@end
