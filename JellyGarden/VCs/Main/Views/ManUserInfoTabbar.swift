//
//  ManUserInfoTabbar.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/28.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ManUserInfoTabbar: UIView {

    @IBOutlet weak var collectionImage: UIImageView!
    
    class func createManUserInfoTabbar() -> ManUserInfoTabbar?{
        let nibView = CustomCreateNib<ManUserInfoTabbar>().createXibView()
        guard let view = nibView else {
            return nil
        }
        return view
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func clicCollectBtn(_ sender: UIButton) {
        self.zzy.router(name: ClickUserInfoTabbar, object: nil, info: ClickUserInfoTabbarBtntype.collection)
    }
    @IBAction func clickAppraiseBtn(_ sender: UIButton) {
        self.zzy.router(name: ClickUserInfoTabbar, object: nil, info: ClickUserInfoTabbarBtntype.prase)
    }
    @IBAction func clickChatBtn(_ sender: UIButton) {
        self.zzy.router(name: ClickUserInfoTabbar, object: nil, info: ClickUserInfoTabbarBtntype.chat)
    }

}
