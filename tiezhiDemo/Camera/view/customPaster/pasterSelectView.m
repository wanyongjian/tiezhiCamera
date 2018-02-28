//
//  pasterSelectView.m
//  tiezhiDemo
//
//  Created by 万 on 2018/1/24.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "pasterSelectView.h"
#import "pasterSelectCell.h"
#define headerId @"headerId"

@interface pasterSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UICollectionView *colleView;
@property (nonatomic,strong) NSMutableArray *pasterPathArray; //二维数组，各模块素材
@property (nonatomic,strong) NSMutableArray *pasterSelectArray; //存放每个素材bool值的二维数组
@property (nonatomic,strong) NSMutableArray *designArray; //设计的素材集合
@end


@implementation pasterSelectView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.colleView];
        [self getDesignedArray];
        [self getPasterArray];
        [self.colleView reloadData];
    }
    return self;
}

- (void)getDesignedArray{
    NSString *str = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"Image.bundle/designItem"]];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:str error:nil];
    [self.designArray removeAllObjects];
    for (NSInteger i=0; i<array.count; i++) {
        NSString *pasterItem = array[i];
        NSString *pathStr = [str stringByAppendingPathComponent:pasterItem];
        [self.designArray addObject:pathStr];
    }
}
- (void)getPasterArray{
    NSString *str = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"Image.bundle/pasterItem"]];
    //文件夹名字数组
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:str error:nil];
    
    //每个文件夹路径数组
    [self.pasterPathArray removeAllObjects];
    for (NSUInteger i=0; i<array.count; i++) {
        NSString *pasterItem = array[i];
        NSString *pathStr = [str stringByAppendingPathComponent:pasterItem];

        NSArray *imgNameArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathStr error:nil];
        NSMutableArray *imgPathArray = @[].mutableCopy;
        NSMutableArray *imgSelectArray = @[].mutableCopy;
        for (NSInteger i=0; i<imgNameArray.count; i++) {
                NSString *imgPath = [pathStr stringByAppendingPathComponent:imgNameArray[i]];
                [imgPathArray addObject:imgPath];
                [imgSelectArray addObject:@(NO)];
            };
        [self.pasterPathArray addObject:imgPathArray];
        [self.pasterSelectArray addObject:imgSelectArray];
    }
}

#pragma mark -
- (void)layoutViews{
    [_colleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
- (NSMutableArray *)designArray{
    if (!_designArray) {
        _designArray = @[].mutableCopy;
    }
    return _designArray;
}
- (NSMutableArray *)pasterPathArray{
    if (!_pasterPathArray) {
        _pasterPathArray = @[].mutableCopy;
    }
    return _pasterPathArray;
}
- (NSMutableArray *)pasterSelectArray{
    if (!_pasterSelectArray) {
        _pasterSelectArray = @[].mutableCopy;
    }
    return _pasterSelectArray;
}
- (UICollectionView *)colleView{
    if (!_colleView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.headerReferenceSize = CGSizeMake(ScreenWidth, .5);
        
        _colleView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-cameraHeight+65) collectionViewLayout:layout];
        [_colleView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        _colleView.backgroundColor = RGB(0xdddcdc, 1);
        _colleView.delegate = self;
        _colleView.dataSource = self;
        _colleView.scrollEnabled = YES;
        [_colleView registerClass:[pasterSelectCell class] forCellWithReuseIdentifier:NSStringFromClass([pasterSelectCell class])];
    }
    return _colleView;
    
}

#pragma mark - 代理
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView* reusableView = nil;
    
    if (kind==UICollectionElementKindSectionHeader) {
        reusableView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId forIndexPath:indexPath];
    }
    if (indexPath.section == 0) {
        reusableView.backgroundColor= [UIColor clearColor];
    }else{
        reusableView.backgroundColor= RGB(0x7c776f, 0.3);
    }
    return reusableView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.pasterPathArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableArray *array = self.pasterPathArray[section];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    pasterSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([pasterSelectCell class]) forIndexPath:indexPath];
    
    NSMutableArray *array = self.pasterPathArray[indexPath.section];
    cell.paterPath = array[indexPath.row];
    //是否被选中
    NSMutableArray *selctArray = self.pasterSelectArray[indexPath.section];
    cell.selected = [selctArray[indexPath.row] boolValue];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(100, 100);
    }
    return CGSizeMake(65, 65);
}
#pragma mark - layout代理方法

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell =  [collectionView cellForItemAtIndexPath:indexPath];
//    cell.selected = NO;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //数据改变
    NSMutableArray *selctArray = self.pasterSelectArray[indexPath.section];
    for (NSInteger i=0; i<selctArray.count; i++) {
        [selctArray replaceObjectAtIndex:i withObject:@(NO)];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:index];
        cell.selected = NO;
    }
    [selctArray replaceObjectAtIndex:indexPath.row withObject:@(YES)];
    pasterSelectCell *cell = (pasterSelectCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    
    
    NSLog(@"点击了第 %zd组 第%zd个",indexPath.section, indexPath.row);
    if (indexPath.section == 0 || indexPath.section == 1) {
        NSString *strPath = self.pasterPathArray[indexPath.section][indexPath.row];
        NSArray *nameArray = [[strPath lastPathComponent] componentsSeparatedByString:@"."];
        NSString *name = nameArray[0]; //图片不包含后缀的名称
        for (NSInteger i=0; i<self.designArray.count; i++) {
            NSString *imgPath = self.designArray[i];
            
            if ([[imgPath lastPathComponent] containsString:name]) {
                if (self.pasterSelectBlock) {
                    self.pasterSelectBlock(imgPath);
                }
            }
        }
        
    }else{
        NSMutableArray *array = self.pasterPathArray[indexPath.section];
        NSString *strPath = array[indexPath.row];
        NSLog(@"路径名称%@",strPath);
        if (self.pasterSelectBlock) {
            self.pasterSelectBlock(strPath);
        }
    }
}
// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
//列最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

@end
