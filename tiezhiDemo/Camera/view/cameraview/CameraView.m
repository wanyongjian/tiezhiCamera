//
//  CameraView.m
//  tiezhiDemo
//
//  Created by 万 on 2018/1/22.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "CameraView.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraView() <AVCapturePhotoCaptureDelegate>

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

@end

@implementation CameraView

- (instancetype)init{
    if (self = [super init]) {
        [self cameraDistrict];
    }
    return self;
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
    CGFloat viewWidth = ScreenWidth;
    CGFloat viewHeight = viewWidth / 480 * 640;
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = CGRectMake(0, 0,viewWidth, viewHeight);
    [self.layer addSublayer:self.previewLayer];
//    self.backgroundColor = [UIColor blueColor];
    /** 设备取景开始*/
    [self.session startRunning];
}

- (void)start{
    
}

- (void)shotImage:(void (^)(UIImage *))Image{
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
         Image(t_image);
        
     }];
}

- (void)switchCam{
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

- (void)light{
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
//    sender.selected = !sender.selected;
//    if (sender.selected == YES) {
//        self.flashMode = AVCaptureFlashModeOn;
//    }else{
//        self.flashMode = AVCaptureFlashModeOff;
//    }
}
#pragma mark - lazyload
- (AVCaptureDevicePosition)position{
    if (!_position) {
        _position = AVCaptureDevicePositionBack;
    }
    return _position;
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
@end
