//
//  ReadTableView.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "ReadTableView.h"
#import "ReadCell.h"

@interface ReadTableView()<UITableViewDelegate,UITableViewDataSource>{
    BOOL squareBool;
    NSInteger buttonTag;
    NSMutableArray *clickButtonTag;
    BOOL MyState;
    NSMutableArray *kj_CNText;
}

@property(nonatomic,copy) UITableView *tableView1;

@end

@implementation ReadTableView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        clickButtonTag=[NSMutableArray array];
        kj_CNText=[NSMutableArray new];
        //获取通知中心单例对象
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
        [center addObserver:self selector:@selector(notice:) name:@"spread" object:nil];
        [center addObserver:self selector:@selector(notice1:)name:@"spreadNo" object:nil];
        
        [self tableView1];
        UINib *nib = [UINib nibWithNibName:@"ReadCell" bundle:nil];
        [self.tableView1 registerNib:nib forCellReuseIdentifier:@"readCell"];
        [self addSubview:self.tableView1];
    }
    return self;
}
-(IBAction)notice:(NSNotification*)sender{
    [clickButtonTag addObject:[sender.userInfo valueForKey:@"buttonTag"]];
    [self.tableView1 reloadData];
}
-(IBAction)notice1:(NSNotification*)sender{
    NSMutableArray *deleteButtonTag = [NSMutableArray array];
    NSNumber *b =[sender.userInfo valueForKey:@"buttonTag"]; //要删除的数据
            int index = 0;
            for (int i = 0;i<clickButtonTag.count;i++){
                if ([b isEqual:clickButtonTag[i]]){//要删除的数据
                    continue;
                }
                else{
                    deleteButtonTag[index] = clickButtonTag[i];
                    index++;
                }
            }
    clickButtonTag=deleteButtonTag;
    [self.tableView1 reloadData];
}

- (UITableView *)tableView1{
    if (!_tableView1) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _tableView1 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        
        _tableView1.backgroundColor = [UIColor whiteColor];
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
    }
    return _tableView1;
}
-(void)setReadTextArray:(NSArray *)readTextArray{
    _readTextArray = readTextArray;
    [kj_CNText removeAllObjects];
    for (NSInteger a=0; a<readTextArray.count; a++) {
        SectionData *da = readTextArray[a];
        [kj_CNText addObject:[self getBook: da.clickSectionCNText]];
    }
    [self.tableView1 reloadData];
}

-(NSString *)getBook:(NSString *)Book{
    //分割歌词
    NSString *text=@"";
    NSArray *sepArray=[Book componentsSeparatedByString:@"["];
    NSArray *lineArray;
    for(int i=0;i<sepArray.count;i++){
        if([sepArray[i] length]>0){
            lineArray=[sepArray[i] componentsSeparatedByString:@"]"];
            if(![lineArray[0] isEqualToString:@"\n"]){
                text = [NSString stringWithFormat:@"%@%@",text,lineArray.count>1?lineArray[1]:@""];
            }
        }
    }
    return text;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (!_kj_typeee.count) {
//        return 1;
//    }
//    return _kj_typeee.count;
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.readTextArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    for (NSString *a in clickButtonTag) {
        if (indexPath.row==[a intValue]) {
            MyState=YES;
            return UITableViewAutomaticDimension;
        }
    }
       MyState=NO;
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        ReadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"readCell" forIndexPath:indexPath];
        SectionData *data = self.readTextArray[indexPath.row];
        cell.readTitle = data.clickTitle;
        cell.readMp3 = data.clickMp3;
        cell.readText = kj_CNText[indexPath.row];
        cell.readNum = indexPath.row;
        cell.state = MyState;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lan;
    lan = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    lan.backgroundColor=[UIColor colorWithRed:0.7622 green:0.7622 blue:0.7622 alpha:1.0];
    lan.text=[NSString stringWithFormat:@"   %@",_kj_typeee[_kj_x]];
    return lan;
}

@end


