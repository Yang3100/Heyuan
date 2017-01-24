//
//  loginView.m
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/24.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "loginViewController.h"
#import "HomeViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"

#define chushizuobiao ([UIScreen mainScreen].bounds.size.height/2)

@interface loginViewController () <UITextFieldDelegate,TencentSessionDelegate> {
    UITextField *userField_, *keyField_;
    UITextField *curTextField_;
    UILabel *userLabel_ , *keyLabel_;
    UIImageView *logoImage_;
    UIButton *loadButton_;
    UIImageView *backImage_;
    UILabel *titleLabel_;
    UIButton *registerBtn_;
    UIButton *forgetBtn_;
    
    NSString *openID;
    NSString *access_token;
    
    TencentOAuth *_tencentOAuth;
}

@property (nonatomic ,strong) UIImageView *DishangfangLoogin;
@property (nonatomic ,strong) UIButton *QQLoogin;
@property (nonatomic ,strong) UIButton *WeixingLoogin;

@end

@implementation loginViewController

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
//    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.forgetBtn];
    [self.view addSubview:self.QQLoogin];
    [self.view addSubview:self.WeixingLoogin];
    [self.view addSubview:self.DishangfangLoogin];
    //添加观察者,监听键盘弹出，隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    // 一次性执行：
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXLogin:) name:@"wechatLoadSucessful" object:nil];
//    });
}


- (UILabel *)titleLabel {
    if (!titleLabel_) {
        titleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 50, 30)];
        titleLabel_.textColor = RGB255_COLOR(68, 68, 68, 1);
        titleLabel_.text = @"登录";
        titleLabel_.textAlignment = NSTextAlignmentLeft;
        [titleLabel_ setFont:[UIFont systemFontOfSize:16]];
    }
    return titleLabel_;
}

- (UIImageView *)backImage{
    if (!backImage_) {
        backImage_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 3)];
        backImage_.image = loginCachePicture;
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
        userLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(50, chushizuobiao-60, 55, 30)];
        userLabel_.text = @"用户:";
        userLabel_.textColor = RGB255_COLOR(68, 68, 68, 1);
    }
    return userLabel_;
}

//密码输入提示
- (UILabel *)keyLabel{
    if (!keyLabel_) {
        keyLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(50, chushizuobiao, 55, 30)];
        keyLabel_.text = @"密码:";
        keyLabel_.textColor = RGB255_COLOR(68, 68, 68, 1);
    }
    return keyLabel_;
}

//用户名输入框
- (UITextField *)userField{
    if (!userField_) {
        userField_ = [[UITextField alloc] initWithFrame:CGRectMake(userLabel_.center.x + 22.5, chushizuobiao-60, SCREEN_WIDTH/2, 30)];
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
        keyField_ = [[UITextField alloc] initWithFrame:CGRectMake(userLabel_.center.x + 22.5, chushizuobiao, SCREEN_WIDTH/2, 30)];
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
        loadButton_.frame = CGRectMake(50, chushizuobiao+50, SCREEN_WIDTH-100, 50);
        [loadButton_ setTitle:@"登录" forState:UIControlStateNormal];
        loadButton_.backgroundColor = RGB255_COLOR(0.0, 0.0, 0.0, 0.35);
        [loadButton_ addTarget:self action:@selector(loadAction:) forControlEvents:UIControlEventTouchUpInside];
        loadButton_.tintColor = [UIColor whiteColor];
    }
    return loadButton_;
}

