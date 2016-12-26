//
//  ForthTableViewCell.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/25.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ForthTableViewCell.h"

@interface ForthTableViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *remindView;
@end

@implementation ForthTableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
//        _recommencArray = [NSArray arrayWithObjects:@"天龙八部",@"倚天屠龙记",@"我与媳妇的幸福生活",@"住在海边的淡水鱼",@"我活着就是罪",@"天龙七部",@"我不喜欢你", nil];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    cell.textLabel.text = ((BookData *)_recommencArray[indexPath.row]).bookName;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _remindView.hidden = YES;
    if (!_recommencArray.count) {
        _remindView.hidden = NO;
    }
    return _recommencArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate recommendTable:tableView didSelectRowAtIndexPath:indexPath];
}

@end
