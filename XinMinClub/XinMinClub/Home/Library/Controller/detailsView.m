//
//  detailsView.m
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/21.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "detailsView.h"
#import "DetailsCell1.h"
#import "DetailsCell2.h"
#import "DetailsCell4.h"

@interface detailsView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSDictionary *jsonData;
    NSArray *dataArray;
    NSArray *commentArray;
    NSArray *nameArray;
    NSArray *imgArray;
    NSArray *timeArray;
}

@property(nonatomic,copy) UITableView *tableView;


@end

@implementation detailsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
        
        commentArray = [NSArray array];
        nameArray = [NSArray array];
        imgArray = [NSArray array];
        timeArray = [NSArray array];
        
        // 注册cell
        UINib *de1 = [UINib nibWithNibName:@"DetailsCell1" bundle:nil];
        [self.tableView registerNib:de1 forCellReuseIdentifier:@"detailsCell1"];
        UINib *de2 = [UINib nibWithNibName:@"DetailsCell2" bundle:nil];
        [self.tableView registerNib:de2 forCellReuseIdentifier:@"detailsCell2"];
        UINib *de4 = [UINib nibWithNibName:@"DetailsCell4" bundle:nil];
        [self.tableView registerNib:de4 forCellReuseIdentifier:@"detailsCell4"];
//        DATA_MODEL.isVisitorLoad;
        [USER_DATA_MODEL getUserComment:_bookID];
        [USER_DATA_MODEL addObserver:self forKeyPath:@"comment" options:NSKeyValueObservingOptionNew context:nil];
        
//        [[UIApplication sharedApplication].keyWindow addSubview:self.kj_backView];
        self.kj_backView.hidden = YES;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"comment"]) {
        [self loadComment];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)loadComment {
    NSLog(@"%@", USER_DATA_MODEL.comment);
    NSDictionary *dic = [[USER_DATA_MODEL.comment objectForKey:@"RET"] objectForKey:@"SYS_GX_WJ_PL"];
    NSMutableArray * arr = [NSMutableArray  arrayWithCapacity:10];
    NSMutableArray * arr1 = [NSMutableArray  arrayWithCapacity:10];
    NSMutableArray * arr2 = [NSMutableArray  arrayWithCapacity:10];
    NSMutableArray * arr3 = [NSMutableArray  arrayWithCapacity:10];
    for (NSDictionary *d in dic) {
        [arr addObject:[d objectForKey:@"PL_WJ_CONTENT"]];
        [arr1 addObject:[d objectForKey:@"USER_NAME"]];
        [arr2 addObject:[d objectForKey:@"USER_IMG"]];
        [arr3 addObject:[d objectForKey:@"PL_OPS_TIME"]];
    }
    commentArray = [NSArray arrayWithArray:arr];
    nameArray = [NSArray arrayWithArray:arr1];
    timeArray = [NSArray arrayWithArray:arr3];
    imgArray = [NSArray arrayWithArray:arr2];
}

- (void)setIsTopView:(BOOL)isTopView{
    NSLog(@"detailsTop:%d",isTopView);
    if (isTopView) {
        self.kj_backView.hidden = NO;
    }else{
        self.kj_backView.hidden = YES;
    }
}

- (void)giveMeJson:(NSDictionary*)json{
    jsonData = json;
    dataArray = @[[jsonData valueForKey:@"WJ_USER"],[jsonData valueForKey:@"WJ_TYPE"],[jsonData valueForKey:@"WJ_LANGUAGE"],[jsonData valueForKey:@"WJ_CONTENT"]];
    [self.tableView reloadData];
}

- (NSArray *)textArray{
    return @[@"作者",@"分类",@"语言",@"简介"];
}

#pragma mark Subviews
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (UIView*)kj_backView{
    if (!_kj_backView) {
        _kj_backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _kj_backView.backgroundColor = [UIColor grayColor];
    }
    return _kj_backView;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"%f",scrollView.bounds.origin.y);
    self.detailsScroll = scrollView.bounds.origin.y;
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.textArray.count+1;
    }
    return commentArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if(indexPath.row == 0){
            return 80;
        }
        if(indexPath.row == self.textArray.count){
            return UITableViewAutomaticDimension;
        }
        return 50;
    } else {
        if (indexPath.row == commentArray.count + 1) {
            return 49;
        }
    }
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section==0&&indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell4" forIndexPath:indexPath];
        ((DetailsCell4*)cell).imageUrl = [NSString stringWithFormat:@"%@%@",IP,[jsonData valueForKey:@"WJ_TITLE_IMG"]];
        ((DetailsCell4*)cell).libraryName = [jsonData valueForKey:@"WJ_NAME"];

        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
    if (indexPath.section==0&&indexPath.row>0){
        DetailsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell1" forIndexPath:indexPath];
        cell.details1Text = self.textArray[indexPath.row-1];
        cell.details1Title = dataArray[indexPath.row-1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell2" forIndexPath:indexPath];
//        commentData = commentArray[indexPath.row];
    if (indexPath.row == commentArray.count + 1) {
        ((DetailsCell2*)cell).details2Title = @"dsfafds";
    }
    if (commentArray.count && commentArray.count > indexPath.row) {
        if (![imgArray[indexPath.row] isKindOfClass:[NSNull class]]) {
            ((DetailsCell2*)cell).detailsImageUrl = imgArray[indexPath.row];
        }
        if (![commentArray[indexPath.row] isKindOfClass:[NSNull class]]) {
            ((DetailsCell2*)cell).details2Title = commentArray[indexPath.row];
        }
        if (![timeArray[indexPath.row] isKindOfClass:[NSNull class]]) {
            ((DetailsCell2*)cell).details2Time = timeArray[indexPath.row];
        }
        if (![nameArray[indexPath.row] isKindOfClass:[NSNull class]]) {
            ((DetailsCell2*)cell).details2Text = nameArray[indexPath.row];
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 60;
    }
    return 0.1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *aView = [UIView new];
    if (section == 1) {
        aView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
        aView.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
        UILabel *aaa = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 30)];
        aaa.text = @"用户评价";
        
        [aView addSubview:aaa];
    }
    
    return aView;
}


@end
