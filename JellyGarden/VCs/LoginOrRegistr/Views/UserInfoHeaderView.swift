//
//  UserInfoHeaderView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class UserInfoHeaderView: UIView {
    
    @IBOutlet weak var headerIMV: UIImageView!
    
    @IBOutlet weak var lastDegreeLab: UILabel!
    @IBOutlet weak var presentDegreeLab: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var VipLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    var tagFrame:CGRect?

    class func newUserHeader() -> UserInfoHeaderView? {
        let nibVIew =  CustomCreateNib<UserInfoHeaderView>().createXibView()
        guard let view = nibVIew else {
            return nil
        }
//        view.backgroundColor = UIColor.clear
        view.VipLab.layer.cornerRadius = 3.0
        return view
    }
   
    override func draw(_ rect: CGRect) {
        
        self.frame = tagFrame!
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
