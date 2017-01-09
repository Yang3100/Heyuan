    //
//  UserDataModel.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/4/11.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "UserDataModel.h"
#import "DataModel.h"

@interface UserDataModel () <NSCoding, NSURLConnectionDelegate,NSURLSessionDelegate> {
    UserDataModel *myData;
    NSTimer *keepSessionTimer;
}

@property (nonatomic, strong) NSURLConnection *urlConnection;

@end

@implementation UserDataModel

#define KEY_USERNAME (@"userName")
#define KEY_USERID (@"userID")
#define KEY_USERSEX (@"userSex")
#define KEY_USERCITY (@"userCity")
#define KEY_USERBORNDATE (@"userBornDate")
#define KEY_USERINTRODUCTION (@"userIntroduction")
#define KEY_USERIMAGE (@"userImage")
#define KEY_USERLIKESECTIONID (@"userLikeSectionID")
#define KEY_USERLIKEBOOKID (@"userLikeBookID")
#define KEY_USERLIKEBOOK (@"userLikeBook")
#define KEY_USERRECENTPLAY (@"userRecentPlay")
#define KEY_PLAYTIME (@"playTime")

+ (instancetype)defaultDataModel {
    
    static UserDataModel *userDataModel;
    if (!userDataModel) {
        userDataModel = [[super allocWithZone:NULL] init];
        [userDataModel initData];
    }
    
    return userDataModel;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self defaultDataModel];
}

- (void)initData {
    
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue1, ^{
        keepSessionTimer = [NSTimer timerWithTimeInterval:50.0 target:self selector:@selector(keepSession) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:keepSessionTimer forMode:NSRunLoopCommonModes];
    });
    
    _userLikeSection = [NSMutableArray array];
    _userLikeSectionID = [NSMutableArray array];
    _userLikeBookID = [NSMutableArray array];
    _userRecentPlayIDAndCount = [NSMutableDictionary dictionaryWithCapacity:10];
    _isChange = NO;
    _isReload = NO;
    _threePartReload = NO;
    
    [self loadLocalData];
    if (!myData.userName) {
        _userID = @"17713494987";
        _userSex = @"男";
        _userName = @"无用用户";
        _userCity = @"北京 北京 东城区";
        _userIntroduction = @"";
    }
    
    if (!myData.userImage) {
        _userImage = [UIImage imageNamed:@"add_user_icon"];
    }
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"threeData"];
    if (dic) {        
        if (dic[@"is_yellow_vip"]) {
            //为qq资料
            [self setQQData];
            return;
        }
        // 为微信资料
        [self setWXData];
    }
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormater stringFromDate:[NSDate date]];
    _userBornDate = date;
    
    [self loadLocalData];
}

- (void)keepSession {
    // 参数
    NSString *Right_ID = self.userID;
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Update_User_DateTime\", \"Params\": {\"DATA\":\"\"}}", Right_ID];
    NSLog(@"keepSession:%@",param);
    //OK
    [self linkInternet:param];
}

- (void)loginOut {
    // 参数
    NSString *Right_ID = self.userID;
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Exit_User\", \"Params\": {}}", Right_ID];
    NSLog(@"loginOut:%@",param);
    [self linkInternet:param];
    [self loginOutRemoveData];
}

- (void)getUserImage:(NSString *)url {
    
    if (url) {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (received) {
            _userImage = [UIImage imageWithData:received];
        }
        return;
    }
    
    // 参数
    NSString *Right_ID = self.userID;
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Get_User_Img\", \"Params\": {}}", Right_ID];
        //OK
//    NSLog(@"getImage:%@",param);
//    [self linkInternet:param];
        
    /*******************************************/
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL *URL=[NSURL URLWithString:IPUrl];//不需要传递参数

    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=20.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    //    NSLog(@"%@",param);    // 把拼接后的字符串转换为data，设置请求体
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict!=nil) {
//                NSLog(@"xxx返回数据:%@",dict);
                NSDictionary *d = [dict objectForKey:@"RET"];
                NSString *s = [d objectForKey:@"DATA"];
                
                NSData *imageData   = [[NSData alloc] initWithBase64Encoding:s];
                if (![s isEqualToString:@"(null)"]) {
                    _userImage = [UIImage imageWithData:imageData];
                }
                [[UserDataModel defaultDataModel] saveLocalData];
            }
            else
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
            });
    }];
    // 执行任务
    [dataTask resume];
    /*******************************************/
}

