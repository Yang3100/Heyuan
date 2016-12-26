//
//  loginView.m
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/24.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "loginView.h"
#import "HomeViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"

@interface loginView () <UITextFieldDelegate> {
    UITextField *userField_, *keyField_;
    UITextField *curTextField_;
    UILabel *userLabel_ , *keyLabel_;
    UIImageView *logoImage_;
    UIButton *loadButton_;
    UIImageView *backImage_;
    UILabel *titleLabel_;
    UIButton *registerBtn_;
    UIButton *forgetBtn_;
}

@property (nonatomic ,strong) UIImageView *DishangfangLoogin;
@property (nonatomic ,strong) UIButton *QQLoogin;
@property (nonatomic ,strong) UIButton *WeixingLoogin;

@end

@implementation loginView

- (void)loadView{
    //自己创建UIControl添加事件
    UIControl *view = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view addTarget:self action:@selector(resignResponder:) forControlEvents:UIControlEventTouchDown];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backImage];
    [self.view addSubview:self.loadButton];
    [self.view addSubview:self.userLabel];
    [self.view addSubview:self.keyLabel];
    [self.view addSubview:self.keyField];
    [self.view addSubview:self.userField];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.forgetBtn];
    [self.view addSubview:self.QQLoogin];
    [self.view addSubview:self.WeixingLoogin];
    [self.view addSubview:self.DishangfangLoogin];
    //添加观察者,监听键盘弹出，隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (UILabel *)titleLabel {
    if (!titleLabel_) {
        titleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 50)];
        titleLabel_.textColor = [UIColor whiteColor];
        titleLabel_.text = @"登录";
        titleLabel_.textAlignment = NSTextAlignmentCenter;
        [titleLabel_ setFont:[UIFont systemFontOfSize:32]];
    }
    return titleLabel_;
}

- (UIImageView *)backImage{
    if (!backImage_) {
        backImage_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 3)];
        backImage_.image = [UIImage imageNamed:@"login.jpg"];
    }
    return backImage_;
}

//LOGO图
- (UIImageView *)logoImage{
    if (!logoImage_) {
        logoImage_ = [[UIImageView alloc] init];
        logoImage_.frame = CGRectMake(0, 0, 170, 80);
        logoImage_.backgroundColor = [UIColor grayColor];
        
        UIImage *image1 = [UIImage imageNamed:@"imag_08.jpg"];
        logoImage_ .image = image1;
    }
    return logoImage_;
}

//用户名输入提示
- (UILabel *)userLabel{
    if (!userLabel_) {
        userLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2-110, 55, 30)];
        userLabel_.text = @"用户:";
        userLabel_.textColor = [UIColor whiteColor];
    }
    return userLabel_;
}

//密码输入提示
- (UILabel *)keyLabel{
    if (!keyLabel_) {
        keyLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2-50, 55, 30)];
        keyLabel_.text = @"密码:";
        keyLabel_.textColor = [UIColor whiteColor];
    }
    return keyLabel_;
}

//用户名输入框
- (UITextField *)userField{
    if (!userField_) {
        userField_ = [[UITextField alloc] initWithFrame:CGRectMake(userLabel_.center.x + 22.5, SCREEN_HEIGHT/2-110, SCREEN_WIDTH/2, 30)];
        userField_.placeholder = @"请输入你的手机号";
        userField_.keyboardType = UIKeyboardTypeNumberPad;
        userField_.clearButtonMode = UITextFieldViewModeWhileEditing;
        userField_.returnKeyType = UIReturnKeyNext;//改变键盘，右下角位NEXT键
        userField_.delegate = self;//遵循协议,响应键盘弹出,隐藏事件,NEXT键功能
        userField_ .textColor = [UIColor whiteColor];    }
    return userField_;
}

//密码输入框
- (UITextField *)keyField{
    if (!keyField_) {
        keyField_ = [[UITextField alloc] initWithFrame:CGRectMake(userLabel_.center.x + 22.5, SCREEN_HEIGHT/2-50, SCREEN_WIDTH/2, 30)];
        keyField_.placeholder = @"请输入密码";
        keyField_.clearButtonMode = UITextFieldViewModeWhileEditing;
        keyField_.returnKeyType = UIReturnKeyDone;//改变键盘为DONE键
        keyField_.secureTextEntry = YES; //密码输入模式
        keyField_.delegate = self; //遵循协议,响应键盘弹出,隐藏事件,DONE键功能
        keyField_.textColor = [UIColor whiteColor];
    }
    return keyField_;
}

