//
//  XTPasterView.m
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTPasterView.h"

#define PasterWidth        (150.0* (self.imagePaster.size.width/300))
#define DeleteBtnWidth_2   15.0
#define DeleteBtnWidth      30.0 //删除按钮宽、高
#define BorderWidth          1.0
#define SECURITY_LENGTH     75.0
#define MinLength (PasterWidth/2)

@interface XTPasterView ()
{
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGPoint lastTouchPoint;
}

@property (nonatomic,strong) UIImageView    *imageView ;
@property (nonatomic,strong) UIImageView    *deleteView ;
@property (nonatomic,strong) UIImageView    *resizeView ;
@property (nonatomic,assign) CGFloat imageRatio;
//@property (nonatomic,assign) NSInteger zPosition;
@end


@implementation XTPasterView
#pragma mark -- Initial

- (void)AddToEditView:(PasterEditView *)editView{
     [editView addSubview:self] ;
}

- (instancetype)initWithStageView:(XTPasterStageView *)stageView pasterID:(int)pasterID imgPath:(NSString *)path pasterType:(pasterType)type
{
    if (self = [super init]){
        self.stageView = stageView;
        
        self.pasterType = type;
        self.pasterID = pasterID ;
        self.imgPath = path;
        self.imagePaster = [UIImage imageWithContentsOfFile:path];
        [self setSelfFrame:stageView.frame pasterType:type] ;
        [self addSubview:self.imageView];
        [self addSubview:self.deleteView];
        [self addSubview:self.resizeView];
        self.onFirstResponder = YES ;
        [stageView addSubview:self] ;
    }
    return self;
}

- (void)setSelfFrame:(CGRect)stageFrame pasterType:(pasterType)type{
    //图片300像素对应150长度,等比缩放
    CGFloat width = PasterWidth ;
    CGFloat height = (PasterWidth-DeleteBtnWidth)*self.imageRatio+DeleteBtnWidth;
    switch (type) {
        case pasterTypeNone:
        case pasterTypeBeard:
        case pasterTypeFace:{
            self.frame = CGRectMake(0, 0, width, height) ;
            self.center = CGPointMake(stageFrame.size.width/2, stageFrame.size.height/2) ;
        }
            break;
        case pasterTypeGlass:{
            self.frame = CGRectMake(0, 0, width, height) ;
            self.center = CGPointMake(stageFrame.size.width/2, stageFrame.size.height/2 - (150 * 82/464)) ;
        }
            break;
        case pasterTypeHelmet:{
            self.frame = CGRectMake(0, 0, width, height) ;
            self.center = CGPointMake(stageFrame.size.width/2, stageFrame.size.height/2-(150*80/464)) ;
        }
            break;
        case pasterTypeHair:{
            self.frame = CGRectMake(0, 0, width, height) ;
            self.center = CGPointMake(stageFrame.size.width/2, stageFrame.size.height/2-(ScreenWidth/2/2+50)+height/2) ;
        }
            break;
        case pasterTypeMouse:{
            self.frame = CGRectMake(0, 0, width, height) ;
            self.center = CGPointMake(stageFrame.size.width/2-width/2, stageFrame.size.height/2+height/2) ;
        }
            break;
        case pasterTypeMouth:{
            self.frame = CGRectMake(0, 0, width, height) ;
            self.center = CGPointMake(stageFrame.size.width/2, stageFrame.size.height/2+(ScreenWidth/2*43/464)) ;
        }
            break;
        case pasterTypeHat: {
            self.frame = CGRectMake(0, 0, width, height) ;
            self.center = CGPointMake(stageFrame.size.width/2, stageFrame.size.height/2-(150 * 140/464)-height/2) ;
            break;
        }
            break;
        case pasterBowtie: { //领结
            self.frame = CGRectMake(0, 0, width, height) ;
            self.center = CGPointMake(stageFrame.size.width/2, stageFrame.size.height/2+150/2) ;
        }
            break;
        case pasterTypeNecklace:{
            self.frame = CGRectMake(0, 0, width, height) ;
            self.center = CGPointMake(stageFrame.size.width / 2, stageFrame.size.height / 2+(150*100/464+height/2)) ;
        }
            break;
        case pasterTypeWingLeft:{   //左边翅膀
            self.frame = CGRectMake(0, 0, width, height) ;
            self.center = CGPointMake(stageFrame.size.width / 2-ScreenWidth/4, stageFrame.size.height / 2+height/2) ;
        }
            break;
        case pasterTypeWingRight:{  //右边翅膀
            self.frame = CGRectMake(0, 0, width, height) ;
            self.center = CGPointMake(stageFrame.size.width / 2+ScreenWidth/4, stageFrame.size.height / 2+height/2) ;
        }
            break;
    }
    
//    self.backgroundColor = nil ;
    
    //添加轻触手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] ;
    [self addGestureRecognizer:tapGesture] ;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:panGesture];
    
    self.userInteractionEnabled = YES ;
    //刚创建时tan角度值
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x) ;
}