- (UIButton *)registerBtn{
    if (!registerBtn_) {
        registerBtn_ = [UIButton buttonWithType:UIButtonTypeSystem];
        registerBtn_.frame = CGRectMake(28, chushizuobiao+110, 80, 30);
        registerBtn_.tintColor = RGB255_COLOR(68, 68, 68, 1);
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
        forgetBtn_.frame = CGRectMake(SCREEN_WIDTH-130, chushizuobiao+110, 80, 30);
        forgetBtn_.tintColor = RGB255_COLOR(68, 68, 68, 1);
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
- (UIImageView *)DishangfangLoogin{
    if (!_DishangfangLoogin) {
        _DishangfangLoogin=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dishangfangloog"]];
        _DishangfangLoogin.frame=CGRectMake(0, chushizuobiao+140, SCREEN_WIDTH, 30);
    }
    return _DishangfangLoogin;
}
//QQ登陆
-(UIButton*)QQLoogin{
    if (!_QQLoogin) {
        _QQLoogin=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, chushizuobiao+180, 70, 70)];
        UIImage *QQimage=[UIImage imageNamed:@"123loog"];
        [_QQLoogin setImage:QQimage forState:UIControlStateNormal];
        [_QQLoogin addTarget:self action:@selector(QQLoogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QQLoogin;
}
-(UIButton*)WeixingLoogin{
    if (!_WeixingLoogin) {
        _WeixingLoogin=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+25, chushizuobiao+180, 68, 70)];
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

#pragma mark - 第三方登录
-(IBAction)QQLoogin:(id)sender{
    NSLog(@"点击了QQ登陆!!!");
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105855960" andDelegate:self];
    NSArray *permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_SHARE,
                            nil];
    [_tencentOAuth authorize:permissions];
}
-(IBAction)WeixingLoogin:(id)sender{
    NSLog(@"点击了WeChat登陆!!!");
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"12345aa" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

#pragma mark - WeChat登陆成功之后获取token
- (void)WXLogin:(NSNotification *)notifi {
    [self getDataString:notifi.object[@"code"]];
}

- (void)getDataString:(NSString*)notificode{
    NSString *string = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxeb4693506532bea3&secret=323a0eb9b8f7f0505f08c98f4511b8ff&code=%@&grant_type=authorization_code",notificode];
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:string];
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    /* 其中缓存协议是个枚举类型包含：
     NSURLRequestUseProtocolCachePolicy（基础策略）
     NSURLRequestReloadIgnoringLocalCacheData（忽略本地缓存）
     NSURLRequestReturnCacheDataElseLoad（首先使用缓存，如果没有本地缓存，才从原地址下载）
     NSURLRequestReturnCacheDataDontLoad（使用本地缓存，从不下载，如果本地没有缓存，则请求失败，此策略多用于离线操作）
     NSURLRequestReloadIgnoringLocalAndRemoteCacheData（无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载）
     NSURLRequestReloadRevalidatingCacheData（如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载）*/
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
    access_token = [dict valueForKey:@"access_token"];
    openID = [dict valueForKey:@"openid"];
    // 后台对数据类型的需要
    NSString *pass = @"kk23456789";
    NSDictionary *kj_dict = @{@"OpenID":openID,@"Password":pass};
    NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"WeiXin_Login",@"Params":kj_dict}];
    // 网络请求
    [networkSection getLoadJsonDataWithUrlString:IPUrl param:paramString];
    
    //回调函数获取数据
    [networkSection setGetLoadRequestDataClosuresCallBack:^(NSDictionary *json) {
        NSLog(@"-----%@",json);
        NSString *dataString = [[json valueForKey:@"RET"] valueForKey:@"Right_ID"];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            HomeViewController *hvc = [[HomeViewController alloc] init];
            HomeNavController *nav = [[HomeNavController alloc] initWithRootViewController:hvc];
            CATransition *animation = [CATransition animation];
            animation.duration = 1.0;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = @"rippleEffect";
            [self.view.window.layer addAnimation:animation forKey:nil];
            [self presentViewController:nav animated:YES completion:^{
                // 获取用户资料
                [self wechatLoginByRequestForUserInfo];
                // 保存到本地
                [[shareObjectModel shareObject] setAccount:openID Password:pass];
                [UserDataModel defaultDataModel].userID = dataString;
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatLoadSucessful" object:nil];
            }];
        });
    }];
}

- (void)wechatLoginByRequestForUserInfo {
    NSString *userUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", access_token, openID];
    // 请求用户数据
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:userUrlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [USER_DATA_MODEL saveThreePartData:[[NSString alloc] initWithData:received  encoding:NSUTF8StringEncoding]];
}

