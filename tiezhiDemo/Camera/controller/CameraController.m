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
#import "SavedImgController.h"

static NSInteger Height = 65;
@interface CameraController ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) pasterSelectView *customView;

@property (nonatomic, strong) UIButton *shotButton;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UIButton *viewButton;

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
    [self.bottomView addSubview:self.viewButton];
    
    [self.view addSubview:self.customView];
    [self.view addSubview:self.downButton];
//    [self.view addSubview:self.switchButton];
//    [self.view addSubview:self.lightButton];
    self.view.backgroundColor = RGB(0xffffff, 1);
    self.bottomAlpha0 = NO;
//    [self.cameraView start];
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:ZPosition];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self layoutViews];
}



#pragma mark - 拍照
- (void)shotAction:(UIButton *)sender{
    [self.cameraView shotImage:^(UIImage *image) {
//    UIImage *image = Image_Paster(@"demo");
        [self displayImage:image];
    }];
}

- (void)displayImage:(UIImage *)images {
    ImageEditView *view = [[ImageEditView alloc] initWithFrame:self.view.frame];
    view.saveImgBlock = ^(UIImage *image) {
        self.viewButton.hidden = NO;
        [self.viewButton setImage:image forState:UIControlStateNormal];
    };
    view.editView.sourceImg = images;
    view.editView.pasterArray = [self.pasterStageView.pasterArray mutableCopy];
    [self.view addSubview:view];
    [self.pasterStageView resetPaster];
}

#pragma mark - lazyload
- (void)moreAction:(UIButton *)sender{
    [UIView animateWithDuration:0.4 animations:^{
        [self.customView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(_bottomView);
            make.top.mas_equalTo(_bottomView.mas_top).mas_offset(-Height);
            
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.downButton.hidden = NO;
    }];
    
}

- (void)downAction{
    self.downButton.hidden = YES;
    [UIView animateWithDuration:0.4 animations:^{
        [self.customView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(_bottomView);
            make.top.mas_equalTo(_bottomView.mas_bottom);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setBackgroundImage:Image_Paster(@"up") forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIButton *)viewButton{
    if (!_viewButton) {
        _viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewButton.hidden = YES;
        _viewButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _viewButton.layer.cornerRadius = 30;
        _viewButton.layer.masksToBounds = YES;
        [_viewButton addTarget:self action:@selector(viewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewButton;
}
- (void)viewAction{
    SavedImgController *controller = [[SavedImgController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:controller animated:YES completion:nil];
}
- (UIButton *)downButton{
    if (!_downButton) {
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downButton.alpha = 0.6;
        _downButton.hidden = YES;
        [_downButton setBackgroundImage:Image_Paster(@"down") forState:UIControlStateNormal];
        [_downButton addTarget:self action:@selector(downAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downButton;
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
        WeakSelf;
        _customView = [[pasterSelectView alloc]init];
        _customView.pasterSelectBlock = ^(NSString *path) {
            StrongSelf;
            [strongSelf.pasterStageView addPasterWithImgPath:path];
        };
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
        [_shotButton setImage:Image_Paster(@"camera1") forState:UIControlStateNormal];
        [_shotButton addTarget:self action:@selector(shotAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _shotButton;
}



- (XTPasterStageView *)pasterStageView{
    if (!_pasterStageView) {
        WeakSelf;
        _pasterStageView = [[XTPasterStageView alloc]initWithFrame: CGRectMake(0, 0,cameraWidth, cameraHeight)];
        _pasterStageView.hideMoreBlock = ^{
            StrongSelf;
            [strongSelf downAction];
        };
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
        make.width.height.mas_equalTo(60);
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
    
    [_viewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.centerX.mas_equalTo(self.bottomView).centerOffset(CGPointMake(ScreenWidth/4+80/2/2, 0));
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
