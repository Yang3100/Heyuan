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

#define backButtonViewHeight (([UIScreen mainScreen].bounds.size.height)/18)

@interface detailsView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>{
    NSDictionary *jsonData;
    NSArray *dataArray;
    NSArray<NSDictionary*> *commentArray;
    UITextField *_detailsTextField;
    
    CGFloat addViewHeight;
    UIButton *detailsButon;
}

@property(nonatomic,copy) UITableView *tableView;
@property(nonatomic,copy) UIView *backView;

@end

@implementation detailsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
        
        commentArray = [NSArray array];
        addViewHeight = 44;
        
        // 注册cell
        UINib *de1 = [UINib nibWithNibName:@"DetailsCell1" bundle:nil];
        [self.tableView registerNib:de1 forCellReuseIdentifier:@"detailsCell1"];
        UINib *de2 = [UINib nibWithNibName:@"DetailsCell2" bundle:nil];
        [self.tableView registerNib:de2 forCellReuseIdentifier:@"detailsCell2"];
        UINib *de4 = [UINib nibWithNibName:@"DetailsCell4" bundle:nil];
        [self.tableView registerNib:de4 forCellReuseIdentifier:@"detailsCell4"];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.kj_backView];
        self.backView.hidden = YES;
        self.kj_backView.hidden = YES;
        
        // 添加观察者,监听键盘弹出，隐藏事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)error{
    [SVProgressHUD showSuccessWithStatus:@"添加评论失败!"];
    //会调用
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self dismiss];
    });
}

- (void)successs {
//    [_detailsTextField resignFirstResponder];
    self.kj_backView.frame = CGRectMake(0, SCREEN_HEIGHT-60,SCREEN_WIDTH, 60);
    self.backView.hidden = YES;
    [SVProgressHUD showSuccessWithStatus:@"添加评论成功!"];
    //会调用
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self dismiss];
    });
    [self getEvaluate:_bookID];
}
- (void)dismiss {
    [SVProgressHUD dismiss];
}
- (void)setBookID:(NSString *)bookID {
    _bookID = nil;
    _bookID = bookID;
}

- (void)dealloc{
    [_detailsTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setIsTopView:(BOOL)isTopView{
    NSLog(@"detailsTop:%d",isTopView);
    if (isTopView) {
        self.kj_backView.hidden = NO;
        // 主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tableView.contentSize.height<SCREEN_HEIGHT) {
                addViewHeight = SCREEN_HEIGHT-self.tableView.contentSize.height + 44;
            }
            [self.tableView reloadData];
        });
        
        [self getEvaluate:_bookID];
    }else{
        self.kj_backView.hidden = YES;
    }
}

- (void)getEvaluate:(NSString*)bookID{
    NSDictionary *dict = @{@"WJ_ID":bookID};
    NSString *paramString = [networkSection getParamStringWithParam:@{@"Right_ID":@"",@"FunName":@"Get_Sys_Gx_WenJi_PL", @"Params":dict}];
    [[LoadAnimation defaultDataModel] startLoadAnimation];
    [networkSection getRequestDataBlock:IPUrl :paramString block:^(NSDictionary *jsonDict) {
        //        NSLog(@"%@",jsonDict);
        [[LoadAnimation defaultDataModel] endLoadAnimation];
        // 主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            commentArray = [[jsonDict valueForKey:@"RET"] valueForKey:@"SYS_GX_WJ_PL"];
            [self.tableView reloadData];
            if (self.tableView.contentSize.height<SCREEN_HEIGHT) {
                addViewHeight = SCREEN_HEIGHT-self.tableView.contentSize.height + 44;
            }
            else{
                addViewHeight = 44;
            }
            [self.tableView reloadData];
        });
    }];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView*)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [_backView addGestureRecognizer:singleTap];
        
        // 这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
    }
    return _backView;
}

- (UIView*)kj_backView{
    if (!_kj_backView) {
        _kj_backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _kj_backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
        _kj_backView.backgroundColor = RGB255_COLOR(235, 235, 235, 1);
        
        _detailsTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH*3/4-10, 40)];
        [_detailsTextField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
        _detailsTextField.keyboardType = UIKeyboardTypeDefault;
        _detailsTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _detailsTextField.returnKeyType = UIReturnKeyDone;
        _detailsTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        
        _detailsTextField.delegate = self;
        
        detailsButon = [UIButton buttonWithType:UIButtonTypeCustom];
        detailsButon.frame = CGRectMake(SCREEN_WIDTH*3/4+5, 10, SCREEN_WIDTH/4-15, 40);
        [detailsButon setTitle:@"发送" forState:UIControlStateNormal];
        [detailsButon setTitleColor:[UIColor colorWithRed:0.553 green:0.281 blue:0.248 alpha:1.000] forState:UIControlStateNormal];
        [detailsButon addTarget:self action:@selector(updateUser) forControlEvents:UIControlEventTouchUpInside];
        detailsButon.layer.masksToBounds = YES;
        detailsButon.layer.cornerRadius = 6.0;
        detailsButon.layer.borderColor = [[UIColor colorWithWhite:0.503 alpha:0.800] CGColor];
        detailsButon.layer.borderWidth = 0.5;
        detailsButon.showsTouchWhenHighlighted=YES;
        
        [_kj_backView addSubview:_detailsTextField];
        [_kj_backView addSubview:detailsButon];
    }
    return _kj_backView;
}

