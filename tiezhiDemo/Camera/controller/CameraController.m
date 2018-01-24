//
//  CameraController.m
//  tiezhiDemo
//
//  Created by wanyongjian on 2017/12/13.
//  Copyright © 2017年 wan. All rights reserved.
//

#import "CameraController.h"
#import "LGCameraImageView.h"
#import "XTPasterStageView.h"
#import "ImageEditView.h"
#import "CameraView.h"
#import "pasterSelectView.h"

static NSInteger Height = 65;
@interface CameraController ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) pasterSelectView *customView;

@property (nonatomic, strong) UIButton *shotButton;
@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *downButton;

@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *lightButton;
@property (nonatomic,assign) BOOL bottomAlpha0; /** 区分是否在自定义paster*/
@property (nonatomic, strong) CameraView *cameraView;
/** 贴图 */
@property (nonatomic, strong) XTPasterStageView *pasterStageView;

@end

@implementation CameraController

/** 流程是：获取硬件->初始化输入设备->图像输出->输入输出结合->生成预览层实时图像*/
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.cameraView];
    [self.view addSubview:self.pasterStageView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.shotButton];
    [self.bottomView addSubview:self.moreBtn];
    [self.view addSubview:self.customView];
    [self.view addSubview:self.downButton];
    [self.view addSubview:self.switchButton];
    [self.view addSubview:self.lightButton];
    self.view.backgroundColor = RGB(0xffffff, 1);
    self.bottomAlpha0 = NO;
//    [self.cameraView start];
    [self layoutViews];
}



#pragma mark - 拍照
- (void)shotAction:(UIButton *)sender{
    [self.cameraView shotImage:^(UIImage *image) {
        [self displayImage:image];
    }];
}

- (void)displayImage:(UIImage *)images {
    ImageEditView *view = [[ImageEditView alloc] initWithFrame:self.view.frame];
    view.editView.sourceImg = images;
    view.editView.pasterArray = [self.pasterStageView.pasterArray mutableCopy];
    [self.view addSubview:view];
    [self.pasterStageView resetPaster];
}

#pragma mark - lazyload
- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.layer.masksToBounds = YES;
        _moreBtn.layer.cornerRadius = Height/2;
        _moreBtn.backgroundColor = [UIColor blackColor];
        [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (void)moreAction:(UIButton *)sender{
    [UIView animateWithDuration:0.4 animations:^{
        [self.customView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(_bottomView);
            make.top.mas_equalTo(_bottomView.mas_top).mas_offset(-Height);

        }];
        [self.view layoutIfNeeded];
    }];
    
}

- (UIButton *)downButton{
    if (!_downButton) {
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downButton.layer.masksToBounds = YES;
        _downButton.layer.cornerRadius = Height/2;
        _downButton.backgroundColor = [UIColor whiteColor];
        [_downButton addTarget:self action:@selector(downAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downButton;
}

- (void)downAction{
    [UIView animateWithDuration:0.4 animations:^{
        [self.customView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(_bottomView);
            make.top.mas_equalTo(_bottomView.mas_bottom);
        }];
        [self.view layoutIfNeeded];
    }];
}
- (CameraView *)cameraView{
    if (!_cameraView) {
        _cameraView = [[CameraView alloc]init];
    }
    return _cameraView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (pasterSelectView *)customView{
    if (!_customView) {
        _customView = [[pasterSelectView alloc]init];
    }
    return _customView;
}
- (UIButton *)lightButton{
    if (!_lightButton) {
        _lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lightButton setImage:Image_Paster(@"lightOff") forState:UIControlStateNormal];
        [_lightButton setImage:Image_Paster(@"lightOn") forState:UIControlStateSelected];
        [_lightButton addTarget:self action:@selector(lightAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightButton;
}
- (UIButton *)switchButton{
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:Image_Paster(@"switchCamera") forState:UIControlStateNormal];\
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}
- (UIButton *)shotButton{
    if (!_shotButton) {
        _shotButton = [[UIButton alloc]init];
        [_shotButton setImage:Image_Paster(@"camera") forState:UIControlStateNormal];
        [_shotButton addTarget:self action:@selector(shotAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _shotButton;
}



- (XTPasterStageView *)pasterStageView{
    if (!_pasterStageView) {
        
        _pasterStageView = [[XTPasterStageView alloc]initWithFrame: CGRectMake(0, 0,cameraWidth, cameraHeight)];
        _pasterStageView.backgroundColor = [UIColor clearColor];
    }
    return _pasterStageView;
}

- (void)switchAction:(UIButton *)sender{
//    NSLog(@"转换摄像头");
    [self.cameraView switchCam];
    
}

- (void)lightAction:(UIButton *)sender{
    [self.cameraView light];
}

/** 切换前后摄像头 */
- (void)layoutViews{
    [_cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_offset(cameraHeight);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(_pasterStageView.mas_bottom);
    }];
    [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_bottomView);
        make.top.mas_equalTo(_bottomView.mas_bottom);
        make.height.mas_equalTo(ScreenHeight-cameraHeight+65);
    }];
    [_downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_customView.mas_left);
        make.bottom.mas_equalTo(_customView.mas_top);
        make.width.height.mas_equalTo(Height);
    }];
   
    [_shotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.bottomView);
        make.width.height.mas_equalTo(80);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(65);
        make.centerX.mas_equalTo(self.bottomView).centerOffset(CGPointMake(-ScreenWidth/4-80/2/2, 0));
        make.centerY.mas_equalTo(self.bottomView);
    }];
    
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).centerOffset(CGPointMake(-ScreenWidth/4, 0));
        make.top.mas_equalTo(self.view).offset(15);
        make.width.height.mas_equalTo(30);
    }];
    
    [_lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).centerOffset(CGPointMake(ScreenWidth/4, 0));
        make.top.mas_equalTo(self.view).offset(15);
        make.width.height.mas_equalTo(30);
    }];
}
@end
