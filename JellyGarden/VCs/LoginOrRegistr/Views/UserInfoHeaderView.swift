//
//  UserInfoHeaderView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class UserInfoHeaderView: UIView {
    
    @IBOutlet weak var nameTopConstent: NSLayoutConstraint!
    @IBOutlet weak var progressBackView: UIView!
    @IBOutlet weak var headerIMV: UIImageView!
    
    @IBOutlet weak var lastDegreeLab: UILabel!
    @IBOutlet weak var presentDegreeLab: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var VipLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
//    var tagFrame:CGRect?

    class func newUserHeader() -> UserInfoHeaderView? {
        let nibVIew =  CustomCreateNib<UserInfoHeaderView>().createXibView()
        guard let view = nibVIew else {
            return nil
        }

        view.headerIMV.layer.cornerRadius = 35
        view.headerIMV.clipsToBounds = true
        view.headerIMV.sd_DownLoadImage(url: CurrentUserInfo?.avatar ?? "")
        view.progressView.progressTintColor = k_CustomColor(red: 255, green: 130, blue: 37)
        view.VipLab.layer.cornerRadius = 3.0
        view.VipLab.clipsToBounds = true
        view.nameLab.text = CurrentUserInfo?.nickname ?? ""
        view.dateLab.isHidden = true
        view.VipLab.isHidden = true
        view.progressBackView.isHidden = true
        view.nameTopConstent.constant = 15
        if let count = CurrentUserInfo?.vip_expire_time,count > 0
        {
            if let vip = CurrentUserInfo?.vip_level, vip > 0
            {
                view.nameTopConstent.constant = 0
                view.VipLab.isHidden = false
                view.VipLab.text = "VIP\(vip)"
                view.dateLab.isHidden = false
                
                let dateStr = timeStampToDate(time: Int64(count), backType: DateFormatterType.day)
                view.dateLab.text = "有效期至:\(dateStr)"
                view.progressBackView.isHidden = false
                view.presentDegreeLab.text = "LV\(vip)"
                view.lastDegreeLab.text = "LV\(vip+1)"
            }
            
            
        }
       
        
        return view
    }
    override func layoutSubviews() {
        
    }
//    override func draw(_ rect: CGRect) {
//        
//        self.frame = tagFrame!
//    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
