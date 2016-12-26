//
//  DetailsTableView.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "DetailsTableView.h"
#import "DetailsCell1.h"
#import "DetailsCell2.h"
//#import "CommentModel.h"
#import "SVProgressHUD.h"

@interface DetailsTableView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    NSArray *commentArray;
    SectionData *commentData;
    NSString *userContent;
}

@property(nonatomic,copy) UITableView *tableView1;
//@property(nonatomic,copy) UIView *backView;
//
//@property (nonatomic, strong) UIView *backTopView;

@end

@implementation DetailsTableView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
//        [[CommentModel shareObject] startGetComment:_libraryID];
//        [CommentModel shareObject].commentDelegate = self;
        
//        [self addSubview:self.backView];
        [self addSubview:self.tableView1];
//        [self addSubview:self.backTopView];
        
        UINib *de1 = [UINib nibWithNibName:@"DetailsCell1" bundle:nil];
        [self.tableView1 registerNib:de1 forCellReuseIdentifier:@"detailsCell1"];
        UINib *de2 = [UINib nibWithNibName:@"DetailsCell2" bundle:nil];
        [self.tableView1 registerNib:de2 forCellReuseIdentifier:@"detailsCell2"];
//        UINib *de3 = [UINib nibWithNibName:@"DetailsCell3" bundle:nil];
//        [self.tableView1 registerNib:de3 forCellReuseIdentifier:@"detailsCell3"];
        
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//        [self.backView addGestureRecognizer:singleTap];
//        
//        // 这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
//        singleTap.delegate = self;
//        singleTap.cancelsTouchesInView = NO;
//        
//        // 添加观察者,监听键盘弹出，隐藏事件
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

//- (void)dealloc{
//    [_detailsTextField resignFirstResponder];
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}
//
//#pragma mark CommentModelDelegate
//- (void)GetComment:(NSArray *)comment{
//    commentArray = comment;
//    NSLog(@"xxxxxxx%@",commentArray);
//}
//
//// 然后有一个关键的，要实现一个方法：
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}
//
//// 最后，响应的方法中，可以获取点击的坐标哦！
//-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
//    CGPoint point = [sender locationInView:self.backView];
//    [_detailsTextField resignFirstResponder];
//    [self bringSubviewToFront:self.tableView1];
//    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
//}

- (NSArray *)textArray{
    return @[@"作者",@"分类",@"语言",@"简介"];
}

#pragma mark Subviews
- (UITableView *)tableView1{
    if (!_tableView1) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _tableView1 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView1.backgroundColor = [UIColor redColor];
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
    }
    return _tableView1;
}

//- (UIView *)backView{
//    if (_backView==nil) {
//        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2/3)];
//        _backView.backgroundColor = [UIColor clearColor];
//    }
//    return _backView;
//}