- (void)saveUserImage {
    // 参数
    NSString *Right_ID = self.userID;
    NSData *imageData = UIImageJPEGRepresentation(_userImage,0.7);
    //NSData 转NSString
    NSString* pictureDataString = [imageData base64Encoding];
    
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Set_User_Img\", \"Params\": {\"DATA\":\"%@\"}}", Right_ID, pictureDataString];
//    NSLog(@"saveImage: /**************/ param:%@",  param);
        //OK
    [self linkInternet:param];
}

- (void)getLike {
    // 参数
    NSString *Right_ID = self.userID;
    
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Get_SC_Data\", \"Params\": {\"Page_Index\":\"1\",\"Page_Count\":\"1000000\"}}", Right_ID];
    NSLog(@"getLike:%@", param);
    [self linkInternet:param];
}

- (void)saveLike {
    // 参数
    NSString *Right_ID = self.userID;
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Set_SC_Data\", \"Params\": {\"WJ_ID\":\"%@\",\"ZJ_ID\":\"%@\"}}", Right_ID, _userLikeBookID[0], @""];
        //OK
    NSLog(@"saveLike:%@", param);
    [self linkInternet:param];
}

- (void)getRecommend {
    // 参数
    NSString *Right_ID = self.userID;
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Get_Sys_Gx_WenJi_SC\", \"Params\": {\"Page_Index\":\"1\",\"Page_Count\":\"1000000\"}}", Right_ID];
    NSLog(@"getRecommend:%@", param);
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL *URL=[NSURL URLWithString:IPUrl];//不需要传递参数
    
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=20.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    //    NSLog(@"%@",param);    // 把拼接后的字符串转换为data，设置请求体
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict!=nil) {
                NSLog(@"xxx返回数据:%@",dict);
                NSDictionary *dic = [dict objectForKey:@"RET"];
                NSArray *Sys_GX_WenJI = [dic objectForKey:@"Sys_GX_WenJI"];
                for (NSDictionary *bookDic in Sys_GX_WenJI) {
                    NSString *wj_name = [bookDic objectForKey:@"WJ_NAME"];
                    NSString *wj_user = [bookDic objectForKey:@"WJ_USER"];
                    NSString *wj_img = [NSString stringWithFormat:@"%@/BizFunction/GX/WenJi/Img/%@",IP,[bookDic objectForKey:@"WJ_IMG"]];
                    NSString *wj_id = [bookDic objectForKey:@"WJ_ID"];
                    NSString *wj_content = [bookDic objectForKey:@"WJ_CONTENT"];
                    
                    BookData *book = [[BookData alloc] initWithDic:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    wj_name,@"bookName",
                                                                    wj_id,@"bookID",
                                                                    wj_img,@"bookImage",
                                                                    wj_user,@"authorName",
                                                                    wj_content,@"bookContent",
                                                                    nil]];
                    if (![[DataModel defaultDataModel].recommandBookID containsObject:book.bookID]) {
                        [[DataModel defaultDataModel].recommandBookID addObject:book.bookID];
                        [[[DataModel defaultDataModel] mutableArrayValueForKey:@"recommandBook"] addObject:book];
                    }
                }
//                NSString *wj_name = [dict]
            }
            else
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
            });
    }];
    // 执行任务
    [dataTask resume];
}

- (void)saveRecommend {
    // 参数
    NSString *Right_ID = self.userID;
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Add_Sys_Gx_WenJi_SC\", \"Params\": {\"DATA\":\"%@\"}}", Right_ID, _userLikeBookID[0]];
    NSLog(@"saveRecommend:%@", param);
    //OK
    [self linkInternet:param];
}

- (void)deleteRecommend {
    // 参数
    NSString *Right_ID = self.userID;
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Delete_Sys_Gx_WenJi_SC\", \"Params\": {\"DATA\":\"%@\"}}", Right_ID, _userLikeBookID];
    NSLog(@"deleteRecommend:%@", param);
    //OK
    [self linkInternet:param];
}

- (void)addLikeBookID:(NSString *)libraryNum {
    [_userLikeBookID insertObject:libraryNum atIndex:0];
    //    [self saveLike];
    NSLog(@"%@",_userLikeBookID);
    [self saveLocalData];
    //    [self getLike];
}

- (void)deleteLikeBookID:(NSString *)libraryNum {
    [_userLikeBookID removeObject:libraryNum];
    [self saveLocalData];
    NSLog(@"%@",_userLikeBookID);
}

