//
//  commentModule.m
//  XinMinClub
//
//  Created by 杨科军 on 2017/3/1.
//  Copyright © 2017年 yangkejun. All rights reserved.
//

#import "commentModule.h"

#define backButtonViewHeight (([UIScreen mainScreen].bounds.size.height)/18)

@interface commentModule()<UIGestureRecognizerDelegate,UITextFieldDelegate>{
    UITextField *_detailsTextField;
    UIButton *detailsButon;
}

@property(nonatomic,strong) UIView *backView;

@end

@implementation commentModule

- (instancetype)initIsHidden:(BOOL)hidde{
    if (self==[super init]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.kj_backView];
        self.backView.hidden = YES;
        self.kj_backView.hidden = hidde;
        
        // 添加观察者,监听键盘弹出，隐藏事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        }
    return self;
}


//- (void)dealloc{
//    [_detailsTextField resignFirstResponder];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

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
    
    
//    [self getEvaluate:_bookID];
}
- (void)dismiss {
    [SVProgressHUD dismiss];
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


@end
