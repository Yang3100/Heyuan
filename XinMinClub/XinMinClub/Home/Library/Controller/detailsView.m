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
}

@property(nonatomic,copy) UITableView *tableView;

@end

@implementation detailsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
        
        // 注册cell
        UINib *de1 = [UINib nibWithNibName:@"DetailsCell1" bundle:nil];
        [self.tableView registerNib:de1 forCellReuseIdentifier:@"detailsCell1"];
        UINib *de2 = [UINib nibWithNibName:@"DetailsCell2" bundle:nil];
        [self.tableView registerNib:de2 forCellReuseIdentifier:@"detailsCell2"];
        UINib *de4 = [UINib nibWithNibName:@"DetailsCell4" bundle:nil];
        [self.tableView registerNib:de4 forCellReuseIdentifier:@"detailsCell4"];
//        DATA_MODEL.isVisitorLoad;
        [USER_DATA_MODEL getUserComment:_bookID];
    }
    return self;
}

- (void)setIsTopView:(BOOL)isTopView{
    NSLog(@"detailsTop:%d",isTopView);
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

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"%f",scrollView.bounds.origin.y);
    self.detailsScroll = scrollView.bounds.origin.y;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate){
        dispatch_async(dispatch_get_main_queue(), ^{
            printf("STOP IT!!\n");
            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
        });
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.textArray.count+1;
    }
    return 20;
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
    }
    return 80;
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
//        ((DetailsCell2*)cell).detailsImageUrl = commentData.commentImageUrl;
        ((DetailsCell2*)cell).details2Title = @"23412412fsfdvs123efdcr132dedf3er43edct4rfefd34qfrtrgrrehrtuyehorwwo8q34ruotuwi3ryoghiw4yoruiwo3pjaewiurwhrbktiwhkursihriju";
//        ((DetailsCell2*)cell).details2Time = commentData.commentTime;
//        ((DetailsCell2*)cell).details2Title = commentData.commentText;
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
