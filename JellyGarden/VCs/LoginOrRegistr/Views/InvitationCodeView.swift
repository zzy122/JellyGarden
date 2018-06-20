//
//  InvitationCodeView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class InvitationCodeView: UIView {
    var tagFram:CGRect?
    
    override func draw(_ rect: CGRect) {
        self.frame = tagFram!
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
