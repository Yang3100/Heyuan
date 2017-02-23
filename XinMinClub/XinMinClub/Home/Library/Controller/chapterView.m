//
//  chapterView.m
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/21.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "chapterView.h"
#import "subcatalogCell.h"

#define backButtonViewHeight (([UIScreen mainScreen].bounds.size.height)/18)

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
    
    CGFloat addViewHeight;
}

@property(nonatomic,strong) UIScrollView *backScrollView;
@property(nonatomic,strong) UITableView *chapterTable;

//@property(nonatomic,assign) CGFloat moveHeight;

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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return sectionTypeArray.count*2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {        
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
    }else{
        NSLog(@"xxxxxxx:%f",addViewHeight);
        return addViewHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *kj_cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!kj_cell) {
        kj_cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0) {
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
    kj_cell.textLabel.text = @"";
    kj_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    kj_cell.backgroundColor = [UIColor whiteColor];
    return kj_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
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
                if (sectionTypeArray.count<=18) {
                    addViewHeight = 44*(18-sectionTypeArray.count);
                }
                [self.chapterTable reloadData];
            }
        }
    }else{
        NSLog(@"点击的空白处!");
    }
    
}

#pragma mark 获取到数据
- (void)gettype:(NSArray *)type{
    sectionTypeArray = type;
    if (sectionTypeArray.count<=18) {
        addViewHeight = 44*(18-sectionTypeArray.count);
    }
    [self.chapterTable reloadData];
}

- (void)getDataListWithType:(NSString*)type {
//    @"Right_ID": @"f8037fea-5240-448a-b39f-d79b3aff4fa9",
    [[LoadAnimation defaultDataModel] startLoadAnimation];
    // 获取小节列表
    NSDictionary *dict = @{@"GJ_WJ_ID":_bookID, @"GJ_WJ_ZY_TYPE":type,@"Page_Index":@"1",@"Page_Count":@"100000"};
    NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_WJ_ZJ_TYPE_DataList", @"Params":dict}];
    [networkSection getRequestDataBlock:IPUrl :paramString block:^(NSDictionary *jsonDxx) {
//                NSLog(@"Get_WJ_ZJ_TYPE_DataList:%@",jsonDict);
        // 主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LoadAnimation defaultDataModel] endLoadAnimation];
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
            if ((sectionTypeArray.count+listTotal)<=18) {
                addViewHeight = 44*(18-sectionTypeArray.count-listTotal);
            }else{
                addViewHeight = 0;
            }
            [self.chapterTable reloadData];
        });
    }];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.bounds.origin.y);
//    NSLog(@"tag:%d,%f,%f", scrollView.tag,scrollView.bounds.origin.y,_chapterTable.frame.origin.y);
    self.chapterScroll = scrollView.bounds.origin.y;
//    if (_chapterScroll>=SCREEN_HEIGHT/3-64) {
//        NSLog(@"菜单到顶了!!!");
//        _chapterTable.scrollEnabled = YES;
//        _backScrollView.scrollEnabled = NO;
//        _backScrollView.frame = CGRectMake(x, y, w, h);
//    }
//    CGFloat kj_y = scrollView.bounds.origin.y;
//    self.chapterTable.frame = CGRectMake(x, kj_y, w, h);
    
//    self.moveHeight = scrollView.bounds.origin.y;
}

//- (void)setMoveHeight:(CGFloat)moveHeight{
//    NSLog(@"%f--%f",moveHeight,SCREEN_HEIGHT/3-64);
//    if (moveHeight>SCREEN_HEIGHT/3-64) {
//        return;
//    }else if (moveHeight<0){
//        return;
//    }
//    self.chapterTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, moveHeight+SCREEN_HEIGHT-SCREEN_HEIGHT/3-44+backButtonViewHeight -20);
//}


@end