- (void)addLikeSectionID:(NSString *)sectionID {
    
}

- (BOOL)addLikeSection:(NSDictionary *)dic {
    SectionData *data;
    if (DATA_MODEL.playingSection && [DATA_MODEL.playingSection.sectionID isEqualToString:dic[@"GJ_ID"]]) {
        data = DATA_MODEL.playingSection;
    } else {
        data = [DATA_MODEL getSectionWithDic:dic];
    }
    if (!DATA_MODEL.allSectionAndID[DATA_MODEL.allSectionAndID[data.sectionID]]) {
        [DATA_MODEL addSectionToAll:data];
    }
    if (_userLikeSectionID && [_userLikeSectionID containsObject:data.sectionID]) {
        return NO;
    }
    
    DATA_MODEL.addAllBook = YES;
    data.isLike = YES;
    [_userLikeSectionID insertObject:data.sectionID atIndex:0];
    [_userLikeSection insertObject:data atIndex:0];
//    [DATA_MODEL.userLikeSection insertObject:data atIndex:0];
//    [DATA_MODEL.userLikeSectionID insertObject:data.sectionID atIndex:0];
    
    USER_DATA_MODEL.isChange = YES;
    //        [[UserDataModel defaultDataModel] saveLocalData];
    [SAVE_MODEL saveLikeSection:data];
    return YES;
}

- (void)deleteLikeSectionID:(NSString *)sectionID {
    SectionData *data = DATA_MODEL.allSectionAndID[DATA_MODEL.allSectionAndID[sectionID]];
    DATA_MODEL.addAllBook = YES;
    data.isLike = NO;
    [_userLikeSectionID removeObject:data.sectionID];
    [_userLikeSection removeObject:data];
    USER_DATA_MODEL.isChange = YES;
    [SAVE_MODEL saveLikeSection:data];
}

- (BOOL)judgeIsLike:(NSString *)sectionID {
    if ([_userLikeSectionID containsObject:sectionID]) {
        return YES;
    }
    return NO;
}

- (void)judgeIsDelete {
    // 判断段落是否从收藏中删除
    NSInteger count = self.userLikeSectionID.count;
    NSMutableArray *arr = [NSMutableArray array];
    for (SectionData *sd in [DataModel defaultDataModel].userLikeSection) {
        if ([self.userLikeSectionID containsObject:sd.sectionID]) {
            [arr addObject:sd.sectionID];
        }
    }
    if (count != self.userLikeSectionID.count) {
        self.isChange = YES;
    }
    if (self.isChange) {
        //        userModel_.isChange = NO;
        [self.userLikeSectionID removeAllObjects];
        [self.userLikeSectionID addObjectsFromArray:arr];
        [self saveLocalData];
    }
}

// 设置某些特定数据
- (void)setData {
    _playTime = [NSString stringWithFormat:@"%d",[DataModel defaultDataModel].playTime];
    _userLikeBook = [DataModel defaultDataModel].userLikeBook;
    _userLikeSectionID = DATA_MODEL.userLikeSectionID;
}

// 保存为本地数据
- (void)saveLocalData {
    
    [self setData];
    // 存储自定义对象
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[UserDataModel defaultDataModel]];
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"userLocalData"];
    
//    [self saveUserInternetData];
//    [self getUserData];
//    NSLog(@"city:%@ name:%@ like:%@",self.userCity, self.userName, self.userLikeSectionID[0]);
}

- (void)loadLocalData {
    // 读取数据
    NSData *userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userLocalData"];
    myData = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    NSLog(@"city:%@ name:%@ like:%@",myData.userCity, myData.userName, myData.userLikeSectionID);
}

- (void)loginOutRemoveData {
    NSArray *keyArr = @[KEY_USERNAME,
                        KEY_USERID,
                        KEY_USERSEX,
                        KEY_USERCITY,
                        KEY_USERBORNDATE,
                        KEY_USERINTRODUCTION,
                        KEY_USERIMAGE,
                        KEY_USERLIKESECTIONID,
                        KEY_USERLIKEBOOKID];
    for (NSString *s in keyArr) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:s];
    }
}

