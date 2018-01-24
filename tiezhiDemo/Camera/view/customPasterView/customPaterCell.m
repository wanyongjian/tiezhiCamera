//
//  customPaterCell.m
//  tiezhiDemo
//
//  Created by 万 on 2018/1/20.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "customPaterCell.h"
#import "PasterItemView.h"

static NSInteger Height = 60;
@interface customPaterCell()

@property (nonatomic,strong) UIScrollView *scrollView;
@end


@implementation customPaterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:self.scrollView];
        
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews{
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setPathPrefix:(NSString *)pathPrefix{
    _pathPrefix = pathPrefix;
    NSArray *imgNameArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathPrefix error:nil];
    
//    self.scrollView = nil;
    self.scrollView.contentSize = CGSizeMake(imgNameArray.count*Height, Height);
//
    for (NSInteger i=0; i<imgNameArray.count; i++) {
        PasterItemView *view = self.pasterArray[i];
        NSString *imgPath = [pathPrefix stringByAppendingPathComponent:imgNameArray[i]];
        view.imgPath = imgPath;
        view.pasterSelectBlock = ^(NSString *imgName) {
            NSLog(@"选中。。。。。%@",imgName);
            //                [self addPaterName:self.imgNameArray[i]];
            //            [self addPasterWithImg:Image_Paster(imgName)];
        };
    }
}

- (NSMutableArray *)pasterArray{
    if (!_pasterArray) {
        _pasterArray = @[].mutableCopy;
    }
    return _pasterArray;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.layer.cornerRadius = 10;
        _scrollView.layer.masksToBounds = YES;
        _scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        _scrollView.pagingEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        NSInteger pasterNumber = 50;
        _scrollView.contentSize = CGSizeMake(pasterNumber*Height, Height);
        
        for (NSInteger i=0; i<pasterNumber; i++) {
            PasterItemView *view = [[PasterItemView alloc]initWithFrame:CGRectMake(i*(Height), 0, Height, Height)];
            //        view.imgName = pasterImgArray[i];

            [_scrollView addSubview:view];
            [self.pasterArray addObject:view];
            view.pasterSelectBlock = ^(NSString *imgName) {
                NSLog(@"选中。。。。。%@",imgName);
                //                [self addPaterName:self.imgNameArray[i]];
                //            [self addPasterWithImg:Image_Paster(imgName)];
            };
        }
        
    }
    return _scrollView;
}
@end
