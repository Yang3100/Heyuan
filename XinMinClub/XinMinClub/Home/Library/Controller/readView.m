//
//  readView.m
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/21.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "readView.h"
#import "ReadCell.h"

#define backButtonViewHeight (([UIScreen mainScreen].bounds.size.height)/18)

@interface readView()<UITableViewDelegate,UITableViewDataSource>{
    BOOL off;
    NSMutableArray *listNumArray;
    NSMutableArray<NSDictionary*> *dataArray;  // 获取到的数据json
    bool isFristDisplay;  // 是否为第一次显示
    int iNum;
    ReadCell *r_cell;
    BOOL MyState;
    

    NSMutableArray<NSDictionary*> *jsonArrayDict; // 获取到的小节数据字典
}

@property (nonatomic,strong) NSArray *kj_readListArray;
@property (nonatomic, strong) UITableView *readTableView;

@end

@implementation readView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        iNum=0;
        off=NO;
        isFristDisplay=NO;
        listNumArray = [NSMutableArray array];
        dataArray = [NSMutableArray array];
        jsonArrayDict = [NSMutableArray array];
        
        UINib *nib = [UINib nibWithNibName:@"ReadCell" bundle:nil];
        [self.readTableView registerNib:nib forCellReuseIdentifier:@"readCell"];
        [self addSubview:self.readTableView];
    }
    return self;
}

- (void)setTypeArray:(NSArray *)typeArray{
    _typeArray = typeArray;
    [self.readTableView reloadData];
}

- (void)setIsTopView:(BOOL)isTopView{
    NSLog(@"readTop:%d",isTopView);
    if (isTopView) {
        if (!isFristDisplay) {
            isFristDisplay=YES;
            [self startNetwork];
        }else{
            NSLog(@"233");
        }
    }
}

- (UITableView *)readTableView{
    if (!_readTableView) {
        _readTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT-backButtonViewHeight)];
        _readTableView.delegate = self;
        _readTableView.dataSource = self;
        // 传递数据
        _readTableView.backgroundColor = [UIColor whiteColor];
    }
    return _readTableView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _typeArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section<listNumArray.count) {
        return [listNumArray[section] integerValue];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    for (NSString *a in clickButtonTag) {
//        if (indexPath.row==[a intValue]) {
//            MyState=YES;
//            return UITableViewAutomaticDimension;
//        }
//    }
       MyState=NO;
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    r_cell = [tableView dequeueReusableCellWithIdentifier:@"readCell" forIndexPath:indexPath];
    r_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section<listNumArray.count) {
        NSDictionary *r_dict = [[dataArray[indexPath.section] valueForKey:@"RET"] valueForKey:@"Sys_GX_ZJ"][indexPath.row];
        if (kStringIsEmpty([r_dict valueForKey:@"GJ_MP3"])) {
            r_cell.isMp3 = YES;
        }
        r_cell.readTitle = [r_dict valueForKey:@"GJ_NAME"];
        r_cell.readText =  [r_dict valueForKey:@"GJ_CONTENT_CN"];
        return r_cell;
    }else
//    r_cell.readNum = indexPath.row;
//    cell.state = MyState;
    
    return r_cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lan = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    lan.backgroundColor=[UIColor colorWithRed:0.7622 green:0.7622 blue:0.7622 alpha:1.0];
    lan.text=[NSString stringWithFormat:@"   %@",_typeArray[section]];
    return lan;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[DataModel defaultDataModel] pushWhereWithJson:jsonArrayDict[indexPath.section] ThouchNum:indexPath.row WithVC:[self viewController] Transfer:2 Data:nil];
}
//  获取当前view所处的viewController重写读方法
- (UIViewController *)viewController{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            // 上面if判断是否为UIViewController的子类
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)startNetwork{
    if (_typeArray.count==0) {
        return;
    }
    [[LoadAnimation defaultDataModel] startLoadAnimation];
    // 后台执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 获取小节列表
        NSDictionary *dict = @{@"GJ_WJ_ID":_bookID, @"GJ_WJ_ZY_TYPE":_typeArray[iNum],@"Page_Index":@"1",@"Page_Count":@"100000"};
        NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_WJ_ZJ_TYPE_DataList", @"Params":dict}];
        [networkSection getJsonDataWithUrlString:IPUrl param:paramString];
    });
    
    //回调函数获取数据
    [networkSection setGetRequestDataClosuresCallBack:^(NSDictionary *json) {
        NSNumber *mapXNum = [[json valueForKey:@"RET"] valueForKey:@"Record_Count"];
        NSInteger myInteger = [mapXNum integerValue];
        [listNumArray addObject:@(myInteger)];
        [jsonArrayDict addObject:json];
        // 主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LoadAnimation defaultDataModel] endLoadAnimation];
            [dataArray addObject:json];
            [self.readTableView reloadData];
            if (off==YES) {
                // 结束刷新
                [self.readTableView.mj_footer endRefreshing];
                off=NO;
            }
        });
    }];
    
    // 下拉刷新
    self.readTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 结束刷新
        [self.readTableView.mj_header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.readTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.readTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        off=YES;
        if (iNum<_typeArray.count-1) {
            iNum ++;
            [[LoadAnimation defaultDataModel] startLoadAnimation];
            // 后台执行
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 获取小节列表
                NSDictionary *dict = @{@"GJ_WJ_ID":_bookID, @"GJ_WJ_ZY_TYPE":_typeArray[iNum],@"Page_Index":@"1",@"Page_Count":@"100000"};
                NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_WJ_ZJ_TYPE_DataList", @"Params":dict}];
                [networkSection getJsonDataWithUrlString:IPUrl param:paramString];
            });
        }
        else{
            [self.readTableView.mj_footer endRefreshing];
        }
    }];
    
}

@end
