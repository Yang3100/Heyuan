//
//  QQShare.swift
//  shareView
//
//  Created by 杨科军 on 2016/11/30.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit

class QQShare: NSObject {

    // 纯文本分享
    class func sendText(text:String) {
        let txtObj = QQApiTextObject(text:text)
        let req = SendMessageToQQReq(content:txtObj)
        //发送并获取响应结果
        QQApiInterface.send(req)
    }
    
    // 分享图片数据
    class func sendImage(image:UIImage,title:String,description:String) {
        let imgData = UIImagePNGRepresentation(image) // png的图片
        let imgObj = QQApiImageObject(data:imgData, previewImageData:imgData, title:title, description:description)
        let req = SendMessageToQQReq(content:imgObj)
        //将内容分享到 qq
        QQApiInterface.send(req)
    }
    
    // 分享新闻数据
    class func snedNews(urlString:String, previewImageUrl:String, title:String, description:String, isShsreToQZone:Bool) {
        let newsUrl = URL(string:urlString)
        let previewImageUrl = URL(string:previewImageUrl)
        let newsObj = QQApiNewsObject(url:newsUrl, title:title, description: description, previewImageURL: previewImageUrl, targetContentType:QQApiURLTargetTypeNews)
        let req = SendMessageToQQReq(content: newsObj)
        if isShsreToQZone {
            //将内容分享到 qzone
            QQApiInterface.sendReq(toQZone:req)
        }
        else {
            //将内容分享到 qq
            QQApiInterface.send(req)
        }
    }
    
    // 分享音乐
    class func sendMusic(musicUrlString:String, previewImageUrl:String,title:String,descriotion:String, isShsreToQZone:Bool) {
        let url = URL(string:musicUrlString)
        let previewImageUrl = URL(string:previewImageUrl)
        let audioObj = QQApiAudioObject(url:url, title:title, description: descriotion, previewImageURL: previewImageUrl, targetContentType:QQApiURLTargetTypeAudio)
        let req = SendMessageToQQReq(content:audioObj)
        if isShsreToQZone {
            //将内容分享到 qzone
         QQApiInterface.sendReq(toQZone:req)
        }
        else {
            //将内容分享到 qq
         QQApiInterface.send(req)
        }
    }
    
    // 分享视频
    class func sendVideo(videoUrlString:String, previewImageUrl:String,title:String,descriotion:String, isShsreToQZone:Bool) {
        let url = URL(string:videoUrlString)
        let previewImageUrl = URL(string:previewImageUrl)
        let videoObj = QQApiVideoObject(url:url, title:title,description:descriotion,previewImageURL:previewImageUrl, targetContentType:QQApiURLTargetTypeVideo)
        let req = SendMessageToQQReq(content: videoObj)
        if isShsreToQZone {
            //将内容分享到 qzone
            QQApiInterface.sendReq(toQZone:req)
        }
        else {
            //将内容分享到 qq
            QQApiInterface.send(req)
        }
    }
    
    class func sendMoreImagetoQQCollect() {
        //        //开发者分享多个图片数据至 QQ 收藏
        //        let imgArray = [imgData, imgData1, imgData2, imgData3]
        //        let imgObj = QQApiImageObject(imgData, previewImageData: imgData, title: "title", description: "description", imageDataArray: imgArray)
        //        imgObj.cflag = kQQAPICtrlFlagQQShareFavorites
        //        let req = SendMessageToQQReq(content: imgObj)
        //        //将内容分享到 qq
        //        let sent = QQApiInterface.send(req)
    }
    
    //处理分享返回结果
    func handleSendResult(sendResult:QQApiSendResultCode){
        var message = ""
        switch(sendResult){
        case EQQAPIAPPNOTREGISTED:
            message = "App未注册"
        case EQQAPIMESSAGECONTENTINVALID, EQQAPIMESSAGECONTENTNULL,
             EQQAPIMESSAGETYPEINVALID:
            message = "发送参数错误"
        case EQQAPIQQNOTINSTALLED:
            message = "QQ未安装"
        case EQQAPIQQNOTSUPPORTAPI:
            message = "API接口不支持"
        case EQQAPISENDFAILD:
            message = "发送失败"
        case EQQAPIQZONENOTSUPPORTTEXT:
            message = "空间分享不支持纯文本分享，请使用图文分享"
        case EQQAPIQZONENOTSUPPORTIMAGE:
            message = "空间分享不支持纯图片分享，请使用图文分享"
        default:
            message = "发送成功"
        }
        print(message)
    }

}