- (void)updateUser{
    detailsButon.enabled = NO;
    // 提交评价
    NSData *imageData = UIImageJPEGRepresentation(USER_DATA_MODEL.userImage,0.7);
    //NSData 转NSString
    NSString *imageStr = [imageData base64Encoding];
    NSDictionary *dict = @{@"PL_WJ_ID":_bookID,@"PL_WJ_CONTENT":_detailsTextField.text,@"USER_IMG":imageStr,@"USER_NAME":[UserDataModel defaultDataModel].userName};
    NSString *paramString = [networkSection getParamStringWithParam:@{@"Right_ID":@"",@"FunName":@"Add_Sys_Gx_WenJi_PL", @"Params":dict}];
    [[LoadAnimation defaultDataModel] startLoadAnimation];
    [networkSection getRequestDataBlock:IPUrl :paramString block:^(NSDictionary *jsonDict) {
//        NSLog(@"%@",jsonDict);
        if ([[jsonDict objectForKey:@"Error"] isEqualToString:@""]) {
            detailsButon.enabled = YES;
            [self successs];
        }else{
            detailsButon.enabled = YES;
            [self error];
        }
    }];
    
}

#pragma mark 手势(解决点击收键盘事件)
// 然后有一个关键的，要实现一个方法：
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

// 最后，响应的方法中，可以获取点击的坐标哦！
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [_detailsTextField resignFirstResponder];
    self.kj_backView.frame = CGRectMake(0, SCREEN_HEIGHT-60,SCREEN_WIDTH, 60);
    self.backView.hidden = YES;
}

#pragma mark Actions
// 键盘弹出时不产生遮挡关系的设置
- (void)keyboardShow:(NSNotification *)notify{
    NSValue *value = [notify.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGFloat keyboardHeight = value.CGRectValue.size.height;
    if ([DataModel defaultDataModel].isFristShowKeyboard>=2) {
        self.kj_backView.frame = CGRectMake(0, SCREEN_HEIGHT-keyboardHeight-60,SCREEN_WIDTH, 60);
    }else{
        self.kj_backView.frame = CGRectMake(0, SCREEN_HEIGHT-keyboardHeight-130,SCREEN_WIDTH, 60);
    }
    [DataModel defaultDataModel].isFristShowKeyboard++;
    self.backView.hidden = NO;
}

// 键盘隐藏
- (void)keyboardHide:(NSNotification *)notify{
    self.kj_backView.frame = CGRectMake(0, SCREEN_HEIGHT-60,SCREEN_WIDTH, 60);
    self.backView.hidden = YES;
}

// 点击键盘下一项
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"点击键盘右下角的键");
    [_detailsTextField resignFirstResponder];
    self.kj_backView.frame = CGRectMake(0, SCREEN_HEIGHT-60,SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backView.hidden = YES;
    return YES;
}
// textField开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"%@",textField);
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
    return commentArray.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if(indexPath.row == 0){
            return 80;
        }else if(indexPath.row == self.textArray.count){
            return UITableViewAutomaticDimension;
        }else{
            return 50;
        }
    } else {
        if (indexPath.row == commentArray.count) {
            NSLog(@"~~~~~~~~~~~%f",addViewHeight);
            return addViewHeight;
        }else{
            return UITableViewAutomaticDimension;
        }
    }
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
    }else if (indexPath.section==0&&indexPath.row>0){
        DetailsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell1" forIndexPath:indexPath];
        cell.details1Text = self.textArray[indexPath.row-1];
        cell.details1Title = dataArray[indexPath.row-1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section==1&&indexPath.row<commentArray.count){
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell2" forIndexPath:indexPath];
        if (commentArray.count && commentArray.count > indexPath.row) {
            ((DetailsCell2*)cell).detailsImageUrl = [commentArray[indexPath.row] valueForKey:@"USER_IMG"];
            ((DetailsCell2*)cell).details2Text = [commentArray[indexPath.row] valueForKey:@"USER_NAME"];
            ((DetailsCell2*)cell).details2Time = [commentArray[indexPath.row] valueForKey:@"PL_OPS_TIME"];
            ((DetailsCell2*)cell).details2Title = [commentArray[indexPath.row] valueForKey:@"PL_WJ_CONTENT"];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *kj_cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxxx"];
        kj_cell.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        label.text = @"已经到底了~";
        label.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
//        kj_cell.backgroundColor = [UIColor greenColor];
        [kj_cell addSubview:label];
        kj_cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return kj_cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
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
