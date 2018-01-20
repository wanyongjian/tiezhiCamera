//
//  ViewController.m
//  tiezhiDemo
//
//  Created by wanyongjian on 2017/12/12.
//  Copyright © 2017年 wan. All rights reserved.
//

#import "ViewController.h"
#import "AnimationView.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *pictureBtn;

@property (nonatomic, strong) AnimationView *animationView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.bgImg];
    [self.view addSubview:self.cameraBtn];
    [self.view addSubview:self.pictureBtn];
    [self.view addSubview:self.animationView];
    
    [self layoutSubViews];
}
- (void)layoutSubViews{
    [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view).centerOffset(CGPointMake(0,-20));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(80);
    }];
    
    [_pictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.view).centerOffset(CGPointMake(0, 60));
        make.centerX.mas_equalTo(_cameraBtn);
        make.top.mas_equalTo(_cameraBtn.mas_bottom).offset(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(80);
    }];
    
    [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(40);
        make.bottom.mas_equalTo(self.cameraBtn.mas_top).offset(-20);
    }];
}

- (UIButton *)pictureBtn{
    if (!_pictureBtn) {
        _pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pictureBtn setTitle:@"选择照片" forState:UIControlStateNormal];
        [_pictureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_pictureBtn setBackgroundImage:Image_Paster(@"btnBg1") forState:UIControlStateNormal];
    }
    return _pictureBtn;
}
- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [_cameraBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cameraBtn setBackgroundImage:Image_Paster(@"btnBg1") forState:UIControlStateNormal];
    }
    return _cameraBtn;
}

- (UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]initWithFrame:self.view.frame];
        _bgImg.image = Image_Paster(@"catBg");
    }
    return _bgImg;
}
- (AnimationView *)animationView{
    if (!_animationView) {
        _animationView = [[AnimationView alloc]init];
//        _animationView.backgroundColor = [UIColor grayColor];
    }
    return _animationView;
}
@end
