//
//  Help.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/11.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "Help.h"

@interface Help () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *helpTable;
}

@end

@implementation Help

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"帮助";
    [self.view addSubview:[self helpTable]];
}

- (UITableView *)helpTable{
    if (!helpTable) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(x, y, w, h)  style:UITableViewStyleGrouped];
        tableView.delegate = self; // 设置tableView的委托
        tableView.dataSource = self; // 设置tableView的数据源
        tableView.separatorColor = [UIColor colorWithRed:0.855 green:0.955 blue:0.875 alpha:1.000]; //改变换行线颜色
        helpTable = tableView;
    }
    return helpTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"这里是帮助信息";
    cell.textLabel.textColor = [UIColor redColor];
    return cell;
}

@end
