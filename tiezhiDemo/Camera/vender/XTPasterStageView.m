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

@property (nonatomic,strong) UIButton       *bgButton ;
//@property (nonatomic,strong) UIImageView    *imgView ;
@property (nonatomic,strong) XTPasterView   *pasterCurrent ;
@property (nonatomic,assign) int newPasterID ;
@property (nonatomic,strong) UIImageView *dogModelImg;
@end


@implementation XTPasterStageView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
//        [self addSubview:self.imgView];
        [self addSubview:self.bgButton];
        [self addSubview:self.dogModelImg];
        [self layoutViews];
    }
    return self;
}


- (void)tapTwoAction{
    if (self.hideMoreBlock) {
        self.hideMoreBlock();
    }
}

- (void)layoutViews{
    [_dogModelImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.height.mas_equalTo(375/2);
    }];
}

- (UIImageView *)dogModelImg{
    if (!_dogModelImg) {
        _dogModelImg = [[UIImageView alloc]initWithImage:Image_Paster(@"最终素材8")];
    }
    return _dogModelImg;
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
//- (void)setOriginImage:(UIImage *)originImage{
//    _originImage = originImage ;
//    self.imgView.image = originImage ;
//}

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
        
        UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTwoAction)];
        [_bgButton addGestureRecognizer:tapTwo];
        tapTwo.numberOfTapsRequired = 2;
        
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundClicked)];
        [_bgButton addGestureRecognizer:tapOne];
        tapOne.numberOfTapsRequired = 1;
    }
    return _bgButton ;
}

//- (UIImageView *)imgView{
//    if (!_imgView){
//        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ( self.frame.size.height - self.frame.size.width ) / 2.0, self.frame.size.width,self.frame.size.width)] ;
//        _imgView.contentMode = UIViewContentModeScaleAspectFit ;
//    }
//
//    return _imgView ;
//}

#pragma mark - public
- (void)addPasterWithImgPath:(NSString *)path{
    // 名字相同不加
    for (NSInteger i=0; i<self.pasterArray.count; i++) {
        XTPasterView *paster = self.pasterArray[i];
        if ([paster.imgPath isEqualToString:path]) {
            return;
        }
    }

    //所属组
    NSString *imgName = [path lastPathComponent];
    pasterType type = pasterTypeNone;
    
    if ([imgName containsString:@"glass"]) {
        type = pasterTypeGlass;
    }else if ([imgName containsString:@"hat"]){
        type = pasterTypeHat;
    }else if ([imgName containsString:@"helmet"]){
        type = pasterTypeHelmet;
    }else if ([imgName containsString:@"hair"]){
        type = pasterTypeHair;
    }else if ([imgName containsString:@"mouse"]){
        type = pasterTypeMouse;
    }else if ([imgName containsString:@"face"]){
        type = pasterTypeFace;
    }else if ([imgName containsString:@"mouth"]){
        type = pasterTypeMouth;
    }else if ([imgName containsString:@"bowtie"]){ //脖子上领结
        type = pasterBowtie;
    }else if ([imgName containsString:@"necklace"]){
        type = pasterTypeNecklace;
    }else if ([imgName containsString:@"left"]){
        type = pasterTypeWingLeft;
    }else if ([imgName containsString:@"right"]){
        type = pasterTypeWingRight;
    }else if ([imgName containsString:@"beard"]){
        type = pasterTypeBeard;
    }
    
    //同一组的则删除原有的
    [self.pasterArray enumerateObjectsUsingBlock:^(XTPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pasterV.pasterType == type){
            [pasterV remove];
            [self.pasterArray removeObject:pasterV];
        }
    }] ;
    
    [self clearFirstRespondState] ;
    XTPasterView *pasterView = [[XTPasterView alloc] initWithStageView:self
                                                              pasterID:self.newPasterID
                                                                   imgPath:path pasterType:type] ;
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

//- (UIImage *)doneEdit{
//    [self clearFirstRespondState] ;
//    CGFloat org_width = self.originImage.size.width ;
//    CGFloat org_heigh = self.originImage.size.height ;
//    CGFloat rateOfScreen = org_width / org_heigh ;
//    CGFloat inScreenH = self.frame.size.width / rateOfScreen ;
//    
//    CGRect rect = CGRectZero ;
//    rect.size = CGSizeMake(APPFRAME.size.width, inScreenH) ;
//    rect.origin = CGPointMake(0, (self.frame.size.height - inScreenH) / 2) ;
//    
//    UIImage *imgTemp = [UIImage getImageFromView:self] ;
//    UIImage *imgCut = [UIImage squareImageFromImage:imgTemp scaledToSize:rect.size.width] ;
//    return imgCut ;
//}

- (void)backgroundClicked{
    [self clearFirstRespondState] ;
}

- (void)clearFirstRespondState{
    [self.pasterArray enumerateObjectsUsingBlock:^(XTPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
         pasterV.onFirstResponder = NO ;
    }] ;
}

@end