/** 旋转、放大 **/
- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer{
    if ([recognizer state] == UIGestureRecognizerStateBegan){
        //缩放前的点
        prevPoint = [recognizer locationInView:self];
    }else if([recognizer state] == UIGestureRecognizerStateChanged){
        // 限制缩小的范围 最小75像素
        if (self.bounds.size.width < MinLength){
            self.bounds = CGRectMake(self.bounds.origin.x,self.bounds.origin.y,MinLength + 1 ,MinLength*self.imageRatio + 1);
            self.resizeView.frame =CGRectMake(self.bounds.size.width-DeleteBtnWidth,self.bounds.size.height-DeleteBtnWidth,DeleteBtnWidth,DeleteBtnWidth);
            //缩放后的位置
            prevPoint = [recognizer locationInView:self];
        }else{
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0;
            //水平平移的距离
            wChange = (point.x - prevPoint.x);
            CGFloat finalWidth  = self.bounds.size.width + (wChange) ;
            
            CGFloat finalHeight = self.bounds.size.height *(1+wChange/self.bounds.size.width) ;
            //限制大小为150*0.5 < self < 150*1.5
            if (finalWidth > PasterWidth*(1+1)){
                finalWidth = PasterWidth*(1+1);
            }else if (finalWidth < PasterWidth*(1-0.5)){
                finalWidth = PasterWidth*(1-0.5) ;
            }
            CGFloat radio = self.imagePaster.size.height/self.imagePaster.size.width;
            if (finalHeight > PasterWidth*radio*(1+1)){
                finalHeight = PasterWidth*radio*(1+1) ;
            }else if (finalHeight < PasterWidth*radio*(1-0.5)){
                finalHeight = PasterWidth*radio*(1-0.5) ;
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x,self.bounds.origin.y,finalWidth,finalHeight) ;
            self.resizeView.frame = CGRectMake(self.bounds.size.width-DeleteBtnWidth,self.bounds.size.height-DeleteBtnWidth ,DeleteBtnWidth ,DeleteBtnWidth) ;
            prevPoint = [recognizer locationInView:self];
        }
        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x) ;
        /** 旋转的角度值*/
        self.rotateAngel = ang-deltaAngle   ;
        self.transform = CGAffineTransformMakeRotation(self.rotateAngel) ;
        NSLog(@"---- %@",NSStringFromCGRect(self.frame));
    }else if ([recognizer state] == UIGestureRecognizerStateEnded){
        prevPoint = [recognizer locationInView:self];
    }
}

- (void)setImagePaster:(UIImage *)imagePaster{
    _imagePaster = imagePaster ;
    self.imageRatio = self.imagePaster.size.height/self.imagePaster.size.width;
    self.imageView.image = imagePaster ;
}

/** 轻触手势 */
- (void)tap:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"tap paster become first respond") ;
    self.onFirstResponder = YES ;
    if (self.firstResponderBlock) {
        self.firstResponderBlock(self.pasterID);
    }
}

- (void)panAction:(UIPanGestureRecognizer *)panGesture{
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始移动");
    }
    //获取拖拽手势在self.view 的拖拽姿态
    CGPoint translation = [panGesture translationInView:self.stageView];
    CGPoint newCenter = CGPointMake(panGesture.view.center.x + translation.x, panGesture.view.center.y + translation.y);;
    if (newCenter.x > self.superview.bounds.size.width){
        newCenter.x = self.superview.bounds.size.width;
    }
    if (newCenter.x < 0 ){
        newCenter.x = 0 ;
    }

//    CGFloat midPointY = CGRectGetMidY(self.bounds);
    if (newCenter.y > self.superview.bounds.size.height  ){
        newCenter.y = self.superview.bounds.size.height;
    }
    if (newCenter.y < 0 ){
        newCenter.y = 0;
    }
    
    //改变panGestureRecognizer.view的中心点 就是self.imageView的中心点
    panGesture.view.center = newCenter;
    //重置拖拽手势的姿态
    [panGesture setTranslation:CGPointZero inView:self.stageView];
}

#pragma mark -- Properties
- (void)setOnFirstResponder:(BOOL)onFirstResponder{
   _onFirstResponder = onFirstResponder ;
    self.deleteView.hidden = !onFirstResponder ;
    self.resizeView.hidden = !onFirstResponder ;
    self.imageView.layer.borderWidth = onFirstResponder ? BorderWidth : 0.0f ;
    
    if (onFirstResponder == YES) {
        NSInteger zposition = [[[NSUserDefaults standardUserDefaults] objectForKey:ZPosition] integerValue];
        self.layer.zPosition = zposition++;

        [[NSUserDefaults standardUserDefaults] setObject:@(zposition) forKey:ZPosition];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (UIImageView *)imageView{
    if (!_imageView){
        CGFloat sliderContent = PasterWidth - DeleteBtnWidth;
        CGFloat sliderContentHeight = sliderContent*self.imageRatio;
        
        CGRect rect = CGRectMake(DeleteBtnWidth_2, DeleteBtnWidth_2, sliderContent, sliderContentHeight) ;
        
        _imageView = [[UIImageView alloc] initWithFrame:rect] ;
        _imageView.backgroundColor = nil ;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor ;
        _imageView.layer.borderWidth = BorderWidth ;
        _imageView.contentMode = UIViewContentModeScaleAspectFit ;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _imageView ;
}

- (UIImageView *)resizeView{
    if (!_resizeView){
        _resizeView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - DeleteBtnWidth  ,
                                                                        self.frame.size.height - DeleteBtnWidth ,
                                                                        DeleteBtnWidth ,
                                                                        DeleteBtnWidth)
                            ] ;
        _resizeView.userInteractionEnabled = YES;
        _resizeView.image = Image_Paster(@"resize1");

        UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(resizeTranslate:)] ;
        [_resizeView addGestureRecognizer:panResizeGesture] ;
    }
    return _resizeView ;
}

- (UIImageView *)deleteView{
    if (!_deleteView){
        _deleteView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeleteBtnWidth, DeleteBtnWidth)] ;
        _deleteView.userInteractionEnabled = YES;
        _deleteView.image = Image_Paster(@"delete");
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(deleteAction:)] ;
        [_deleteView addGestureRecognizer:tap] ;
    }
    return _deleteView ;
}

- (void)deleteAction:(id)btDel{
    [self remove] ;
}

- (void)remove{
    [self removeFromSuperview] ;
    if (self.removePasterBlock) {
        self.removePasterBlock(self.pasterID);
    }
}
@end
