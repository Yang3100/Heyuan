//
//  delaySection.swift
//  Home
//
//  Created by 杨科军 on 2016/12/9.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit
import Foundation

class delaySection: NSObject {
    
    typealias Task = (_ cancel : Bool) -> Void
    
    // 延时执行
    class func delay(_ time: TimeInterval, task: @escaping ()->()) ->  Task? {
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        var closure: (()->Void)? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        return result
    }
    
    // 取消
    class func cancel(_ task: Task?) {
        task?(true)
    }
    
    
    //    /*****使用*****/
    //    //调用
    //    delay(2) { print("2 秒后输出") }
    //
    //
    //
    //    //取消
    //    let task = delay(5) { print("拨打 110") }
    //
    //    // 仔细想一想..
    //    // 还是取消为妙..
    //    cancel(task)
}
