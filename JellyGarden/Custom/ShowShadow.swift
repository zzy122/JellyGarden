//
//  ShowShadow.swift
//
//  Created by zzy on 2018/4/25.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import PKHUD
class ShowShadow: NSObject {
    
    var countTag = 0
    
    static let share = ShowShadow()
    private override init() {
        
    }
    func netWorkShowShadow() {
        
        if countTag <= 0 {
            countTag = 0
            HUD.flash(.labeledProgress(title: nil, subtitle: "请稍后..."))
        }
        countTag += 1
    }
    func networkHidden() {
        countTag -= 1
        if countTag <= 0 {
           self.closeTheShadow()
        }
    }
    
    func showWarmMessage(title:String) {
        HUD.flash(.label(title),delay: 2.0){_ in }
    }
    func closeTheShadow() {
        countTag = 0
        HUD.hide(animated: false) { (iscompletion) in
            if iscompletion {
                DebugLogLine(message: "隐藏成功")
            }
        }
        HUD.hide(animated: false)
    }
    
    
}