//登陆按钮
- (UIButton *)loadButton{
    if (!loadButton_) {
        loadButton_ = [UIButton buttonWithType:UIButtonTypeSystem];
        loadButton_.frame = CGRectMake(50, SCREEN_HEIGHT/2, SCREEN_WIDTH-100, 50);
        [loadButton_ setTitle:@"登录" forState:UIControlStateNormal];
        loadButton_.backgroundColor = [UIColor colorWithWhite:0.065 alpha:0.800];
        [loadButton_ addTarget:self action:@selector(loadAction:) forControlEvents:UIControlEventTouchUpInside];
        loadButton_.tintColor = [UIColor whiteColor];
    }
    return loadButton_;
}

- (UIButton *)registerBtn{
    if (!registerBtn_) {
        registerBtn_ = [UIButton buttonWithType:UIButtonTypeSystem];
        registerBtn_.frame = CGRectMake(28, SCREEN_HEIGHT/2+60, 80, 30);
        registerBtn_.tintColor = [UIColor whiteColor];
        [registerBtn_ setTitle:@"注册" forState:UIControlStateNormal];
        [registerBtn_.titleLabel setFont:[UIFont systemFontOfSize:16]];
        registerBtn_.layer.masksToBounds = YES;
        registerBtn_.layer.cornerRadius = 5.0;
        registerBtn_.titleLabel.textAlignment = NSTextAlignmentRight;
        [registerBtn_ addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return registerBtn_;
}

- (UIButton *)forgetBtn{
    if (!forgetBtn_) {
        forgetBtn_ = [UIButton buttonWithType:UIButtonTypeSystem];
        forgetBtn_.frame = CGRectMake(SCREEN_WIDTH-130, SCREEN_HEIGHT/2+60, 80, 30);
        forgetBtn_.tintColor = [UIColor whiteColor];
        [forgetBtn_ setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [forgetBtn_.titleLabel setFont:[UIFont systemFontOfSize:16]];
        forgetBtn_.layer.masksToBounds = YES;
        forgetBtn_.layer.cornerRadius = 5.0;
        forgetBtn_.titleLabel.textAlignment = NSTextAlignmentLeft;
        [forgetBtn_ addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return forgetBtn_;
}

#pragma mark 第三方登录
//第三方登陆的几个字
-(UIImageView *)DishangfangLoogin{
    if (!_DishangfangLoogin) {
        _DishangfangLoogin=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dishangfangloog"]];
        _DishangfangLoogin.frame=CGRectMake(0, SCREEN_HEIGHT-SCREEN_HEIGHT/3-30, SCREEN_WIDTH, 30);
    }
    return _DishangfangLoogin;
}
//QQ登陆
-(UIButton*)QQLoogin{
    if (!_QQLoogin) {
        _QQLoogin=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, SCREEN_HEIGHT-SCREEN_HEIGHT/3, 70, 70)];
        UIImage *QQimage=[UIImage imageNamed:@"123loog"];
        [_QQLoogin setImage:QQimage forState:UIControlStateNormal];
        [_QQLoogin addTarget:self action:@selector(QQLoogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QQLoogin;
}
-(UIButton*)WeixingLoogin{
    if (!_WeixingLoogin) {
        _WeixingLoogin=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+25, SCREEN_HEIGHT-SCREEN_HEIGHT/3, 68, 70)];
        UIImage *WeChatimage=[UIImage imageNamed:@"QQloog"];
        [_WeixingLoogin setImage:WeChatimage forState:UIControlStateNormal];
        [_WeixingLoogin addTarget:self action:@selector(WeixingLoogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _WeixingLoogin;
}

#pragma mark Actions
//移除响应者
- (IBAction)resignResponder:(id)sender{
    [userField_ resignFirstResponder];
    [keyField_ resignFirstResponder];
}

//键盘弹出时不产生遮挡关系的设置
- (void)keyboardShow:(NSNotification *)notify{
    NSValue *value = [notify.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGFloat keyboardHeight = value.CGRectValue.size.height;
    
    //获取当前输入框的y值，高度值及屏幕高度
    CGFloat y = curTextField_.frame.origin.y;
    CGFloat h = curTextField_.frame.size.height;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //获取屏幕与控件高度差
    CGFloat deltaH = screenHeight - (y + h + keyboardHeight + self.view.frame.origin.y) - 80;
    
    //如果屏幕不够高
    if (deltaH < 0) {
        CGRect frame = self.view.frame;
        frame = CGRectMake(frame.origin.x, frame.origin.y + deltaH , frame.size.width, frame.size.height);
        self.view.frame = frame;
    }
}
//键盘隐藏
- (void)keyboardHide:(NSNotification *)notify{
    CGRect frame = self.view.frame;
    frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
    self.view.frame = frame;
}

//点击键盘下一项
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [userField_ resignFirstResponder];
    [keyField_ becomeFirstResponder];
    return YES;
}

//textField开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    curTextField_ = textField;
}

#pragma mark  手机号码规范
-(BOOL)validateMobile:(NSString *)mobile{
    NSString *Mobile=@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate *pri=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",Mobile];
    if ([pri evaluateWithObject:mobile]) {
        return 1;
    }
    else{
        return 0;
    }
}

#pragma mark ButtonActions
//登陆功能
- (IBAction)loadAction:(id)sender{
    if (![self validateMobile:userField_.text]) {
        NSLog(@"请重新输入用户名");
        [userField_ becomeFirstResponder];
        [keyField_ resignFirstResponder];
        [self addAlertView];
    }else if([keyField_.text isEqualToString:@""]||keyField_.text.length<6||keyField_.text.length>16){
        NSLog(@"请重新输入密码");
        [userField_ resignFirstResponder];
        [keyField_ becomeFirstResponder];
        [self addAlertView];
    }else if([self validateMobile:userField_.text]&&keyField_.text.length>=6&&keyField_.text.length<=16){
        NSLog(@"登陆中...");
        [self logicRequest];
        loadButton_.enabled = NO;
    }else{
        NSLog(@"请核对你的账号密码");
        [self addAlertView];
        [userField_ becomeFirstResponder];
    }
}
// 注册小按钮
- (IBAction)registerAction:(id)sender{
    NSLog(@"点击了注册!!!");
    RegisterViewController *rvc = [[RegisterViewController alloc]init];
    [self presentViewController:rvc animated:YES completion:nil];
}
// 忘记密码小按钮
- (IBAction)forgetAction:(id)sender{
    NSLog(@"点击了忘记密码!!!");
    ForgetViewController *fvc = [[ForgetViewController alloc]init];
    [self presentViewController:fvc animated:YES completion:nil];
}

-(IBAction)QQLoogin:(id)sender{
    NSLog(@"点击了QQ登陆!!!");
    
}
-(IBAction)WeixingLoogin:(id)sender{
    NSLog(@"点击了WeChat登陆!!!");
    
}

// 登录请求
- (void)logicRequest{
    // 拼接参数
    NSString *param = [NSString stringWithFormat:@"{\"FunName\": \"Login\", \"Params\": { \"PhoneNo\": \"%@\", \"PassWord\": \"%@\" }}",userField_.text,keyField_.text];
    [networkSection getRequestDataBlock:IPUrl :param block:^(NSDictionary *json) {
        // Data为0表示注册失败,1表示验证码不对,2表示手机已存在,其他得到的是UserID
        NSString *dataString = [[json valueForKey:@"RET"] valueForKey:@"DATA"];
        if ([dataString isEqualToString:@"0"]) {
            // 账号密码错误
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addAlertView];
                loadButton_.enabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                HomeViewController *hvc = [[HomeViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hvc];
                [self presentViewController:nav animated:YES completion:^{
                    // 保存到本地
                    [[shareObjectModel shareObject] setAccount:userField_.text Password:keyField_.text];
                    [UserDataModel defaultDataModel].userID = dataString;
                }];
            });
        }
    }];
}

-(void)addAlertView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"请确认你的账户密码是否正确!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"账号密码错误");
    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:NULL];
}

@end
