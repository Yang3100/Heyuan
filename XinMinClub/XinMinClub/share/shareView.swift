//
//  shareView.swift
//  shareView
//
//  Created by 杨科军 on 2016/11/30.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit

@objc protocol shareViewDelegate:NSObjectProtocol {
    @objc optional func didSelectItem(index:Int)
}

class shareView: UIView ,UICollectionViewDelegate, UICollectionViewDataSource ,TencentSessionDelegate ,WXApiDelegate ,URLSessionDelegate {
    
    var _tencentOAuth:TencentOAuth?
    var _permissions = NSArray()
    
    var delegate:shareViewDelegate!
    var MLLayout = MyLinearLayout()
    var backView = UIControl()
    var controlView = UIView()
    var shareButtonCollection = UICollectionView(frame:CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
    var label = UILabel()
    
    init(frame: CGRect, shareData:NSDictionary) {
        super.init(frame:frame)
//        print("shareData:\(shareData)")
//        self.backgroundColor = UIColor.cyan
        _tencentOAuth = TencentOAuth.init(appId:"1105855960", andDelegate:nil)
        self.initView()
    }
    
    func initView() {
        
        backView = UIControl.init(frame: MY_CGRECT(x: 0, y: 0, w: SCREEN_WIDTH, h: SCREEN_HEIGHT))
        backView.backgroundColor = RGB255_COLOR(r: 0, g: 0, b: 0, a: 0.65)
        backView.addTarget(self, action: #selector(backTouch), for: .touchUpInside)
        
        MLLayout = MyLinearLayout.init(frame: MY_CGRECT(x: 0, y: SCREEN_HEIGHT-SCREEN_HEIGHT/3, w: SCREEN_WIDTH, h: SCREEN_HEIGHT/3))
        MLLayout.orientation = MyLayoutViewOrientation_Vert
        MLLayout.wrapContentHeight = false
        MLLayout.backgroundColor = RGB255_COLOR(r: 220, g: 220, b: 220, a: 1)
        
        label = UILabel.init(frame: MY_CGRECT(x: 0, y: 0, w: SCREEN_WIDTH, h: 40))
        label.myBottomMargin = 1
        label.myLeftMargin = 0
        label.myRightMargin = 0
        label.myHeight = MLLayout.frame.size.height*0.2
        label.text = "分享"
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = RGB255_COLOR(r: 255, g: 255, b: 255, a: 1)
        label.textColor = RGB255_COLOR(r: 190, g: 190, b: 190, a: 1)
        MLLayout.addSubview(label)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width:(SCREEN_WIDTH-40)/8,height:(SCREEN_WIDTH-40)/8)
        layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5)
        shareButtonCollection = UICollectionView.init(frame: MY_CGRECT(x: 0, y: 0, w: SCREEN_WIDTH, h: 50), collectionViewLayout: layout)
        shareButtonCollection.delegate = self
        shareButtonCollection.dataSource = self
        shareButtonCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier:"13")
        shareButtonCollection.myTopMargin = 1
        shareButtonCollection.myBottomMargin = 1
        shareButtonCollection.backgroundColor = RGB255_COLOR(r: 255, g: 255, b: 255, a: 1)
        shareButtonCollection.myHeight = MLLayout.frame.size.height*0.6
        MLLayout.addSubview(shareButtonCollection)
        
        controlView = UIView.init(frame: MY_CGRECT(x: 0, y: 0, w: SCREEN_WIDTH, h: 40))
        controlView.myHeight = MLLayout.frame.size.height*0.2
        controlView.backgroundColor = RGB255_COLOR(r: 255, g: 255, b: 255, a: 1)
        MLLayout.addSubview(controlView)

