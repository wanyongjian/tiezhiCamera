//
//  CustomPasterView.m
//  tiezhiDemo
//
//  Created by 万 on 2018/1/20.
//  Copyright © 2018年 wan. All rights reserved.
//

#import "CustomPasterView.h"
#import "customPaterCell.h"

@implementation CustomPasterView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.tabelView];
//        [self.tabelView reloadData];
        
        [self layoutViews];
        [self getPasterArray]; //素材分类
    }
    return self;
}

- (void)getPasterArray{
    
}


#pragma mark - talbe 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    customPaterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customPaster"];
    
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
@end
