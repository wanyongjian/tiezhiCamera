//
//  XTPasterStageView.m
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//
#import "XTPasterStageView.h"
#import "XTPasterView.h"
#import "UIImage+AddFunction.h"
#import "PasterItemView.h"
#define APPFRAME    [UIScreen mainScreen].bounds
static NSInteger Height = 65;
static NSInteger ImgInset = 5;
@interface XTPasterStageView ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *imgNameArray;
@property (nonatomic,strong) UIButton       *bgButton ;
@property (nonatomic,strong) UIImageView    *imgView ;
@property (nonatomic,strong) XTPasterView   *pasterCurrent ;
@property (nonatomic)        int            newPasterID ;
@end


@implementation XTPasterStageView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self addSubview:self.imgView];
        [self addSubview:self.bgButton];
       
//        [self addSubview:self.scrollView];
        [self layoutViews];
    }
    return self;
}


- (void)layoutViews{

    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(Height);
        make.left.mas_equalTo(self).offset(2);
//        make.right.mas_equalTo(_moreBtn.mas_left).offset(-2);
        make.bottom.mas_equalTo(self).offset(-5);
    }];
}


- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.layer.cornerRadius = 10;
        _scrollView.layer.masksToBounds = YES;
        _scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        _scrollView.pagingEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(self.imgNameArray.count*(Height+ImgInset), Height);
        
        for (NSInteger i=0; i<self.imgNameArray.count; i++) {
            PasterItemView *view = [[PasterItemView alloc]initWithFrame:CGRectMake(i*(Height+ImgInset), 0, Height, Height)];
            view.imgName = self.imgNameArray[i];
            [_scrollView addSubview:view];
            view.pasterSelectBlock = ^(NSString *imgName) {
                NSLog(@"选中。。。。。%@",imgName);
//                [self addPaterName:self.imgNameArray[i]];
                [self addPasterWithImg:Image_Paster(imgName)];
            };
            
        }
    }
    return _scrollView;
}
- (NSMutableArray *)pasterArray{
    if (!_pasterArray) {
        _pasterArray = [[NSMutableArray alloc]init];
    }
    return _pasterArray;
}
- (void)resetPaster{
    [self.pasterArray removeAllObjects];
}
- (NSMutableArray *)imgNameArray{
    if (!_imgNameArray) {
        _imgNameArray = @[@"暴徒项链.png",@"暴徒烟.png",@"暴徒眼镜.png",@"helmet1.png",@"helmet1.png",@"helmet1.png",@"helmet1.png",@"helmet1.png",@"helmet1.png",@"helmet1.png"].mutableCopy;
    }
    return _imgNameArray;
}
- (void)setOriginImage:(UIImage *)originImage{
    _originImage = originImage ;
    self.imgView.image = originImage ;
}

- (int)newPasterID{
    _newPasterID++ ;
    return _newPasterID ;
}

- (void)setPasterCurrent:(XTPasterView *)pasterCurrent{
    _pasterCurrent = pasterCurrent ;
    [self bringSubviewToFront:_pasterCurrent] ;
}

- (UIButton *)bgButton{
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] initWithFrame:self.frame] ;
        _bgButton.tintColor = nil ;
        _bgButton.backgroundColor = nil ;
        [_bgButton addTarget:self action:@selector(backgroundClicked:) forControlEvents:UIControlEventTouchUpInside] ;
    }
    return _bgButton ;
}

- (UIImageView *)imgView{
    if (!_imgView){
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ( self.frame.size.height - self.frame.size.width ) / 2.0, self.frame.size.width,self.frame.size.width)] ;
        _imgView.contentMode = UIViewContentModeScaleAspectFit ;
    }
    
    return _imgView ;
}

#pragma mark - public
- (void)addPasterWithImg:(UIImage *)imgP{
    [self clearFirstRespondState] ;
    XTPasterView *pasterView = [[XTPasterView alloc] initWithStageView:self
                                                              pasterID:self.newPasterID
                                                                   img:imgP] ;
    pasterView.firstResponderBlock = ^(int pasterID) {
        [self.pasterArray enumerateObjectsUsingBlock:^(XTPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
            if (pasterV.pasterID == pasterID){
                self.pasterCurrent = pasterV ;
                pasterV.onFirstResponder = YES ;
            }else{
                pasterV.onFirstResponder = NO;
            }
        }] ;
    };
    pasterView.removePasterBlock = ^(int pasterID) {
        [self.pasterArray enumerateObjectsUsingBlock:^(XTPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
            if (pasterV.pasterID == pasterID){
                [self.pasterArray removeObjectAtIndex:idx] ;
                *stop = YES ;
            }
        }] ;
    };
    [self.pasterArray addObject:pasterView] ;
    self.pasterCurrent = pasterView;
}

- (UIImage *)doneEdit{
    [self clearFirstRespondState] ;
    CGFloat org_width = self.originImage.size.width ;
    CGFloat org_heigh = self.originImage.size.height ;
    CGFloat rateOfScreen = org_width / org_heigh ;
    CGFloat inScreenH = self.frame.size.width / rateOfScreen ;
    
    CGRect rect = CGRectZero ;
    rect.size = CGSizeMake(APPFRAME.size.width, inScreenH) ;
    rect.origin = CGPointMake(0, (self.frame.size.height - inScreenH) / 2) ;
    
    UIImage *imgTemp = [UIImage getImageFromView:self] ;
    UIImage *imgCut = [UIImage squareImageFromImage:imgTemp scaledToSize:rect.size.width] ;
    return imgCut ;
}

- (void)backgroundClicked:(UIButton *)btBg{
    [self clearFirstRespondState] ;
}

- (void)clearFirstRespondState{
    [self.pasterArray enumerateObjectsUsingBlock:^(XTPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
         pasterV.onFirstResponder = NO ;
    }] ;
}

@end

