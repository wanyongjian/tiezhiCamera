//
//  PasterImageController.m
//  tiezhiDemo
//
//  Created by wanyongjian on 2017/12/12.
//  Copyright © 2017年 wan. All rights reserved.
//

/**
 图片操作：贴图、裁剪
 */
#import "PasterImageController.h"

@interface PasterImageController ()

@end

@implementation PasterImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageview];
//    imageview.image = [self addLogo:[UIImage imageNamed:@"image1.jpg"] toImg:[UIImage imageNamed:@"image2.jpeg"]];
//    imageview.image = [self addToImg:[UIImage imageNamed:@"image2.jpeg"] withLogo:[UIImage imageNamed:@"image1.jpg"] rect:CGRectMake(100, 100, 100, 100)];

}


///**
//    将UIView转成UIImage,这个方法导致分辨率降低，不适用！！！
// */
//- (UIImage *)getImageFromView:(UIView *)theView
//{
//    CGSize orgSize = theView.bounds.size ;
//    UIGraphicsBeginImageContextWithOptions(orgSize, YES, theView.layer.contentsScale * 2);
//    [theView.layer renderInContext:UIGraphicsGetCurrentContext()]   ;
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext()    ;
//    UIGraphicsEndImageContext() ;
//
//    return image ;
//}

//- (UIImage *)cutImage:(UIImage *)image withRect:(CGRect)rect{
//    /**
//     图片裁剪
//     rect是裁剪的图片真实像素
//     */
//    imageview.image = [self cutImage:[UIImage imageNamed:@"image2.jpeg"] withRect:CGRectMake(0, 0, 200, 200)];
//    CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, rect);
//    UIImage *desImg = [UIImage imageWithCGImage:imgRef];
//    CGImageRelease(imgRef);
//    return desImg;
//}

//- (UIImage *)addToImg:(UIImage *)image withLogo:(UIImage *)logo rect:(CGRect)rect{
//    /**
//     图片添加贴图
//     简单一点的写法
//     注意：rect都是图片的像素位置，并不是手机屏幕
//     */
//    imageview.image = [self addToImg:[UIImage imageNamed:@"image2.jpeg"] withLogo:[UIImage imageNamed:@"image1.jpg"] rect:CGRectMake(100, 100, 100, 100)];
//    int w = image.size.width;
//    int h = image.size.height;
//    //创建基于位图的上下文，并设为当前上下文
//    UIGraphicsBeginImageContext(image.size);
//    [image drawInRect:CGRectMake(0, 0, w, h)];
//    [logo drawInRect:rect];
//    UIImage *desImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return desImg;
//}


//- (UIImage *)addLogo:(UIImage *)logoImg toImg:(UIImage *)sourceImg{
//    /**
//     图片加贴图
//     把两张图片画到画布上，再取出
//     */
//    imageview.image = [self addLogo:[UIImage imageNamed:@"image1.jpg"] toImg:[UIImage imageNamed:@"image2.jpeg"]];
//    int w = sourceImg.size.width;
//    int h = sourceImg.size.height;
//    int logoW = logoImg.size.width;
//    int logoH = logoImg.size.height;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(nil, w, h, 8, 4*w, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), sourceImg.CGImage);
//    CGContextDrawImage(context, CGRectMake(0, 30, logoW, logoH), logoImg.CGImage);
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return [UIImage imageWithCGImage:imageMasked];
//}

@end
