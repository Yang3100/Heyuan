//
//  chapterView.m
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/21.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "chapterView.h"
#import "subcatalogCell.h"

@interface chapterView()<UITableViewDelegate,UITableViewDataSource>{
    NSDictionary *jsonDict; // 获取到的小节数据字典
    int listTotal; // 小节数目
    NSArray *sectionTypeArray; // 章节分类
    NSString *kj_key; // 键
    
    NSInteger kj_k; // 请求到第几个目录数据
    NSInteger kj_clickCellNum; // 点击的是哪个cell
    BOOL kj_touchCellStatus;  // 模拟点击了cell状态（处理章节播放结束，请求数据继续播放的情况）
    BOOL kj_clickCellStatus; // 点击cell的状态
    BOOL kj_kaiguan;// 多次点击cell的开关
    
    // 设置箭头
    UIImage *rightImage;
    UIImage *downImage;
    UIImageView *kj_imageView;
}

@property(nonatomic,strong) UIScrollView *backScrollView;
@property(nonatomic,strong) UITableView *chapterTable;

@end

@implementation chapterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        // 初始化点击的信息
        kj_clickCellStatus=NO;
        kj_clickCellNum=-2;
        kj_kaiguan=NO;
        kj_k=0;
        
        rightImage = [UIImage imageNamed:@"setbutton"];
        downImage = [UIImage imageNamed:@"actionbutton"];
        
        kj_touchCellStatus=NO;
        
        UINib *nib=[UINib nibWithNibName:@"subcatalogCell" bundle:nil];
        [self.chapterTable registerNib:nib forCellReuseIdentifier:@"subcaCell"];
        
        [self addSubview:self.chapterTable];
    }
    return self;
}

#pragma mark chapterTable
- (UIScrollView*)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _backScrollView.tag = 1;
        _backScrollView.delegate = self;
        [_backScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _backScrollView;
}

- (UITableView*)chapterTable{
    if (!_chapterTable) {
        _chapterTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _chapterTable.delegate = self;
        _chapterTable.dataSource = self;
        _chapterTable.tag = 2;
//        _chapterTable.scrollEnabled = NO;
    }
    return _chapterTable;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sectionTypeArray.count*2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kj_clickCellNum+1==indexPath.row) {
        switch (kj_clickCellStatus) {
            case YES:
                return listTotal*40;
                break;
                
            case NO:
                return 0.1;
                break;
        }
    }
    if (indexPath.row%2!=0) {
        return 0.1;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *kj_cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!kj_cell) {
        kj_cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row%2==0) {
        switch (kj_clickCellStatus) {
            case YES:
                if (kj_clickCellNum!=indexPath.row) {
                    kj_imageView=[[UIImageView alloc]initWithImage:rightImage];
                }else
                    kj_imageView=[[UIImageView alloc]initWithImage:downImage];
                break;
                
            case NO:
                kj_imageView=[[UIImageView alloc]initWithImage:rightImage];
                break;
        }
        kj_cell.accessoryView=kj_imageView;
        kj_cell.textLabel.text=[NSString stringWithFormat:@"%@",sectionTypeArray[indexPath.row/2]];
    }else{
        kj_cell=[tableView dequeueReusableCellWithIdentifier:@"subcaCell" forIndexPath:indexPath];
        // 传递数据
        ((subcatalogCell*)kj_cell).jsonData = jsonDict;
    }
    kj_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return kj_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kj_clickCellNum!=indexPath.row) {
        kj_kaiguan=NO;
    }
    kj_kaiguan = !kj_kaiguan;
    if (kj_kaiguan) {
        kj_clickCellStatus=YES;
        [self getDataListWithType:sectionTypeArray[indexPath.row/2]]; // 获取数据
        kj_clickCellNum=indexPath.row;
        kj_k=indexPath.row/2;
    }else{
        if (kj_clickCellNum==indexPath.row) {
            kj_clickCellStatus=NO;
            [self.chapterTable reloadData];
        }
    }
    
}

#pragma mark 获取到数据
- (void)gettype:(NSArray *)type{
    sectionTypeArray = type;
    [self.chapterTable reloadData];
}

- (void)getDataListWithType:(NSString*)type {
    // 获取小节列表
    NSDictionary *dict = @{@"GJ_WJ_ID":_bookID, @"GJ_WJ_ZY_TYPE":type,@"Page_Index":@"1",@"Page_Count":@"100000"};
    NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_WJ_ZJ_TYPE_DataList", @"Params":dict}];
    [networkSection getRequestDataBlock:IPZUrl :paramString block:^(NSDictionary *jsonDxx) {
//                NSLog(@"Get_WJ_ZJ_TYPE_DataList:%@",jsonDict);
        // 主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            jsonDict = jsonDxx;
            NSArray *arr = [[jsonDxx valueForKey:@"RET"] valueForKey:@"Sys_GX_ZJ"];
            listTotal = arr.count;
            kj_key=[NSString stringWithFormat:@"%@",sectionTypeArray[kj_clickCellNum/2]];

            if (kj_touchCellStatus==YES) {
                kj_touchCellStatus=NO;
//                [self aabb:list];
                NSLog(@"模拟点击cell的时候传递数据!!!");
                return;
            }
            [self.chapterTable reloadData];
        });
    }];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.bounds.origin.y);
    NSLog(@"tag:%d,%f,%f", scrollView.tag,scrollView.bounds.origin.y,_chapterTable.frame.origin.y);
    self.chapterScroll = scrollView.bounds.origin.y;
//    if (_chapterScroll>=SCREEN_HEIGHT/3-64) {
//        NSLog(@"菜单到顶了!!!");
//        _chapterTable.scrollEnabled = YES;
//        _backScrollView.scrollEnabled = NO;
//        _backScrollView.frame = CGRectMake(x, y, w, h);
//    }
//    CGFloat kj_y = scrollView.bounds.origin.y;
//    self.chapterTable.frame = CGRectMake(x, kj_y, w, h);
}


@end
