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
    self.lyricLocation = 0;
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
    NSLog(@"******************************************");
    NSLog(@"%luxxxx%d", (unsigned long)[_lyricArray[indexPath.row] length],foo1q([_lyricArray[indexPath.row] cStringUsingEncoding:NSUTF8StringEncoding]));
    NSLog(@"******************************************");
    NSInteger lyricLength = (((foo1q([_lyricArray[indexPath.row] cStringUsingEncoding:NSUTF8StringEncoding])*6)/self.lyricTableView.bounds.size.width)*44);
    return lyricLength;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0.603 alpha:0];
    //创建完字体格式之后就告诉cell
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 0;
   
    if (indexPath.row == self.lyricLocation) {
        cell.textLabel.textColor = RGB255_COLOR(116, 79, 0, 1);
    }else{
        cell.textLabel.textColor = RGB255_COLOR(68, 68, 68, 1);
    }
//    if (indexPath.row<_lyricArray.count) {
        cell.textLabel.text = _lyricArray[indexPath.row];
//    }
    return cell;
}
// 判断字符串长度
int foo1q(const char *p){
    if (*p == '\0')
        return 0;
    else
        return foo1q(p + 1) + 1;
}


@end
