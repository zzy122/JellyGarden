//
//  ApplyOperationView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/13.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickReportName = "ClickReportName"
let ClickEnlistBtn = "ClickEnlistBtn"
class ApplyOperationView: UIView {


    class func createApplyOperationView() -> ApplyOperationView?{
        let nibView = CustomCreateNib<ApplyOperationView>().createXibView()
        guard let view = nibView else {
            return nil
        }
        return view
    }
    @IBOutlet weak var bottomView: UIView!
    @IBAction func clickStatusBtn(_ sender: UIButton) {
      zzy.router(name: ClickEnlistBtn, object: nil, info: self.tag)
        
    }
    @IBOutlet weak var ApplyStatus: UIButton!
    @IBOutlet weak var lookApplayBtn: UIButton!
    
     @IBAction func clickLookBtn(_ sender: UIButton) {
        
        zzy.router(name: ClickReportName, object: nil, info: self.tag)
     }
    /*
     // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