#pragma TencentSessionDelegate
/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}
-(void)tencentDidLogin{
    NSLog(@"----ok-----");
    NSLog(@"openId:%@",_tencentOAuth.openId);
    // 后台对数据类型的需要
    NSString *pass = @"abc1234568";
    NSDictionary *dict = @{@"OpenID":_tencentOAuth.openId,@"Password":pass};
    NSString *paramString = [networkSection getParamStringWithParam:@{@"FunName":@"WeiXin_Login",@"Params":dict}];
    // 网络请求
    [networkSection getLoadJsonDataWithUrlString:IPUrl param:paramString];
    
    //回调函数获取数据
    [networkSection setGetLoadRequestDataClosuresCallBack:^(NSDictionary *json) {
        NSLog(@"-----%@",json);
        NSString *dataString = [[json valueForKey:@"RET"] valueForKey:@"Right_ID"];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            HomeViewController *hvc = [[HomeViewController alloc] init];
            HomeNavController *nav = [[HomeNavController alloc] initWithRootViewController:hvc];
            CATransition *animation = [CATransition animation];
            animation.duration = 1.0;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = @"rippleEffect";
            [self.view.window.layer addAnimation:animation forKey:nil];
            [self presentViewController:nav animated:YES completion:^{
                // 保存到本地
                [[shareObjectModel shareObject] setAccount:_tencentOAuth.openId Password:pass];
                [UserDataModel defaultDataModel].userID = dataString;
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatLoadSucessful" object:nil];
            }];
        });
    }];
    
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        //获取用户信息。 调用这个方法后，qq的sdk会自动调用
        //- (void)getUserInfoResponse:(APIResponse*) response
        //这个方法就是 用户信息的回调方法。
        [_tencentOAuth getUserInfo];
    }else{
        NSLog(@"accessToken 没有获取成功");
    }
}
//-(NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams{
//    NSLog(@"----%@********%@-----",permissions,extraParams);
//    return permissions;
//}
- (void)getUserInfoResponse:(APIResponse*)response{
    NSLog(@"*********");
    NSLog(@" response %@",response.message);
    [USER_DATA_MODEL saveThreePartData:response.message];
    //    NSLog(@"*********%@",response.jsonResponse[@"figureurl_qq_2"]);
}

-(void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        NSLog(@"用户点击取消按键,主动退出登录");
    }else{
        NSLog(@"其他原因,导致登录失败");
    }
}
-(void)tencentDidNotNetWork{
    NSLog(@"没有网络了， 怎么登录成功呢");
}


// 登录请求
- (void)logicRequest{
    // 拼接参数
    NSString *param = [NSString stringWithFormat:@"{\"FunName\": \"Login\", \"Params\": {\"PhoneNo\":\"%@\", \"PassWord\":\"%@\"}}",userField_.text,keyField_.text];
    // 网络请求
    [networkSection getLoadJsonDataWithUrlString:IPUrl param:param];
    
    //回调函数获取数据
    [networkSection setGetLoadRequestDataClosuresCallBack:^(NSDictionary *json) {
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
                USER_DATA_MODEL.userID = dataString;
                [USER_DATA_MODEL getUserData];
                [USER_DATA_MODEL getUserImage:nil];
                HomeViewController *hvc = [[HomeViewController alloc] init];
                HomeNavController *nav = [[HomeNavController alloc] initWithRootViewController:hvc];
                CATransition *animation = [CATransition animation];
                animation.duration = 1.0;
                animation.timingFunction = UIViewAnimationCurveEaseInOut;
                animation.type = @"rippleEffect";
                [self.view.window.layer addAnimation:animation forKey:nil];
                [self presentViewController:nav animated:YES completion:^{
                    // 保存到本地
                    [[shareObjectModel shareObject] setAccount:userField_.text Password:keyField_.text];
                    [UserDataModel defaultDataModel].userID = dataString;
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatLoadSucessful" object:nil];
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