        backView.addSubview(MLLayout)
        self.addSubview(backView)
    }
    
    func pushView(controller:UIViewController,view:UIView) {
        let window = UIApplication.shared.windows.last
        view.alpha = 0
        window?.addSubview(view)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            view.alpha = 1
        }, completion: { (true) in
            
        })
    }
    
    func popView(controller:UIViewController,view:UIView) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            view.alpha = 0
        }, completion: { (true) in
            view.removeFromSuperview()
        })
    }
    
    func backTouch() {
        popView(controller: UIViewController(), view: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"13", for:indexPath)
        //        cell.backgroundColor = UIColor.white
        let label = UIImageView.init(frame:CGRect(x:0, y:0, width:(SCREEN_WIDTH-40)/8, height:(SCREEN_WIDTH-40)/8))
//        label.text = ["111","2222","33333","444444"][indexPath.row]
//        label.font = UIFont(name:"CourierNewPSMT", size:16)
        label.image = UIImage.init(named: (["QQ","kongjian","weixin","pengyouquan"][indexPath.row]))
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = RGB255_COLOR(r: 220, g: 220, b: 220, a: 1).cgColor
        label.layer.cornerRadius = 5
//        label.textAlignment = .center
//        label.backgroundColor = UIColor.green
        cell.addSubview(label)
//        cell.backgroundColor = UIColor.orange
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ["QQ","kongjian","weixin","pengyouquan"].count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
/*        if (self.delegate != nil) {
 *            if self.delegate.responds(to:#selector(shareViewDelegate.didSelectItem(index:))) {
 *                self.delegate.didSelectItem!(index:indexPath.item)
 *            }
 *        }
 */
        if indexPath.row == 0 {
            
        }
        if indexPath.row == 1 {
            
        }
        if indexPath.row == 2 {
            
        }
        if indexPath.row == 3 {
            
        }
    }
    
    
    /**
     处理QQ在线状态的回调
     */
    public func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        
    }
    
    /**
     处理来至QQ的响应
     */
//    public func onResp(_ resp: QQBaseResp!) {
//        //确保是对我们QQ分享操作的回调
//        if resp.isKind(of: SendMessageToQQResp.self) {
//            //QQApi应答消息类型判断（手Q -> 第三方应用，手Q应答处理分享消息的结果）
//            if uint(resp.type) == ESENDMESSAGETOQQRESPTYPE.rawValue {
//                let title = resp.result == "0" ? "分享成功" : "分享失败"
//                var message = ""
//                switch(resp.result){
//                case "-1":
//                    message = "参数错误"
//                case "-2":
//                    message = "该群不在自己的群列表里面"
//                case "-3":
//                    message = "上传图片失败"
//                case "-4":
//                    message = "用户放弃当前操作"
//                case "-5":
//                    message = "客户端内部处理错误"
//                default: //0
//                    //message = "成功"
//                    break
//                }
//                
//                //显示消息
//                showAlert(title:title, message:message)
//            }
//        }
//    }
    
    /**
     处理来至QQ的请求
     */
//    func onReq(_ req: QQBaseReq!) {
//        
//    }
    
    func QQshareAction(_ sender: UIButton) {
        //        QQShare.sendText(text:"测试纯文本分享到聊天界面")
        //        QQShare.sendVideo(videoUrlString:"http://www.tudou.com/programs/view/HEmqLDIH34E/", previewImageUrl:"http://img.2258.com/d/file/yule/music/huayu/2015-01-14/ae72c4ae39adc925ebe8e137b6cbb81a.jpg", title:"周董《兰亭序》", descriotion:"水墨动画版与一般的动画片不同，水墨动画没有轮廓线，水墨在宣纸上自然渲染，浑然天成，一个个场景就是一幅幅出色的水墨画。角色的动作和表情优美灵动，泼墨山水的背景豪放壮丽，柔和的笔调充满诗意。它体现了中国画“似与不似之间”的美学，意境深远。", isShsreToQZone:false)
        QQShare.sendMusic(musicUrlString: "http://music.163.com/outchain/player?type=2&id=436514312&auto=1&height=66", previewImageUrl: "http://sd.china.com.cn/uploadfile/2016/1025/20161025040103244.jpg", title:"成都--赵雷", descriotion:"做分享测试", isShsreToQZone:false)
    }
    
//    func shareNavigationAction(_ sender: UIBarButtonItem) {
//        let dic = NSDictionary()
//        let sv = shareView(frame:self.bounds,shareData:dic)
//        self.topView().addSubview(sv)
//    }
    
