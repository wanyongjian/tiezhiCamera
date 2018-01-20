//
//  CameraController.m
//  tiezhiDemo
//
//  Created by wanyongjian on 2017/12/13.
//  Copyright © 2017年 wan. All rights reserved.
//

#import "CameraController.h"
#import <AVFoundation/AVFoundation.h>
#import "LGCameraImageView.h"
#import "XTPasterStageView.h"
#import "ImageEditView.h"
#import "CustomPasterView.h"


@interface CameraController () <AVCapturePhotoCaptureDelegate>

/** 捕获设备，通常是前置摄像头、后置摄像头、麦克风 */
@property (nonatomic, strong) AVCaptureDevice *device;
/** 输入设备，使用AVCaptureDevice来初始化 */
@property (nonatomic, strong) AVCaptureDeviceInput *input;
/** 输出图片 */
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
/** 把输入输出结合到一起，并开始启动捕获设备 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 图像预览层，实时显示捕获的图像 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
/** 摄像头方向*/
@property (nonatomic, assign) AVCaptureDevicePosition position;
@property (nonatomic, assign) AVCaptureFlashMode flashMode;
@property (nonatomic, strong) AVCapturePhotoSettings *settings;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) CustomPasterView *customView;
@property (nonatomic, strong) UIButton *shotButton;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *lightButton;

/** 贴图 */
@property (nonatomic, strong) XTPasterStageView *pasterStageView;

@end

@implementation CameraController

/** 流程是：获取硬件->初始化输入设备->图像输出->输入输出结合->生成预览层实时图像*/
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self cameraDistrict];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.shotButton];
    [self.bottomView addSubview:self.customView];
    [self.view addSubview:self.switchButton];
    [self.view addSubview:self.lightButton];
    self.view.backgroundColor = RGB(0xffffff, 1);
    [self layoutViews];
}

- (void)cameraDistrict{
    //1.创建会话层
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入源
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //创建图像输出
    // Output
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.captureOutput setOutputSettings:outputSettings];
    
    /** 创建会话*/
    self.session = [[AVCaptureSession alloc]init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    //连接输入与会话
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    //连接输出与会话
    if ([self.session canAddOutput:self.captureOutput]) {
        [self.session addOutput:self.captureOutput];
    }
    /** 预览画面*/
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = viewWidth / 480 * 640;

    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = CGRectMake(0, 0,viewWidth, viewHeight);
    [self.view.layer addSublayer:self.previewLayer];

    [self.view addSubview:self.pasterStageView];
    /** 设备取景开始*/
    [self.session startRunning];
}

#pragma mark - 拍照
- (void)shotAction:(UIButton *)sender{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         
         if (!imageSampleBuffer) {
             return;
         }
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [UIImage imageWithData:imageData];
         // 调整方向、裁剪4：3
         t_image = [UIImage getImage3x4:t_image];

         [self displayImage:t_image];
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
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (CustomPasterView *)customView{
    if (!_customView) {
        _customView = [[CustomPasterView alloc]init];
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

- (AVCaptureDevicePosition)position{
    if (!_position) {
        _position = AVCaptureDevicePositionBack;
    }
    return _position;
}

- (XTPasterStageView *)pasterStageView{
    if (!_pasterStageView) {
        CGFloat viewWidth = self.view.frame.size.width;
        CGFloat viewHeight = viewWidth / 480 * 640;
        _pasterStageView = [[XTPasterStageView alloc]initWithFrame: CGRectMake(0, 0,viewWidth, viewHeight)];
        _pasterStageView.backgroundColor = [UIColor clearColor];
        
        WeakSelf;
        _pasterStageView.customActionBlock = ^(BOOL custom) {
            StrongSelf;
            
            if (custom) { // 自定义paster
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    
                    [strongSelf.customView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(strongSelf.bottomView);
                        make.left.right.mas_equalTo(strongSelf.bottomView);
                        make.bottom.mas_equalTo(strongSelf.bottomView);
                    }];
                    
                    strongSelf.shotButton.alpha = 0;
                    [strongSelf.shotButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.mas_equalTo(strongSelf.bottomView);
                        make.bottom.mas_equalTo(strongSelf.view.mas_bottom);
                        make.width.height.mas_equalTo(80);
                    }];
                    [strongSelf.view layoutIfNeeded];
                } completion:nil];
                
            }else{
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [strongSelf.customView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(strongSelf.bottomView);
                        make.left.right.mas_equalTo(strongSelf.bottomView);
                        make.bottom.mas_equalTo(strongSelf.bottomView.mas_top);
                    }];
                    
                    strongSelf.shotButton.alpha = 1;
                    [strongSelf.shotButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.centerY.mas_equalTo(self.bottomView);
                        make.width.height.mas_equalTo(80);
                    }];
                    
                    [strongSelf.view layoutIfNeeded];
                } completion:nil];
                
            }
        };
    }
    return _pasterStageView;
}

- (void)switchAction:(UIButton *)sender{
//    NSLog(@"转换摄像头");
    AVCaptureDevice *newDevice = nil;
    AVCaptureDeviceInput *newInput = nil;
    self.position = self.input.device.position;
    if (self.position == AVCaptureDevicePositionBack) {
        //        self.position = AVCaptureDevicePositionFront;
        newDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
    }else if (self.position == AVCaptureDevicePositionFront){
        //        self.position = AVCaptureDevicePositionBack;
        newDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
    }
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:nil];
    if (newInput) {
        [self.session beginConfiguration];
        [self.session removeInput:self.input];
        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.input = newInput;
        }else{
            [self.session addInput:self.input];
        }
        [self.session commitConfiguration];
    }
    
}
/* 获取硬件*/
- (AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition)position{
    AVCaptureDeviceDiscoverySession *devices = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    
    NSArray *devicesIOS  = devices.devices;
    for (AVCaptureDevice *device in devicesIOS) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
    
}

- (void)lightAction:(UIButton *)sender{
    // 手电筒功能
    //    /**修改前必须线锁定*/
    //    [self.device lockForConfiguration:nil];
    //    /** 必须判断是否有闪光灯，否则会闪退*/
    //    if ([self.device hasFlash]) {
    //
    //        if (self.device.flashMode == AVCaptureFlashModeOn) {
    //            self.lightButton.selected = NO;
    //            self.device.flashMode = AVCaptureFlashModeOff;
    //            self.device.torchMode = AVCaptureTorchModeOff;
    //        }else if(self.device.flashMode == AVCaptureFlashModeOff){
    //            self.lightButton.selected = YES;
    //            self.device.flashMode = AVCaptureFlashModeOn;
    //            self.device.torchMode = AVCaptureTorchModeOn;
    //        }
    //    }
    //
    //    [self.device unlockForConfiguration];
    
    //闪光灯功能
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.flashMode = AVCaptureFlashModeOn;
    }else{
        self.flashMode = AVCaptureFlashModeOff;
    }
}

- (AVCaptureFlashMode)flashMode{
    if (!_flashMode) {
        _flashMode = AVCaptureFlashModeOff;
    }
    return _flashMode;
}

- (AVCapturePhotoSettings *)settings{
    if (!_settings) {
        _settings =[AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecTypeJPEG}];
        _settings.flashMode = AVCaptureFlashModeOff;
    }
    return _settings;
}

/** 切换前后摄像头 */
- (void)layoutViews{
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(_pasterStageView.mas_bottom);
    }];
    [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(_bottomView);
        make.bottom.mas_equalTo(_bottomView.mas_top);
    }];
    [_shotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.bottomView);
        make.width.height.mas_equalTo(80);
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
