//
//  KJ_BookCell2.m
//  XinMinClub
//
//  Created by 杨科军 on 16/5/23.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "KJ_BookCell2.h"

@interface KJ_BookCell2()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *kj_tableView;

@end

@implementation KJ_BookCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

#pragma mark 滚动的时候
- (void)setKj_toTop:(BOOL)kj_toTop{
    if (kj_toTop) {
        self.kj_tableView.scrollEnabled = YES;
    }else
        self.kj_tableView.scrollEnabled = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.bounds.origin.y <= 0){
        self.kj_selfToTop = YES;
        self.kj_tableView.scrollEnabled = NO;
    }
}

#pragma mark 传递过来的数据
- (void)setKj_typeArray:(NSArray *)kj_typeArray{
    _kj_typeArray=kj_typeArray;
}
- (void)setKj_dataDict:(NSDictionary *)kj_dataDict{
    if (_kj_typeArray.count==kj_dataDict.count&&_kj_typeArray.count!=0) {
        [self addSubview:self.kj_tableView];
    }
}

- (UITableView *)kj_tableView{
    if (!_kj_tableView) {
        _kj_tableView = [[UITableView alloc]initWithFrame:self.bounds  style:UITableViewStylePlain];
        _kj_tableView.delegate = self; // 设置tableView的委托
        _kj_tableView.dataSource = self; // 设置tableView的数据源
    }
    return _kj_tableView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _kj_typeArray.count+10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return SCREEN_HEIGHT/4;
    }
    if (indexPath.section==1) {
        return SCREEN_HEIGHT/2;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"xx"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"xx"];
    }
    cell.textLabel.text=@"测试CELL";
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor=[UIColor blueColor];
    
    return view;
}


@end

