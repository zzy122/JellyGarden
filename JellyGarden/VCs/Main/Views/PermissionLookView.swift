//
//  PermissionLookView.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/3.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickPermissionBtn = "ClickPermissionBtn"
class PermissionLookView: UIView {
    class func createPermissionLookView() ->PermissionLookView?
    {
        let nibView = CustomCreateNib<PermissionLookView>().createXibView()
        guard let view = nibView else {
            return nil
        }
        view.permissBtn.layer.cornerRadius = 15
        view.permissBtn.clipsToBounds = true
        return view
    }
    @IBOutlet weak var permissBtn: UIButton!
    @IBAction func clickPermissionLookBtn(_ sender: UIButton) {
        zzy.router(name: ClickPermissionBtn, object: nil, info: nil)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