- (void)getUserData {
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL *URL=[NSURL URLWithString:IPUrl];//不需要传递参数
    
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=20.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    // 参数
    NSString *Right_ID = self.userID;
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\":\"%@\",\"FunName\": \"Select_User\",\"Params\": {}}",Right_ID];
//    NSLog(@"%@",param);    // 把拼接后的字符串转换为data，设置请求体
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict!=nil) {
                NSLog(@"查询用户信息的返回数据:%@",dict);
                NSDictionary *dic = [dict objectForKey:@"RET"];
                NSDictionary *retDic = [dic objectForKey:@"Sys_GX_User"];
                
                if ([retDic isKindOfClass:[NSNull class]]) {
                    return;
                }
                _userUID = [retDic objectForKey:@"USER_UID"];
                _userID = [retDic objectForKey:@"USER_UID"];
                if (![[retDic objectForKey:@"USER_SEX"] isEqualToString:@""]) {
                    _userSex = [retDic objectForKey:@"USER_SEX"];
                    _userName = [retDic objectForKey:@"USER_BASE_NAME"];
                    _userCity = [retDic objectForKey:@"USER_CITY"];
                    _userIntroduction = [retDic objectForKey:@"USER_CONTENT"];
                    
                    NSDateFormatter *dateFormater1 = [[NSDateFormatter alloc] init];
                    [dateFormater1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *date1 = [dateFormater1 dateFromString:[retDic objectForKey:@"USER_BIRTHDAY"]];
                    
                    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
                    [dateFormater setDateFormat:@"yyyy-MM-dd"];
                    NSString *date = [dateFormater stringFromDate:date1];
                    
                    _userBornDate = date;
                    
                    [self saveLocalData];
                }
            }
            else
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
            });
    }];
    // 执行任务
    [dataTask resume];
}

- (void)linkInternet: (NSString *)param {
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL *URL=[NSURL URLWithString:IPUrl];//不需要传递参数
    
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=20.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    //    NSLog(@"%@",param);    // 把拼接后的字符串转换为data，设置请求体
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict!=nil) {
                NSLog(@"xxx返回数据:%@",dict);
//                [[UserDataModel defaultDataModel] saveUserInternetData];
            }
            else
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
            });
    }];
    // 执行任务
    [dataTask resume];
}

- (void)saveUserInternetData {
    
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 设置请求路径
    NSURL *URL=[NSURL URLWithString:IPUrl];//不需要传递参数
    
    // 创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=20.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    //    NSLog(@"%@",param);    // 把拼接后的字符串转换为data，设置请求体
    // 参数
    NSString *Right_ID = self.userID;
    NSString *USER_UID = self.userUID;
    NSString *USER_NAME = self.userName;
    NSString *USER_BASE_NAME = self.userName;
    NSString *USER_TX = @"";
    NSString *USER_PHONE = @"17713605496";
    NSString *USER_PASS = @"123456";
    NSString *USER_SEX = self.userSex;
    NSString *USER_BIRTHDAY = self.userBornDate;
    NSString *USER_CITY = self.userCity;
    NSString *USER_CONTENT = self.userIntroduction;
    NSString *USER_ADD_DATE  = @"2016-1-1";
    NSString *USER_IS_DELETE = @"";
    NSString *UESR_LAST_DATE = @"2016-1-1";
//    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Update_User\", \"Params\": {\"Sys_GX_User\": {\"USER_UID\":\"%@\",\"USER_NAME\":\"%@\",\"USER_BASE_NAME\":\"%@\",\"USER_TX\":\"%@\",\"USER_PHONE\":\"%@\",\"USER_PASS\":\"%@\",\"USER_SEX\":\"%@\",\"USER_BIRTHDAY\":\"%@\",\"USER_CITY\":\"%@\",\"USER_CONTENT\":\"%@\",\"USER_ADD_DATE\":\"%@\",\"USER_IS_DELETE\":\"%@\",\"USER_LAST_DATE\":\"%@\"}}}",Right_ID,USER_UID,USER_NAME,USER_BASE_NAME,USER_TX,USER_PHONE,USER_PASS,USER_SEX,USER_BIRTHDAY,USER_CITY,USER_CONTENT,USER_ADD_DATE,USER_IS_DELETE,UESR_LAST_DATE];
    NSString *param = [NSString stringWithFormat:@"{\"Right_ID\": \"%@\", \"FunName\": \"Update_User\", \"Params\": {\"Sys_GX_User\": {\"USER_BASE_NAME\":\"%@\",\"USER_SEX\":\"%@\",\"USER_BIRTHDAY\":\"%@\",\"USER_CITY\":\"%@\",\"USER_CONTENT\":\"%@\",\"USER_UID\":\"%@\"}}}",Right_ID,USER_BASE_NAME,USER_SEX,USER_BIRTHDAY,USER_CITY,USER_CONTENT,USER_UID];
    NSLog(@"saveUserInternetData:%@",param);    // 把拼接后的字符串转换为data，设置请求体
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict!=nil) {
                NSLog(@"修改用户资料的返回数据:%@",dict);
            }
            else
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // 服务器无反应
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // 无网络
            });
    }];
    // 执行任务
    [dataTask resume];
}