//    func topView() ->(UIView) {
//        // 返回在最顶上的视图
//        let win:UIWindow = UIApplication.shared.keyWindow!
//        return win.subviews[0]
//    }
    
    func shareAction(_ sender: UIButton) {
        //        if wechatShare.sendImage(image:UIImage(named:"pikaqiu")!, inScene:WXSceneSession) {
        //            print("分享成功")
        //        }else {
        //            print("分享失败")
        //        }
        //        if wechatShare.sendmusic(musicUrl:"http://music.163.com/#/song?id=436514312&autoplay=true",musicDataUrl:"http://music.163.com/#/song?id=202373&autoplay=true", title:"成都--赵雷", description:"做分享测试", thumbnail:UIImage(named:"屏幕快照 2016-08-27 12.58.32")!, inScene: WXSceneFavorite) {
        //            print("分享成功")
        //        }
        if wechatShare.sendvideo(musicUrl: "http://www.tudou.com/programs/view/HEmqLDIH34E/", title:"周董《兰亭序》", description:"水墨动画版与一般的动画片不同，水墨动画没有轮廓线，水墨在宣纸上自然渲染，浑然天成，一个个场景就是一幅幅出色的水墨画。角色的动作和表情优美灵动，泼墨山水的背景豪放壮丽，柔和的笔调充满诗意。它体现了中国画“似与不似之间”的美学，意境深远。", thumbnail:UIImage(named:"3")!, inScene:WXSceneTimeline) {
            print("yes")
        }
    }
    
    //显示消息
    func showAlert(title:String="mo", message:String="ren"){
        let alertController = UIAlertController(title:title, message:message, preferredStyle:.alert)
        let cancelAction = UIAlertAction(title:"确定", style:.cancel, handler:nil)
        alertController.addAction(cancelAction)
//        self.getCurrentVC().present(alertController, animated:true, completion: nil)
    }
    
    //获取当前view所在的viewCOntroller
