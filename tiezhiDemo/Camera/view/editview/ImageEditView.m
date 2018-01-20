//
//  ImageEditView.m
//  tiezhiDemo
//
//  Created by 万 on 2018/1/14.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "ImageEditView.h"
#import "XTPasterView.h"

@interface ImageEditView()
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *saveBtn;
@end

@implementation ImageEditView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.editView];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.saveBtn];
        [self layoutViews];
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)layoutViews{
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-20);
        make.width.height.mas_equalTo(60);
    }];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cancelBtn.mas_top);
        make.left.mas_equalTo(_cancelBtn.mas_right).offset(60);
        make.width.height.mas_equalTo(60);
    }];
}

- (PasterEditView *)editView{
    if (!_editView) {
        CGFloat viewWidth = ScreenWidth;
        CGFloat viewHeight = viewWidth / 480 * 640;
        _editView = [[PasterEditView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    }
    return _editView;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"重拍" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (void)saveAction{
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*4/3)];
    UIImage *soureceImg = self.editView.sourceImg;
    for (NSInteger i=0; i<self.editView.pasterArray.count; i++) {
        soureceImg = [self addPasterToImg:soureceImg paster:self.editView.pasterArray[i]];
    }
    img.image = soureceImg;
    [self addSubview:img];
}

- (UIImage *)addPasterToImg:(UIImage *)sourceImg paster:(XTPasterView *)pasterView{
    // 先旋转贴纸
    UIImage *pasterImg = pasterView.imagePaster;
    CGSize imgSize = CGSizeMake(pasterImg.size.width, pasterImg.size.height);
    // 新方形图片宽高
    CGFloat contextWidth = sqrt((pasterImg.size.width*pasterImg.size.width)+(pasterImg.size.height*pasterImg.size.height));
    CGSize contextSize = CGSizeMake(contextWidth,contextWidth);
//    CGSize contextSize = CGSizeMake(imgSize.width,imgSize.height);
    CGFloat contextOffsetX = (contextWidth-pasterImg.size.width)/2;
    CGFloat contextOffsetY = (contextWidth-pasterImg.size.height)/2;

    UIGraphicsBeginImageContext(contextSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, contextSize.width / 2, contextSize.height / 2);
    CGContextRotateCTM(context, pasterView.rotateAngel);
    CGContextTranslateCTM(context, -contextSize.width / 2, -contextSize.height / 2);

    [pasterImg drawInRect:CGRectMake(contextOffsetX, contextOffsetY, imgSize.width, imgSize.height)];
//    [pasterImg drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    UIImage *newPasterImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //再把贴纸画到原图片上
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(sourceImg.size, NO, 0);
    //3.绘制背景图片
    [sourceImg drawInRect:CGRectMake(0, 0, sourceImg.size.width, sourceImg.size.height)];
    //绘制水印图片到当前上下文
    CGPoint imgCenter = pasterView.center;
    CGFloat imgWidth = pasterView.bounds.size.width-15*2;
    CGFloat imgHeight = pasterView.bounds.size.height-15*2;

    CGPoint imgPixelCenter = CGPointMake(imgCenter.x*sourceImg.size.width/self.editView.frame.size.width, imgCenter.y*sourceImg.size.height/self.editView.frame.size.height);
    CGFloat imgPixelWidth = imgWidth*sourceImg.size.width/self.editView.frame.size.width;
    CGFloat imgPixelHeight = imgHeight*sourceImg.size.height/self.editView.frame.size.height;

    CGFloat newImgPixelWidth = sqrt(imgPixelWidth*imgPixelWidth + imgPixelHeight*imgPixelHeight);

    CGRect newRect = CGRectMake(imgPixelCenter.x-newImgPixelWidth/2, imgPixelCenter.y-newImgPixelWidth/2, newImgPixelWidth, newImgPixelWidth);

    [newPasterImage drawInRect:newRect];
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();

    return newImage;
}


- (UIImage *)imageWithPaster:(XTPasterView *)pasterView{
//    CGRect rect = CGRectMake(0, 0, srcImg.size.height,srcImg.size.width);
    CGImageRef subImageRef = pasterView.imagePaster.CGImage;
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

- (UIImage *)imageFromPaster:(XTPasterView *)pasterView{
    /** 取图片矩形位置生成新图片*/
    CGImageRef subImageRef = self.editView.sourceImg.CGImage;
    CGFloat subWidth = CGImageGetWidth(subImageRef);
    CGFloat subHeight = CGImageGetHeight(subImageRef);
    
    CGImageRef pasterImageRef = pasterView.imagePaster.CGImage;
    //view中图片的frame
    CGRect pasterViewImageFrame = CGRectMake(pasterView.frame.origin.x+15, pasterView.frame.origin.y+15, pasterView.frame.size.width-15*2, pasterView.frame.size.height-15*2);
    CGRect pasterFame = [self pixlRectFromViewRect:pasterViewImageFrame withScale:subWidth/ScreenWidth];
//    CGAffineTransform transform = pasterView.transform;
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, subWidth, subHeight,CGImageGetBitsPerComponent(subImageRef), 0,CGImageGetColorSpace(subImageRef),CGImageGetBitmapInfo(subImageRef));
//    CGContextConcatCTM(ctx, transform);
    CGContextRotateCTM(ctx, -pasterView.rotateAngel);
    CGContextDrawImage(ctx, pasterFame, pasterImageRef);
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(subImageRef);
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (CGRect)pixlRectFromViewRect:(CGRect)rect withScale:(CGFloat)scale{
    CGFloat width = rect.size.width *scale;
    CGFloat height = rect.size.height*scale;
    return CGRectMake(rect.origin.x*scale, rect.origin.y*scale, width, height);
}
- (void)cancelAction{
    [self removeFromSuperview];
}
@end
