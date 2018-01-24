//
//  pasterSelectView.m
//  tiezhiDemo
//
//  Created by 万 on 2018/1/24.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "pasterSelectView.h"
#import "pasterSelectCell.h"


@interface pasterSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UICollectionView *colleView;
@property (nonatomic,strong) NSMutableArray *pasterPathArray;
@end


@implementation pasterSelectView

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.colleView];
        [self getPasterArray];
        [self.colleView reloadData];
    }
    return self;
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
//        [self.pasterPathArray addObject:pathStr];
        
        
        
        NSArray *imgNameArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathStr error:nil];
        NSMutableArray *imgPathArray = @[].mutableCopy;
        for (NSInteger i=0; i<imgNameArray.count; i++) {
                NSString *imgPath = [pathStr stringByAppendingPathComponent:imgNameArray[i]];
                [imgPathArray addObject:imgPath];
            };
        [self.pasterPathArray addObject:imgPathArray];
    }
}

#pragma mark -
- (void)layoutViews{
    [_colleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
- (NSMutableArray *)pasterPathArray{
    if (!_pasterPathArray) {
        _pasterPathArray = @[].mutableCopy;
    }
    return _pasterPathArray;
}
- (UICollectionView *)colleView{
    if (!_colleView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //        layout.itemSize = CGSizeMake(40, 40);
        //        layout.minimumLineSpacing = 20;
        //        layout.minimumInteritemSpacing = 20;
        
        _colleView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-cameraHeight+65) collectionViewLayout:layout];
        _colleView.backgroundColor = [UIColor blueColor];
        //        _colleView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _colleView.delegate = self;
        _colleView.dataSource = self;
        _colleView.scrollEnabled = YES;
//        _colleView.showsVerticalScrollIndicator = NO;
        [_colleView registerClass:[pasterSelectCell class] forCellWithReuseIdentifier:NSStringFromClass([pasterSelectCell class])];
    }
    return _colleView;
}

#pragma mark - 代理
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
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 60);
}
#pragma mark - layout代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第 %zd组 第%zd个",indexPath.section, indexPath.row);
}
// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
//列最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

@end