//- (UIView *)backTopView{
//    if (!_backTopView) {
//        CGFloat x = 0;
//        CGFloat y = -100;
//        CGFloat w = [UIScreen mainScreen].bounds.size.width;
//        CGFloat h = 100;
//        UIView *view = [UIView new];
//        view.backgroundColor = [UIColor colorWithRed:0.553 green:0.281 blue:0.248 alpha:1.000];
//        view.frame = CGRectMake(x,y,w,h);
//        view.clipsToBounds = YES; // 超出控件边框范围的内容都剪掉
//        _backTopView = view;
//    }
//    return _backTopView;
//}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.textArray.count+1;
    }
    return commentArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if(indexPath.row == 0){
            return 80;
        }
        if(indexPath.row == self.textArray.count){
            return 200;
        }
        return 50;
    }
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
//    if (indexPath.section==0&&indexPath.row==0) {
//        DetailsCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell3" forIndexPath:indexPath];
//        cell.imageUrl = self.detailsTextArray[0];
//        cell.libraryName = self.detailsTextArray[1];
//        cell.backgroundColor = [UIColor whiteColor];
//        cell.textLabel.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
    if (indexPath.section==0&&indexPath.row>0){
        DetailsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell1" forIndexPath:indexPath];
        cell.details1Text = self.textArray[indexPath.row-1];
        cell.details1Title = self.detailsTextArray[indexPath.row+1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell2" forIndexPath:indexPath];
//    commentData = commentArray[indexPath.row];
//    ((DetailsCell2*)cell).detailsImageUrl = commentData.commentImageUrl;
//    ((DetailsCell2*)cell).details2Text = commentData.commentName;
//    ((DetailsCell2*)cell).details2Time = commentData.commentTime;
//    ((DetailsCell2*)cell).details2Title = commentData.commentText;
    cell.textLabel.text = @"233";
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.373 alpha:1.000];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
//        return 30;
//    }
//    return 0.1;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 1) {
//        return 60;
//    }
//    return 0.1;
//}
//
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *aView = [UIView new];
//    if (section == 1) {
//        aView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
//        aView.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
//        UILabel *aaa = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 30)];
//        aaa.text = @"用户评价";
//        
//        [aView addSubview:aaa];
//    }
//    
//    return aView;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *detailsView;
//    if (section==1) {
//        detailsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
//        detailsView.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
//        
//        _detailsTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width*3/4-10, 40)];
//        [_detailsTextField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
//        _detailsTextField.keyboardType = UIKeyboardTypeDefault;
//        _detailsTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        _detailsTextField.returnKeyType = UIReturnKeyDone;
//        _detailsTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
//        
//        _detailsTextField.delegate = self;
//        
//        UIButton *detailsButon = [UIButton buttonWithType:UIButtonTypeCustom];
//        detailsButon.frame = CGRectMake(self.frame.size.width*3/4+5, 10, self.frame.size.width/4-15, 40);
//        [detailsButon setTitle:@"发送" forState:UIControlStateNormal];
//        [detailsButon setTitleColor:[UIColor colorWithRed:0.553 green:0.281 blue:0.248 alpha:1.000] forState:UIControlStateNormal];
//        [detailsButon addTarget:self action:@selector(updateUser) forControlEvents:UIControlEventTouchUpInside];
//        
//        detailsButon.layer.masksToBounds = YES;
//        detailsButon.layer.cornerRadius = 6.0;
//        detailsButon.layer.borderColor = [[UIColor colorWithWhite:0.503 alpha:0.800] CGColor];
//        detailsButon.layer.borderWidth = 0.5;
//        detailsButon.showsTouchWhenHighlighted=YES;
//        
//        [detailsView addSubview:_detailsTextField];
//        [detailsView addSubview:detailsButon];
//    }
//    return detailsView;
//}

//- (void)updateUser{
//    [[CommentModel shareObject]updateUserAppraise:self.libraryID LibraryContent:userContent];
//}

//- (void)updateUserAppraiseIsSucceed:(NSString *)kkkk{
//    if ([kkkk isEqualToString:@"1"]) {
//        // 提示成功
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//        [SVProgressHUD show];
//        [self performSelector:@selector(success) withObject:nil afterDelay:0.6f];
//    }else{
//        // 提示成功
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//        [SVProgressHUD show];
//        [self performSelector:@selector(success11) withObject:nil afterDelay:0.6f];
//    }
//}
//- (void)success {
//    [SVProgressHUD showSuccessWithStatus:@"评论成功!!!"];
//    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
//}
//- (void)success11 {
//    [SVProgressHUD showSuccessWithStatus:@"评论失败!"];
//    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
//}
//- (void)dismiss {
//    [SVProgressHUD dismiss];
//}
//
//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        return NO;
//    }
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"mmmmmmmmmmm%d",indexPath.row);
//}
//
//#pragma mark Actions
//// 键盘弹出时不产生遮挡关系的设置
//- (void)keyboardShow:(NSNotification *)notify{
//    NSValue *value = [notify.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGFloat keyboardHeight = value.CGRectValue.size.height;
//    // 获取屏幕与控件高度差
//    CGFloat deltaH=1;
//    if (commentArray.count==0) {
//            if (SCREEN_HEIGHT ==736) {
//                // 6p的高度
//                deltaH = -keyboardHeight+216;
//            }
//            else if (SCREEN_HEIGHT ==667) {
//                // 6的高度
//                deltaH = -keyboardHeight +200;
//            }
//            else if (SCREEN_HEIGHT ==568) {
//                // 5s的高度
//                deltaH = -keyboardHeight +175-79;
//            }
//    }
//    else
//       deltaH = -keyboardHeight+94;
//    
//    // 如果屏幕不够高
//    if (deltaH < 0) {
//        CGRect frame = self.frame;
//        frame = CGRectMake(frame.origin.x, deltaH, frame.size.width, frame.size.height);
//        self.frame = frame;
//    }
//    NSLog(@"屏幕高度:%f",SCREEN_HEIGHT);
//    [self bringSubviewToFront:self.backView];
//    if (commentArray.count == 0) {
//        if (SCREEN_HEIGHT ==736) {
//            // 6p的高度
//            _backTopView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 100);
//        }
//        else if (SCREEN_HEIGHT ==667) {
//            // 6的高度
//            _backTopView.frame = CGRectMake(0, 53, SCREEN_WIDTH, 100);
//        }
//        else if (SCREEN_HEIGHT ==568) {
//            // 5s的高度
//            _backTopView.frame = CGRectMake(0, 150, SCREEN_WIDTH, 100);
//        }
//    }else{
//        if (SCREEN_HEIGHT ==736) {
//            // 6p的高度
//            _backTopView.frame = CGRectMake(0, 171, SCREEN_WIDTH, 100);
//        }
//        else if (SCREEN_HEIGHT ==667) {
//            // 6的高度
//            _backTopView.frame = CGRectMake(0, 159, SCREEN_WIDTH, 100);
//        }
//        else if (SCREEN_HEIGHT ==568) {
//            // 5s的高度
//            _backTopView.frame = CGRectMake(0, 152, SCREEN_WIDTH, 100);
//        }
//    }
//    [self bringSubviewToFront:self.backTopView];
//}
//
//// 键盘隐藏
//- (void)keyboardHide:(NSNotification *)notify{
//    CGRect frame = self.frame;
//    frame = CGRectMake(frame.origin.x, 94, frame.size.width, frame.size.height);
//    self.frame = frame;
//    _backTopView.frame = CGRectMake(0, -100, SCREEN_WIDTH, 100);
//    [self sendSubviewToBack:self.backTopView];
//}
//
//// 点击键盘下一项
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [_detailsTextField resignFirstResponder];
//    NSLog(@"点击键盘右下角的键");
//    return YES;
//}
//
//// textField开始编辑
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//        userContent = textField.text;
//}


@end

