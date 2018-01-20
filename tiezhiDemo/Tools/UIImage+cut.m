//
//  UIImage+cut.m
//  tiezhiDemo
//
//  Created by 万 on 2018/1/18.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "UIImage+cut.h"

@implementation UIImage (cut)

+ (UIImage *)getImage3x4:(UIImage *)image{
    if (image.imageOrientation == UIImageOrientationUp) return image;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    //drawInRect方法，它会将图像绘制到画布上，并且已经考虑好了图像的方向
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 裁剪4：3
    CGFloat originX = 0;
    CGFloat originY = (ScreenHeight - ScreenWidth*4/3.0)/2.0 * normalizedImage.size.height/ScreenHeight;
    CGFloat width = normalizedImage.size.width;
    CGFloat height = normalizedImage.size.width * 4/3.0;
    CGRect rect = CGRectMake(originX ,originY,width,height);
    CGImageRef imgRef = CGImageCreateWithImageInRect(normalizedImage.CGImage, rect);
    UIImage *desImg = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    return desImg;
}


//另外一种裁剪image方法
+ (UIImage *)cutImage:(UIImage *)srcImg {
    //iphone默认方向 home键在右边
    //注意：这个rect是指横屏时的rect，即屏幕对着自己，home建在右边
    //取出previewlayer位置图像：x像素开始开始，宽高3：4大小位置图像
    //x像素和这个self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill
    //有关 x = (h-w*4/3)/2
    CGRect rect = CGRectMake((ScreenHeight-ScreenWidth*4/3.0)/2.0 * srcImg.size.height/ScreenHeight , 0, srcImg.size.width * 4/3.0, srcImg.size.width);
    /** 取图片矩形位置生成新图片*/
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
}
@end
