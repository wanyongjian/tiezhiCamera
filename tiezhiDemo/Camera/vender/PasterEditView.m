//
//  PasterEditView.m
//  tiezhiDemo
//
//  Created by 万 on 2018/1/14.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "PasterEditView.h"
#import "XTPasterView.h"

@interface PasterEditView ()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIButton       *bgButton ;
@property (nonatomic,strong) XTPasterView   *pasterCurrent ;
@end

@implementation PasterEditView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imgView];
        self.imgView.frame = frame;
        [self addSubview:self.bgButton];
        self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)setSourceImg:(UIImage *)sourceImg{
    _sourceImg = sourceImg;
    self.imgView.image = sourceImg;
}

- (void)setPasterCurrent:(XTPasterView *)pasterCurrent{
    _pasterCurrent = pasterCurrent ;
    [self bringSubviewToFront:_pasterCurrent] ;
}

- (void)setPasterArray:(NSMutableArray *)pasterArray{
    _pasterArray = pasterArray;
    [self.pasterArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XTPasterView *view = obj;
        [self addPasterToEditView:view];
    }];
}

- (void)addPasterToEditView:(XTPasterView *)paster{
    [self clearFirstRespondState] ;
    [paster AddToEditView:self];
    paster.firstResponderBlock = ^(int pasterID) {
        [self.pasterArray enumerateObjectsUsingBlock:^(XTPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
            if (pasterV.pasterID == pasterID){
                self.pasterCurrent = pasterV ;
                pasterV.onFirstResponder = YES ;
            }else{
                pasterV.onFirstResponder = NO;
            }
        }] ;
    };
    paster.removePasterBlock = ^(int pasterID) {
        [self.pasterArray enumerateObjectsUsingBlock:^(XTPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
            if (pasterV.pasterID == pasterID){
                [self.pasterArray removeObjectAtIndex:idx] ;
                *stop = YES ;
            }
        }] ;
    };
}

- (void)clearFirstRespondState{
    [self.pasterArray enumerateObjectsUsingBlock:^(XTPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        pasterV.onFirstResponder = NO ;
    }] ;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
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
- (void)backgroundClicked:(UIButton *)btBg{
    [self clearFirstRespondState] ;
}
@end