//    func getCurrentVC() ->UIViewController{
//        var next = self.next
//        repeat{
//            if next!.isKind(of:UIViewController.self) { // 判断类型
//                if next!.isKind(of:UIViewController.self) {
//                    return (next as? UIViewController)!
//                }
//            }
//            next = next!.next
//        }while next != nil
//        return UIViewController()
//    }
    
    //MARK: qq登录
    @IBAction func QQLogin(_ sender: AnyObject) {
        _tencentOAuth?.authorize(["add_share", "get_user_info" ,"get_simple_userinfo" ,"add_t"], inSafari: false)
    }
    //MARK: qq登录回调
    func tencentDidLogin() {
        if (self._tencentOAuth!.accessToken != nil) && 0 != _tencentOAuth?.accessToken.lengthOfBytes(using: .utf8)
        {
            // 记录登录用户的OpenID、Token以及过期时间
            
            //获取用户信息
            _tencentOAuth?.getUserInfo()
        }
        else
        {
            //"登录不成功 没有获取accesstoken";
        }
    }
    
    // 用户信息回调
    func getUserInfoResponse(_ response: APIResponse!) {
        
        print(response.jsonResponse)
    }
    
    //登录失败
    func tencentDidNotLogin(_ cancelled: Bool) {
        if cancelled
        {
            //"用户取消登录";
        }
        else
        {
            //"登录失败";
        }
    }
    func tencentDidNotNetWork() {
        //无网络
    }
    
    
    //MARK: WeChat登录
    @IBAction func WeiChatLogin(_ sender: AnyObject) {
        
        let accessToken = UserDefaults.standard.object(forKey: WX_ACCESS_TOKEN)
        let openID = UserDefaults.standard.object(forKey: WX_OPEN_ID)
        // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
        if !(accessToken == nil) && !(openID == nil) {
            if !(((accessToken as! String) != "") && ((openID as! String) != "")) {return}
            //            let manager = AFHTTPRequestOperationManager()
            let refreshToken = UserDefaults.standard.object(forKey: WX_REFRESH_TOKEN)!
            let refreshUrlStr = "\(WX_BASE_URL)/oauth2/refresh_token?appid=\(WXDoctor_App_ID)&grant_type=refresh_token&refresh_token=\(refreshToken)"
            
            // 构建Request
            let urlString = refreshUrlStr
            let encodeUrl = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: encodeUrl)!
            let request = URLRequest(url: url)
            // 构建session的congigurations
            let sessionConfiguration = URLSessionConfiguration.default
            // 构建NSURLSession
            let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
            
            let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                //转dic
                let dic = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                let refreshDict = dic
                let reAccessToken = (refreshDict[WX_ACCESS_TOKEN]) as! NSString
                if reAccessToken.boolValue {
                    UserDefaults.standard.set(reAccessToken, forKey: WX_ACCESS_TOKEN)
                    UserDefaults.standard.set(((refreshDict[WX_OPEN_ID]) as! String), forKey: WX_OPEN_ID)
                    UserDefaults.standard.set(((refreshDict[WX_REFRESH_TOKEN]) as! String), forKey: WX_REFRESH_TOKEN)
                    UserDefaults.standard.synchronize()
                    // 当存在reAccessToken不为空时直接执行AppDelegate中的wechatLoginByRequestForUserInfo方法
                    //                    !self.requestForUserInfoBlock ?? self.requestForUserInfoBlock()
                }
                else {
                    self.wechatLogin()
                }
            })
            dataTask.resume()
        } else {
            self.wechatLogin()
        }
        
    }
    
    //微信登录
    func wechatLogin() {
        //判断是否安装微信
        if WXApi.isWXAppInstalled() {
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo"
            req.state = "App"
            WXApi.send(req)
        }
        else {
            
        }
    }
    
    func onResp(_ resp: BaseResp!) {
        // 向微信请求授权后,得到响应结果
        if (resp is SendAuthResp) {
            let temp = (resp as! SendAuthResp)
            let accessUrlStr = NSString.init(format: "\(WX_BASE_URL)/oauth2/access_token?appid=\(WXDoctor_App_ID)&secret=\(WXDoctor_App_Secret)&code=%@&grant_type=authorization_code" as NSString, temp.code)
            print(accessUrlStr as String)
            
            
            // 构建Request
            let urlString = accessUrlStr
            let encodeUrl = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            print("\(encodeUrl)")
            let url = URL(string: encodeUrl)!
            let request = URLRequest(url: url)
            // 构建session的congigurations
            let sessionConfiguration = URLSessionConfiguration.default
            // 构建NSURLSession
            let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
            let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                //转dic
                let dic = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                //                print("请求access的response = \(data)")
                let accessDict = dic
                let accessToken = ((accessDict[WX_ACCESS_TOKEN]) as! String)
                let openID = ((accessDict[WX_OPEN_ID]) as! String)
                let refreshToken = ((accessDict[WX_REFRESH_TOKEN]) as! String)
                // 本地持久化，以便access_token的使用、刷新或者持续
                if !(accessToken == "") && !(openID == "") {
                    UserDefaults.standard.set(accessToken, forKey: WX_ACCESS_TOKEN)
                    UserDefaults.standard.set(openID, forKey: WX_OPEN_ID)
                    UserDefaults.standard.set(refreshToken, forKey: WX_REFRESH_TOKEN)
                    UserDefaults.standard.synchronize()
                    // 命令直接同步到文件里，来避免数据的丢失
                }
                self.wechatLoginByRequestForUserInfo()
                
            })
            dataTask.resume()
        }
    }
    
    func wechatLoginByRequestForUserInfo() {
        let accessToken = UserDefaults.standard.object(forKey: WX_ACCESS_TOKEN)!
        let openID = UserDefaults.standard.object(forKey: WX_OPEN_ID)!
        let userUrlStr = "\(WX_BASE_URL)/userinfo?access_token=\(accessToken)&openid=\(openID)"
        // 请求用户数据
        // 构建Request
        let urlString = userUrlStr
        let encodeUrl = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print("\(encodeUrl)")
        let url = URL(string: encodeUrl)!
        let request = URLRequest(url: url)
        // 构建session的congigurations
        let sessionConfiguration = URLSessionConfiguration.default
        // 构建NSURLSession
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            //转dic
            let dic = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            print(dic)
        })
        dataTask.resume()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
