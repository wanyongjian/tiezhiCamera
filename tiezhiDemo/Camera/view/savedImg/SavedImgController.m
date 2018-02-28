//
//  SavedImgController.m
//  tiezhiDemo
//
//  Created by 万 on 2018/2/17.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "SavedImgController.h"

@interface SavedImgController ()

//@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *devideLine;
@property (nonatomic,strong) UIButton *deleteBtn;
@end

@implementation SavedImgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.devideLine];
    [self.bottomView addSubview:self.deleteBtn];
    
    [self layoutViews];
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = RGB(0xf9f9f9, 1);
    }
    return _bottomView;
}
- (UIView *)devideLine{
    if (!_devideLine) {
        _devideLine = [[UIView alloc]init];
        _devideLine.backgroundColor = RGB(0xdbdbdb, 1);
    }
    return _devideLine;
}
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setBackgroundImage:Image_Paster(@"close") forState:UIControlStateNormal];
    }
    return _deleteBtn;
}
-(void)deleteAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)layoutViews{
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(KWidthPro(130));
    }];
    
    [_devideLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(_bottomView);
        make.height.mas_equalTo(1);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_bottomView);
        make.width.height.mas_equalTo(30);
    }];
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[SaveManager sharedManager].currentImage];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _imageView;
}
@end
