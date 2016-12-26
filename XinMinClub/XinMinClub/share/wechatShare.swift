//
//  wechatShare.swift
//  shareView
//
//  Created by 杨科军 on 2016/11/30.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit

class wechatShare: NSObject {
    
    //MARK:微信分享
    // WXSceneSession  = 0,        /**< 聊天界面    */
    // WXSceneTimeline = 1,        /**< 朋友圈      */
    // WXSceneFavorite = 2,        /**< 收藏       */
    
    // 判断是否安装微信
    class func isHaveWechat() ->Bool{
        return WXApi.isWXAppInstalled()
    }
    
    //分享文本  text:分享的内容   inScene:分享的位置，朋友圈、聊天界面、收藏
    class func sendText(text:String, inScene:WXScene)->Bool{
        let req=SendMessageToWXReq()
        req.text=text
        req.bText=true
        req.scene=Int32(inScene.rawValue)
        return WXApi.send(req)
    }
    //分享图片
    class func sendImage(image:UIImage, inScene:WXScene)->Bool{
        let imageObject = WXImageObject()
        imageObject.imageData = UIImagePNGRepresentation(image) // png的图片
        
        let message = WXMediaMessage()
        message.mediaObject = imageObject
        message.mediaTagName = "MyPic"
        //生成缩略图  确定是否发送处使用
        UIGraphicsBeginImageContext(CGSize(width:100, height:100))
        image.draw(in:CGRect(x:0, y:0, width:100, height:100))
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        message.thumbData = UIImagePNGRepresentation(thumbImage!)
        
        let req = SendMessageToWXReq()
        req.message = message
        req.bText = false
        req.scene = Int32(inScene.rawValue)
        return WXApi.send(req)
    }
    //分享网页url
    class func sendUrl(urlString:String, title:String, description:String, thumbnail:UIImage, inScene:WXScene)->Bool{
        let req = SendMessageToWXReq()
        req.bText = false // 非纯文本分享
        req.scene = Int32(inScene.rawValue) // 分享地方选择

        let message = WXMediaMessage()
        message.title = title // 标题
        message.description = description // 描述
        
        //生成缩略图  确定是否发送处使用
        UIGraphicsBeginImageContext(CGSize(width:100, height:100))
        thumbnail.draw(in:CGRect(x:0, y:0, width:100, height:100))
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        message.thumbData = UIImagePNGRepresentation(thumbImage!)
        
        let webPageObj = WXWebpageObject()
        webPageObj.webpageUrl = urlString // 网页url
        message.mediaObject = webPageObj  // 消息是一个网页
        
        req.message = message // 分享消息
        
       return WXApi.send(req)
    }
    
    // 分享音乐
    class func sendmusic(musicUrl:String,musicDataUrl:String,title:String, description:String, thumbnail:UIImage, inScene:WXScene) ->Bool {
        let req = SendMessageToWXReq()
        req.bText = false // 非纯文本分享
        req.scene = Int32(inScene.rawValue) // 分享地方选择
        
        let message = WXMediaMessage()
        message.title = title // 标题
        message.description = description // 描述
        // 生成缩略图  确定是否发送处使用
        UIGraphicsBeginImageContext(CGSize(width:100, height:100))
        thumbnail.draw(in:CGRect(x:0, y:0, width:100, height:100))
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        message.thumbData = UIImagePNGRepresentation(thumbImage!)
        
        let musicObj = WXMusicObject()
        musicObj.musicUrl = musicUrl
        musicObj.musicLowBandUrl = musicObj.musicUrl
        
        musicObj.musicDataUrl = musicUrl
        musicObj.musicLowBandDataUrl = musicObj.musicDataUrl
        
        message.mediaObject = musicObj  // 消息是一首音乐
        
        req.message = message // 分享消息
        
        return WXApi.send(req)
    }

    //分享视频
    class func sendvideo(musicUrl:String,title:String, description:String, thumbnail:UIImage, inScene:WXScene) ->Bool {
        let req = SendMessageToWXReq()
        req.bText = false // 非纯文本分享
        req.scene = Int32(inScene.rawValue) // 分享地方选择
        
        let message = WXMediaMessage()
        message.title = title // 标题
        message.description = description // 描述
        // 生成缩略图  确定是否发送处使用
        UIGraphicsBeginImageContext(CGSize(width:100, height:100))
        thumbnail.draw(in:CGRect(x:0, y:0, width:100, height:100))
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        message.thumbData = UIImagePNGRepresentation(thumbImage!)
        
        let videoObj = WXVideoObject()
        videoObj.videoUrl = musicUrl
        videoObj.videoLowBandUrl = videoObj.videoUrl  // 低分辨率的视频Url
        
        message.mediaObject = videoObj  // 消息是一个视频
        
        req.message = message // 分享消息
        
        return WXApi.send(req)
    }

    
    // 分享文件
    class func sendFile(fileText:String,title:String, description:String, thumbnail:UIImage, inScene:WXScene) ->Bool {
        let req = SendMessageToWXReq()
        req.bText = false // 非纯文本分享
        req.scene = Int32(inScene.rawValue) // 分享地方选择
        
        let message = WXMediaMessage()
        message.title = title // 标题
        message.description = description // 描述
        //生成缩略图  确定是否发送处使用
        UIGraphicsBeginImageContext(CGSize(width:100, height:100))
        thumbnail.draw(in:CGRect(x:0, y:0, width:100, height:100))
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        message.thumbData = UIImagePNGRepresentation(thumbImage!)
        
        let fileObj = WXFileObject()
        fileObj.fileData = fileText.data(using:String.Encoding.utf8, allowLossyConversion: false)!//UTF8编码 字符串转NSData
        message.mediaObject = fileObj  // 消息是一个文件
        
        req.message = message // 分享消息
        
        return WXApi.send(req)
    }
    
}
