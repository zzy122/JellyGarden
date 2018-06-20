//
//  XIeyiWarmView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/6.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class XIeyiWarmView: UIView {

    @IBAction func clickBtn(_ sender: UIButton) {
    }
    var tagFrame:CGRect?
    override func draw(_ rect: CGRect) {
        self.frame = tagFrame!
    }
    class func createXIeyiWarmView() -> XIeyiWarmView? {
        let nibView = CustomCreateNib<XIeyiWarmView>().createXibView()
        guard let view = nibView else {
            return nil
        }
        view.backgroundColor = UIColor.clear
        return view;
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
