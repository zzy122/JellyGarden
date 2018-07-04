//
//  NOCastView.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/3.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class NOCastView: UIView {
    @IBOutlet weak var warmLab: UILabel!
    class func createNOCastView() -> NOCastView? {
        let nibView = CustomCreateNib<NOCastView>().createXibView()
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

}
