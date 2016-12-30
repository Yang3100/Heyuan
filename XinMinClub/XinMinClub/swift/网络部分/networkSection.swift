//
//  networkSection.swift
//  Home
//
//  Created by 杨科军 on 2016/12/9.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit

@objc class networkSection:NSObject {
    
    //MARK:后台对数据类型的需求转换
    class func getParamString(param:Any) ->String {
        let data = try! JSONSerialization.data(withJSONObject:param, options:JSONSerialization.WritingOptions.prettyPrinted)
        let string = String(data:data, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        
        return string!
    }
    class func dictionary(withJsonString jsonString: String) ->NSDictionary {
        let jsonData = jsonString.data(using: String.Encoding.utf8)
        let dic = try! JSONSerialization.jsonObject(with:jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers)
        return dic as! NSDictionary
    }
    
    
    //MARK:获取网络请求数据的回调函数
    class func getRequestDataBlock(_ urlString:String, _ param:String, block Block: @escaping (_ json:NSDictionary) -> Void) {
        // 登录请求的URL
        let Url = URL(string:urlString)
        let request = NSMutableURLRequest(url:Url!)
        // 设置请求超时时间
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = param.data(using:String.Encoding.utf8)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if (error != nil) {
                return
            }
            else {
                // 错误转成可选值(解析处理的json为空的时候,放在程序崩掉!!)
                let retureMessage = try? JSONSerialization.jsonObject(with:data!, options:[])
                if (retureMessage == nil) {
                    print(NSString(data:data!, encoding:String.Encoding.utf8.rawValue)!)
                    return
                }
                //此处是具体的解析，具体请移步下面
                let json:Any = try! JSONSerialization.jsonObject(with:data!, options: [])
                //返回数据
                Block(json as! NSDictionary)
            }
        }
        // 启动任务
        dataTask.resume()
    }
    
    static var getRequestDataClosuresCallBack:((_ json:NSDictionary)->(Void))?
    
    //MARK:网络请求
    class func getJsonData(urlString:String, param:String){
//        // 后台对数据类型的需要
//        let s1 = self.getParamString(param:["Page_Index":"1","Page_Count":"5"])
//        let dict = self.dictionary(withJsonString:s1)
//        let string = self.getParamString(param:["FunName":"Get_ADVERTISEMENT_DataList","Params":dict])
        
        // 登录请求的URL
        let Url = URL(string:urlString)
        let request = NSMutableURLRequest(url:Url!)
        // 设置请求超时时间
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = param.data(using:String.Encoding.utf8)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if (error != nil) {
                return
            }
            else {
                // 此处是具体的解析出来的数据json，具体请移步下面
                let retureMessage = try? JSONSerialization.jsonObject(with:data!, options:[])
                // 错误转成可选值(解析处理的json为空的时候,放在程序崩掉!!)
                if (retureMessage == nil) {
//                    print(NSString(data:data!, encoding:String.Encoding.utf8.rawValue)!)
                    return
                }
                //返回数据
                networkSection.getRequestDataClosuresCallBack!(retureMessage as! NSDictionary)
            }
        }
        // 启动任务
        dataTask.resume()
    }



    
    //MARK:网络登陆那块的网络接口 - 不加加载等待
    static var getLoadRequestDataClosuresCallBack:((_ json:NSDictionary)->(Void))?
    class func getLoadJsonData(urlString:String, param:String){
        // 登录请求的URL
        let Url = URL(string:urlString)
        let request = NSMutableURLRequest(url:Url!)
        // 设置请求超时时间
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.httpBody = param.data(using:String.Encoding.utf8)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if (error != nil) {
                return
            }
            else {
                if (data == nil) {
                    // 无网络
                    print("无网络")
//                    self.showAlert(title:"wu",message:"aa")
                    return
                }
                // 此处是具体的解析出来的数据json，具体请移步下面
                let retureMessage = try? JSONSerialization.jsonObject(with:data!, options:[])
                // 错误转成可选值(解析处理的json为空的时候,放在程序崩掉!!)
                if (retureMessage == nil) {
                    // 无网络或者服务器无反应
                    print("服务器无反应")
                    print(NSString(data:data!, encoding:String.Encoding.utf8.rawValue)!)
                    return
                }
                //返回数据
                networkSection.getLoadRequestDataClosuresCallBack!(retureMessage as! NSDictionary)
            }
        }
        // 启动任务
        dataTask.resume()
    }
    //显示消息（AlertView）
    func showAlert(title:String="mo", message:String="ren"){
        let alertController = UIAlertController(title:title, message:message, preferredStyle:.alert)
        let cancelAction = UIAlertAction(title:"确定", style:.cancel, handler:nil)
        alertController.addAction(cancelAction)
        self.AppRootViewController()?.present(alertController, animated:true, completion: nil)
    }
    
    //获取当前view所在的viewCOntroller
    func AppRootViewController() -> UIViewController? {
        var topVC  = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
    
}