- (void)saveThreePartData:(NSString *)data {
    
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];//转化为data
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];//转化为字典
    
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"threeData"];
    if (dic[@"is_yellow_vip"]) {
        //为qq资料
        [self setQQData];
        return;
    }
    // 为微信资料
    [self setWXData];
}

- (void)setQQData {
    NSDictionary *dic = [self getThreePartData];
    
//    _userID = dic[@""];
    _userSex = dic[@"gender"];
    _userName = dic[@"nickname"];
    _userCity = [NSString stringWithFormat:@"%@--%@",dic[@"province"],dic[@"city"]];
//    _userIntroduction = dic[@""];
    [self getUserImage:dic[@"figureurl_qq_1"]];
    _threePartReload = YES;
}

- (void)setWXData {
    NSDictionary *dic = [self getThreePartData];
    NSLog(@"*********************%@",dic);
    //    _userID = dic[@""];
    _userSex = dic[@"sex"];
    int a = [dic[@"sex"] intValue];
    if (a) {
        _userSex = @"男";
    } else {
        _userSex = @"女";
    }
    _userName = dic[@"nickname"];
    _userCity = [NSString stringWithFormat:@"%@--%@",dic[@"province"],dic[@"city"]];
    //    _userIntroduction = dic[@""];
    [self getUserImage:dic[@"headimgurl"]];
    _threePartReload = YES;
}

- (NSDictionary *)getThreePartData {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"threeData"];
    return dic;
}

#pragma mark NSCoding

// userDefault存储的编码解码
- (void)encodeWithCoder:(NSCoder*)coder{
    [coder encodeObject:_userName forKey:KEY_USERNAME];
    [coder encodeObject:_userID forKey:KEY_USERID];
    [coder encodeObject:_userSex forKey:KEY_USERSEX];
    [coder encodeObject:_userCity forKey:KEY_USERCITY];
    [coder encodeObject:_userBornDate forKey:KEY_USERBORNDATE];
    [coder encodeObject:_userIntroduction forKey:KEY_USERINTRODUCTION];
    [coder encodeObject:_userImage forKey:KEY_USERIMAGE];
    [coder encodeObject:_userLikeSectionID forKey:KEY_USERLIKESECTIONID];
    [coder encodeObject:_userLikeBookID forKey:KEY_USERLIKEBOOKID];
    [coder encodeObject:_userRecentPlayIDAndCount forKey:KEY_USERRECENTPLAY];
    [coder encodeObject:_playTime forKey:KEY_PLAYTIME];
    [coder encodeObject:_userLikeBook forKey:KEY_USERLIKEBOOK];
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init])
    {
        if (decoder == nil)
        {
            return self;
        }
        _userName = [decoder decodeObjectForKey:KEY_USERNAME];
        _userID = [decoder decodeObjectForKey:KEY_USERID];
        _userSex = [decoder decodeObjectForKey:KEY_USERSEX];
        _userCity = [decoder decodeObjectForKey:KEY_USERCITY];
        _userBornDate = [decoder decodeObjectForKey:KEY_USERBORNDATE];
        _userIntroduction = [decoder decodeObjectForKey:KEY_USERINTRODUCTION];
        _userImage = [decoder decodeObjectForKey:KEY_USERIMAGE];
        _userLikeSectionID = [decoder decodeObjectForKey:KEY_USERLIKESECTIONID];
        _userLikeBookID = [decoder decodeObjectForKey:KEY_USERLIKEBOOKID];
        _userRecentPlayIDAndCount = [decoder decodeObjectForKey:KEY_USERRECENTPLAY];
        _playTime = [decoder decodeObjectForKey:KEY_PLAYTIME];
        _userLikeBook = [decoder decodeObjectForKey:KEY_USERLIKEBOOK];
    }
    return self;
}


@end
