//
//  UserInfoTabbar.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickUserInfoTabbar = "ClickUserInfoTabbar"
enum ClickUserInfoTabbarBtntype {
    case collection;
    case money;
    case prase;
    case chat;
}
class UserInfoTabbar: UIView {
    
    var tagFrame:CGRect?
    override func draw(_ rect: CGRect) {
        self.frame = self.tagFrame!
    }
    class func createUserInfoTabbar() -> UserInfoTabbar?{
        let nibView = CustomCreateNib<UserInfoTabbar>().createXibView()
        guard let view = nibView else {
            return nil
        }
        return view
    }
    @IBAction func clicCollectBtn(_ sender: UIButton) {
        self.zzy.router(name: ClickUserInfoTabbar, object: nil, info: ClickUserInfoTabbarBtntype.collection)
    }
    @IBAction func clickManeyBtn(_ sender: UIButton) {
        self.zzy.router(name: ClickUserInfoTabbar, object: nil, info: ClickUserInfoTabbarBtntype.money)
    }
    @IBAction func clickAppraiseBtn(_ sender: UIButton) {
        self.zzy.router(name: ClickUserInfoTabbar, object: nil, info: ClickUserInfoTabbarBtntype.prase)
    }
    @IBAction func clickChatBtn(_ sender: UIButton) {
        self.zzy.router(name: ClickUserInfoTabbar, object: nil, info: ClickUserInfoTabbarBtntype.chat)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
