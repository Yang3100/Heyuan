//
//  macroDefinition.swift
//  Home
//
//  Created by 杨科军 on 2016/12/7.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import Foundation
import UIKit

let WXDoctor_App_ID = "wxeb4693506532bea3"  // 注册微信时的AppID
let WXDoctor_App_Secret = "323a0eb9b8f7f0505f08c98f4511b8ff" // 注册时得到的AppSecret
let WXPatient_App_ID = "wxbd02bfeea4292***"
let WXPatient_App_Secret = "4a788217f363358276309ab655707***"
let WX_ACCESS_TOKEN = "access_token"
let WX_OPEN_ID = "openid"
let WX_REFRESH_TOKEN = "refresh_token"
let WX_UNION_ID = "unionid"
let WX_BASE_URL = "https://api.weixin.qq.com/sns"

// 屏幕宽度
let screenWidth = UIScreen.main.bounds.width
// 屏幕高度
let screenHeight = UIScreen.main.bounds.height

let STATUS_HEIGHT:CGFloat = 20
let NAV_HEIGHT:CGFloat = 44
let TABBAR_HEIGHT:CGFloat = 49
let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)
let CONTENT_VIEW_HEIGHT = SCREEN_HEIGHT-STATUS_HEIGHT-NAV_HEIGHT-TABBAR_HEIGHT
let MARGIN:CGFloat = 20
let TEXT_BACK_COLOR = (UIColor.white)
let DARK = (UIColor.black)
let LIGHT = (UIColor.white)
let GRAY = (UIColor.gray)

func MY_CGRECT(x:CGFloat,y:CGFloat,w:CGFloat,h:CGFloat)->CGRect {
    return CGRect(x:x,y:y,width:w,height:h)
}

func RGB255_COLOR(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->UIColor {
    return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: a)
}
