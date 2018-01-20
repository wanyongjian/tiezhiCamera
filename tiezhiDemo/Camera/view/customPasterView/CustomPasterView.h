//
//  CustomPasterView.h
//  tiezhiDemo
//
//  Created by 万 on 2018/1/20.
//  Copyright © 2018年 wan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPasterView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tabelView;
@end
