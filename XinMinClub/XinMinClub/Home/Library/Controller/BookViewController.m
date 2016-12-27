//
//  BookView.m
//  XinMinClub
//
//  Created by 杨科军 on 16/6/26.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "BookViewController.h"
#import "LibraryCollectionCell.h"
#import "MJRefresh.h"
#import "smallNineNine.h"
#import "SectionViewController.h"

@interface BookViewController()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *libraryArray; // 下面文库数据
    int touchN; // 点击的是哪一个九宫格
    smallNineNine *snn;
}

@property(nonatomic, copy) UICollectionView *libraryCollectionView;
@property(nonatomic, copy) UICollectionViewLayout *layoutObject;

@end

@implementation BookViewController

+(instancetype)shareObject{
    static BookViewController *bvcc = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        bvcc = [[super allocWithZone:NULL] init];
    });
    return bvcc;
}

- (instancetype)init{
    [DataModel defaultDataModel].kaiguannnn = 0;
    if (self==[super init]) {
        libraryArray = [NSMutableArray array]; // 创建一个保存collectionView图片的数组，每次刷新后的新增到这个里面
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 右侧消息按钮
    UIImage *leftImage = [UIImage imageNamed:@"player"];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(smallNineNineAction:)];
    self.navigationItem.rightBarButtonItem = leftButtonItem;
    
    // 注册类
    [self.libraryCollectionView registerClass:[LibraryCollectionCell class] forCellWithReuseIdentifier:@"libraryCollectionCell"];
    [self.view addSubview:self.libraryCollectionView];
}

// 点击播放按钮
- (void)smallNineNineAction:(UIButton *)button {
    if ([DataModel defaultDataModel].kaiguannnn==0) {
        [DataModel defaultDataModel].kaiguannnn=1;
        // 弹出新的视图控制器
        CGRect frame = CGRectMake(0, 0, 200, 200);
        snn = [[smallNineNine alloc]initWithSize:frame rushidaoName:_rushidaoName smallNineArray:_typeArray TouchNum:touchN];
        
        [self.view addSubview:snn];
    }
    else if ([DataModel defaultDataModel].kaiguannnn == 1) {
        [DataModel defaultDataModel].kaiguannnn=0;
        [snn removeFromSuperview];
    }
}

//获取九宫格里面的书集数据
- (void)startGetDataWithType:(NSString*)type touchNum:(int)touchNum{
    touchN = touchNum; // 保存点击的那一个九宫格
    __block int iNum=1; // 上拉刷新
    __block int libraryTotal=0;  // 书集总数
    __block bool off=NO; // 判断数据是否获取到的状态
    
    if (_isRemoveArray) {
        [libraryArray removeAllObjects];
    }
    
    // 后台执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 后台对数据类型的需要
        NSDictionary *dict = @{@"TYPE":type,@"Page_Index":@(iNum),@"Page_Count":@"9"};
        NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_WenJi_DataList",@"Params":dict}];
        [networkSection getJsonDataWithUrlString:IPUrl param:paramString];
    });
    
    //回调函数获取数据
    [networkSection setGetRequestDataClosuresCallBack:^(NSDictionary *json) {
        //        NSLog(@"xxx%@",json);
        NSNumber *mapXNum = [[json valueForKey:@"RET"] valueForKey:@"Record_Count"];
        libraryTotal = [mapXNum intValue];
        // 主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            [libraryArray addObjectsFromArray:[[json valueForKey:@"RET"] valueForKey:@"Sys_GX_WenJI"]];
            [self.libraryCollectionView reloadData];
            if (off==YES) {
                // 结束刷新
                [self.libraryCollectionView.mj_footer endRefreshing];
                off=NO;
            }
        });
    }];
    
    // 下拉刷新
    self.libraryCollectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 结束刷新
        [self.libraryCollectionView.mj_header endRefreshing];
        _isRemoveArray = NO;
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.libraryCollectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.libraryCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isRemoveArray = NO;
        off=YES;
        if (libraryArray.count>=libraryTotal) {
            [self.libraryCollectionView.mj_footer endRefreshing];
        }
        else{
            iNum ++;
            // 后台执行
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 后台对数据类型的需要
                NSDictionary *dict = @{@"TYPE":type,@"Page_Index":@(iNum),@"Page_Count":@"9"};
                NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"Get_WenJi_DataList",@"Params":dict}];
                [networkSection getJsonDataWithUrlString:IPUrl param:paramString];
            });
        }
    }];
}


#pragma mark Subviews
- (UICollectionView*)libraryCollectionView{
    if (!_libraryCollectionView) {
        _libraryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:self.layoutObject];
        _libraryCollectionView.backgroundColor = [UIColor whiteColor];
        _libraryCollectionView.delegate = self;
        _libraryCollectionView.dataSource = self;
    }
    return _libraryCollectionView;
}

// 创建布局对象
- (UICollectionViewLayout *)layoutObject {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return flowLayout;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH-4*20)/3, (SCREEN_WIDTH-4*20)/3+(SCREEN_WIDTH-4*20)/6);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 0);
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
// 返回指定section中cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return libraryArray.count;
}
// 返回指定位置的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LibraryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"libraryCollectionCell" forIndexPath:indexPath];
    NSDictionary *dict = libraryArray[indexPath.row];
    cell.libraryImageUrl = [dict valueForKey:@"WJ_IMG"];
    cell.readtotal = [dict valueForKey:@"WJ_WCOUNT"];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"collectionView.tag = %d,section = %d, row = %d", collectionView.tag,indexPath.section, indexPath.row);
    NSDictionary *dica = libraryArray[indexPath.row];
    SectionViewController *svc = [[SectionViewController alloc] init];
    svc.title = [dica valueForKey:@"WJ_NAME"];
    [svc getJsonData:dica];
    
//    KJ_BackTableViewController *kj_svc = [[KJ_BackTableViewController alloc] init];
//    kj_svc.libraryTitle = [dica valueForKey:@"WJ_NAME"];
//    kj_svc.libraryAuthorName = [dica valueForKey:@"WJ_USER"];
//    kj_svc.libraryType = [dica valueForKey:@"WJ_TYPE"];
//    kj_svc.libraryDetails = [dica valueForKey:@"WJ_CONTENT"];
//    kj_svc.libraryLanguage = [dica valueForKey:@"WJ_LANGUAGE"];
//    kj_svc.libraryNum = [dica valueForKey:@"WJ_ID"];
//    kj_svc.libraryAuthorImageUrl = [IP stringByAppendingString:[dica valueForKey:@"WJ_TITLE_IMG"]];
//    kj_svc.libraryImageUrl = [IP stringByAppendingString:[dica valueForKey:@"WJ_IMG"]];
//    
//    [[DataModel defaultDataModel] addAllLibrary:kj_svc.libraryNum ImageUrl:kj_svc.libraryImageUrl BookName:kj_svc.libraryTitle AuthorName:kj_svc.libraryAuthorName Type:kj_svc.libraryType Language:kj_svc.libraryLanguage Detail:kj_svc.libraryDetails];
    [self.navigationController pushViewController:svc animated:YES];
}

@end
