//
//  CustomPasterView.m
//  tiezhiDemo
//
//  Created by 万 on 2018/1/20.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "CustomPasterView.h"
#import "customPaterCell.h"
@interface CustomPasterView ()
@property (nonatomic,strong) NSMutableArray *pasterPathArray;
@end

@implementation CustomPasterView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.tabelView];
//        [self.tabelView reloadData];
        
        [self layoutViews];
        [self getPasterArray]; //素材分类
        [self.tabelView reloadData];
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
        [self.pasterPathArray addObject:pathStr];
    }
    
}


#pragma mark - talbe 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pasterPathArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    customPaterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customPaster"];
    if (self.pasterPathArray.count >0) {
//        NSString *str = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"Image.bundle/pasterItem"]];
//        NSString *path = [str stringByAppendingPathComponent:self.pasterPathArray[indexPath.row]];
//        cell.pathPrefix = path;
        
//        NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.pasterPathArray[indexPath.row] error:nil];
        cell.pathPrefix = self.pasterPathArray[indexPath.row];
        
        
    }
    return cell;
}

- (void)layoutViews{
    [_tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (UITableView *)tabelView{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]init];
        [_tabelView registerClass:NSClassFromString(@"customPaterCell") forCellReuseIdentifier:@"customPaster"];
        _tabelView.dataSource = self;
        _tabelView.delegate = self;
    }
    return _tabelView;
}

- (NSMutableArray *)pasterPathArray{
    if (!_pasterPathArray) {
        _pasterPathArray = @[].mutableCopy;
    }
    return _pasterPathArray;
}
@end
