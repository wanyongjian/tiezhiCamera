//
//  XTPasterView.m
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTPasterView.h"

#define PasterWidth        150.0
#define DeleteBtnWidth_2   15.0
#define DeleteBtnWidth      30.0 //删除按钮宽、高
#define BorderWidth          1.0
#define SECURITY_LENGTH     75.0
#define MinLength (150/2)

@interface XTPasterView ()
{
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGPoint touchStart;
}

@property (nonatomic,strong) UIImageView    *imgContentView ;
@property (nonatomic,strong) UIImageView    *deleteView ;
@property (nonatomic,strong) UIImageView    *resizeView ;
@end


@implementation XTPasterView
#pragma mark -- Initial

- (void)AddToEditView:(PasterEditView *)editView{
     [editView addSubview:self] ;
}

- (instancetype)initWithStageView:(XTPasterStageView *)stageView pasterID:(int)pasterID img:(UIImage *)img
{
    if (self = [super init]){
        self.pasterID = pasterID ;
        self.imagePaster = img ;
        [self setupWithStageFrame:stageView.frame] ;
        [self addSubview:self.imgContentView];
        [self addSubview:self.deleteView];
        [self addSubview:self.resizeView];
        self.onFirstResponder = YES ;
        [stageView addSubview:self] ;
    }
    return self;
}

- (void)setupWithStageFrame:(CGRect)stageFrame{
    self.frame = CGRectMake(0, 0, PasterWidth, PasterWidth) ;
    self.center = CGPointMake(stageFrame.size.width / 2, stageFrame.size.height / 2) ;
    self.backgroundColor = nil ;
    
    //添加轻触手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] ;
    [self addGestureRecognizer:tapGesture] ;
    
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
        if (self.bounds.size.width < MinLength || self.bounds.size.height < MinLength){
            self.bounds = CGRectMake(self.bounds.origin.x,self.bounds.origin.y,MinLength + 1 ,MinLength + 1);
            self.resizeView.frame =CGRectMake(self.bounds.size.width-DeleteBtnWidth,self.bounds.size.height-DeleteBtnWidth,DeleteBtnWidth,DeleteBtnWidth);
            //缩放后的位置
            prevPoint = [recognizer locationInView:self];
        }else{
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0;
            //水平平移的距离
            wChange = (point.x - prevPoint.x);
            CGFloat finalWidth  = self.bounds.size.width + (wChange) ;
            CGFloat finalHeight = self.bounds.size.height + (wChange) ;
            //限制大小为150*0.5 < self < 150*1.5
            if (finalWidth > PasterWidth*(1+1)){
                finalWidth = PasterWidth*(1+1);
            }else if (finalWidth < PasterWidth*(1-0.5)){
                finalWidth = PasterWidth*(1-0.5) ;
            }
            if (finalHeight > PasterWidth*(1+1)){
                finalHeight = PasterWidth*(1+1) ;
            }else if (finalHeight < PasterWidth*(1-0.5)){
                finalHeight = PasterWidth*(1-0.5) ;
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
    self.imgContentView.image = imagePaster ;
}

/** 轻触手势 */
- (void)tap:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"tap paster become first respond") ;
    self.onFirstResponder = YES ;
    if (self.firstResponderBlock) {
        self.firstResponderBlock(self.pasterID);
    }
}

/** 平移 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.onFirstResponder = YES ;
    if (self.firstResponderBlock) {
        self.firstResponderBlock(self.pasterID);
    }
    UITouch *touch = [touches anyObject] ;
    touchStart = [touch locationInView:self.superview] ;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.resizeView.frame, touchLocation)) {
        return;
    }
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch] ;
    touchStart = touch;
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint{
    CGPoint newCenter = CGPointMake(touchPoint.x - touchStart.x + self.center.x,touchPoint.y - touchStart.y +self.center.y) ;
    // Ensure the translation won't cause the view to move offscreen. BEGIN
    CGFloat midPointX = CGRectGetMidX(self.bounds) ;
    if (newCenter.x > self.superview.bounds.size.width - midPointX)
    {
        newCenter.x = self.superview.bounds.size.width - midPointX;
    }
    if (newCenter.x < midPointX )
    {
        newCenter.x = midPointX ;
    }
    
    CGFloat midPointY = CGRectGetMidY(self.bounds);
    if (newCenter.y > self.superview.bounds.size.height - midPointY )
    {
        newCenter.y = self.superview.bounds.size.height - midPointY;
    }
    if (newCenter.y < midPointY )
    {
        newCenter.y = midPointY;
    }
    
    // Ensure the translation won't cause the view to move offscreen. END
    self.center = newCenter;
}



#pragma mark -- Properties
- (void)setOnFirstResponder:(BOOL)onFirstResponder{
   _onFirstResponder = onFirstResponder ;
    self.deleteView.hidden = !onFirstResponder ;
    self.resizeView.hidden = !onFirstResponder ;
    self.imgContentView.layer.borderWidth = onFirstResponder ? BorderWidth : 0.0f ;
}

- (UIImageView *)imgContentView{
    if (!_imgContentView){
        CGFloat sliderContent = PasterWidth - DeleteBtnWidth_2 * 2 ;
        CGRect rect = CGRectMake(DeleteBtnWidth_2, DeleteBtnWidth_2, sliderContent, sliderContent) ;
        
        _imgContentView = [[UIImageView alloc] initWithFrame:rect] ;
        _imgContentView.backgroundColor = nil ;
        _imgContentView.layer.borderColor = [UIColor whiteColor].CGColor ;
        _imgContentView.layer.borderWidth = BorderWidth ;
        _imgContentView.contentMode = UIViewContentModeScaleAspectFit ;
        _imgContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _imgContentView ;
}

- (UIImageView *)resizeView{
    if (!_resizeView){
        _resizeView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - DeleteBtnWidth  ,
                                                                        self.frame.size.height - DeleteBtnWidth ,
                                                                        DeleteBtnWidth ,
                                                                        DeleteBtnWidth)
                            ] ;
        _resizeView.userInteractionEnabled = YES;
        _resizeView.image = Image_Paster(@"resize");

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
                                                    action:@selector(btDeletePressed:)] ;
        [_deleteView addGestureRecognizer:tap] ;
    }
    return _deleteView ;
}

- (void)btDeletePressed:(id)btDel{
    [self remove] ;
}

- (void)remove{
    [self removeFromSuperview] ;
    if (self.removePasterBlock) {
        self.firstResponderBlock(self.pasterID);
    }
}
@end
