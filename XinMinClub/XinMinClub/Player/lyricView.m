//
//  lyricTableView.m
//  player
//
//  Created by 杨科军 on 2016/12/16.
//  Copyright © 2016年 杨科军. All rights reserved.
//

#import "lyricView.h"

@interface lyricView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, copy) UITableView *lyricTableView; /**< 歌词 */

@end

@implementation lyricView

- (void)initView{
    [self addSubview:self.lyricTableView];
}

- (void)setLyricArray:(NSArray *)lyricArray{
    _lyricArray = lyricArray;
    self.lyricLocation = 0;  // 滚动位置清零
}

-(void)setLyricLocation:(NSInteger)lyricLocation{
    _lyricLocation = lyricLocation;
    // 使被选中的行移到中间
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lyricLocation inSection:0];
    [self.lyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self.lyricTableView reloadData];
}

- (UITableView*)lyricTableView{
    if (!_lyricTableView) {
        _lyricTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _lyricTableView.delegate = self;
        _lyricTableView.dataSource = self;
        _lyricTableView.backgroundColor = [UIColor clearColor];
        _lyricTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _lyricTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lyricArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= _lyricArray.count) {
        return 20;
    }
    int line  = [_lyricArray[indexPath.row] length] / 16;
    int remainder = [_lyricArray[indexPath.row] length] % 16;
    if (remainder) {
        line += 1;
    }
//    NSLog(@"******************************************");
//    NSLog(@"%d-----%d",line,remainder);
    if (indexPath.row==0) {
        return line*40;
    }
    return line*22;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    //创建完字体格式之后就告诉cell
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    if (indexPath.row == self.lyricLocation) {
        cell.textLabel.textColor = RGB255_COLOR(116, 79, 0, 1);
    }else{
        cell.textLabel.textColor = RGB255_COLOR(68, 68, 68, 1);
    }
    cell.textLabel.text = _lyricArray[indexPath.row];
    return cell;
}

@end
