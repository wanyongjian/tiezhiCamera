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
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

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
@property (nonatomic, strong) UIView *pasterView;
/** 摄像头方向*/
@property (nonatomic, assign) AVCaptureDevicePosition position;
@property (nonatomic, assign) AVCaptureFlashMode flashMode;
@property (nonatomic, strong) AVCapturePhotoSettings *settings;
@property (nonatomic, strong) UIButton *shotButton;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *lightButton;
@end

@implementation CameraController

/** 流程是：获取硬件->初始化输入设备->图像输出->输入输出结合->生成预览层实时图像*/
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self cameraDistrict];
    [self.view addSubview:self.shotButton];
    [self.view addSubview:self.switchButton];
    [self.view addSubview:self.lightButton];
    [self layoutSubviews];
    
}

- (void)layoutSubviews{
    [_shotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-50);
        make.width.height.mas_equalTo(80);
    }];
    
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).offset(15);
        make.width.height.mas_equalTo(30);
    }];
    
    [_lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_switchButton);
        make.bottom.mas_equalTo(_switchButton.mas_top).offset(-30);
        make.width.height.mas_equalTo(30);
    }];
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
    self.previewLayer.frame = CGRectMake(0, 40,viewWidth, viewHeight);
    [self.pasterView.layer addSublayer:self.previewLayer];
    [self.view.layer addSublayer:self.previewLayer];
    self.pasterView.frame = CGRectMake(0, 40,viewWidth, viewHeight);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.backgroundColor = [UIColor blackColor];
    [self.pasterView addSubview:view];
    
    [self.view addSubview:self.pasterView];
    /** 设备取景开始*/
    [self.session startRunning];
}

- (UIButton *)lightButton{
    if (!_lightButton) {
        _lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lightButton setImage:[UIImage imageNamed:@"lightOff"] forState:UIControlStateNormal];
        [_lightButton setImage:[UIImage imageNamed:@"lightOn"] forState:UIControlStateSelected];
        [_lightButton addTarget:self action:@selector(lightAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightButton;
}
- (UIButton *)switchButton{
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:[UIImage imageNamed:@"switchCamera"] forState:UIControlStateNormal];\
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}
- (UIButton *)shotButton{
    if (!_shotButton) {
        _shotButton = [[UIButton alloc]init];
        [_shotButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
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

- (UIView *)pasterView{
    if (!_pasterView) {
        _pasterView = [[UIView alloc]init];
    }
    return _pasterView;
}
- (void)switchAction:(UIButton *)sender{
//    NSLog(@"转换摄像头");
//    AVCaptureDevice *newDevice = nil;
//    AVCaptureDeviceInput *newInput = nil;
//    self.position = self.input.device.position;
//    if (self.position == AVCaptureDevicePositionBack) {
//        //        self.position = AVCaptureDevicePositionFront;
//        newDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
//    }else if (self.position == AVCaptureDevicePositionFront){
//        //        self.position = AVCaptureDevicePositionBack;
//        newDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
//    }
//    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:nil];
//    if (newInput) {
//        [self.session beginConfiguration];
//        [self.session removeInput:self.input];
//        if ([self.session canAddInput:newInput]) {
//            [self.session addInput:newInput];
//            self.input = newInput;
//        }else{
//            [self.session addInput:self.input];
//        }
//        [self.session commitConfiguration];
//    }
    
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
/** 拍照拿到图片 */
- (void)shotAction:(UIButton *)sender{
//    self.settings =[AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecTypeJPEG}];
//    self.settings.flashMode = self.flashMode;
//    [self.imageOutput capturePhotoWithSettings:self.settings delegate:self];
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
         
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [UIImage imageWithData:imageData];
         t_image = [self cutImage:t_image];
         //         t_image = [self fixOrientation:t_image];
         
         //图片合成
         
         [self displayImage:[self complexImage:t_image]];
     }];
}

- (UIImage *)getImageFromView:(UIView *)theView
{
    CGSize orgSize = theView.bounds.size ;
    UIGraphicsBeginImageContextWithOptions(orgSize, YES, theView.layer.contentsScale * 2);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()]   ;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext()    ;
    UIGraphicsEndImageContext() ;

    return image ;
}

- (UIImage *)complexImage:(UIImage *)soureceImg{
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = viewWidth / 480 * 640;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.frame];
    imageView.image = soureceImg;
    [view addSubview:imageView];
    [view addSubview:self.pasterView];
    return [self getImageFromView:view];
}

- (void)displayImage:(UIImage *)images {
    LGCameraImageView *view = [[LGCameraImageView alloc] initWithFrame:self.view.frame];
//    view.delegate = self;
//    view.imageOrientation = _imageOrientation;
    view.imageToDisplay = images;
    [self.view addSubview:view];
    
}

//裁剪image
- (UIImage *)cutImage:(UIImage *)srcImg {
    //iphone默认方向 home键在右边
    //注意：这个rect是指横屏时的rect，即屏幕对着自己，home建在右边
    //取出previewlayer位置图像：x像素开始开始，宽高3：4大小位置图像
    //x像素和这个self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill
    //有关 x = (h-w*4/3)/2
    CGRect rect = CGRectMake(((CGRectGetHeight(self.view.frame)-CGRectGetWidth(self.view.frame)*4/3.0)/2.0) * srcImg.size.height/CGRectGetHeight(self.view.frame) , 0, srcImg.size.width * 4/3, srcImg.size.width);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(srcImg.CGImage, rect);
    CGFloat subWidth = CGImageGetWidth(subImageRef);
    CGFloat subHeight = CGImageGetHeight(subImageRef);
    CGRect smallBounds = CGRectMake(0, 0, subWidth, subHeight);
    //旋转后，画出来
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0, subWidth);
    transform = CGAffineTransformRotate(transform, -M_PI_2);
    CGContextRef ctx = CGBitmapContextCreate(NULL, subHeight, subWidth,
                                             CGImageGetBitsPerComponent(subImageRef), 0,
                                             CGImageGetColorSpace(subImageRef),
                                             CGImageGetBitmapInfo(subImageRef));
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, smallBounds, subImageRef);
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(subImageRef);
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error{
//    NSData *imageData = [photo fileDataRepresentation];
//    UIImage *image = [UIImage imageWithData:imageData];
//    UIImageView *view = [[UIImageView alloc]initWithImage:image];
//    view.frame = self.view.frame;
//    [self.view addSubview:view];
//    [self saveImageToPhotoAlbum:image];
//}

///** 保存照片到相册 */
//- (void)saveImageToPhotoAlbum:(UIImage *)saveImage{
//    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//}
//
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo
//
//{
//    NSString *msg = nil ;
//    if(error != NULL){
//        msg = @"保存图片失败" ;
//    }else{
//        msg = @"保存图片成功" ;
//    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
//                                                    message:msg
//                                                   delegate:self
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil];
//    [alert show];
//}

/** 切换前后摄像头 */

@end
