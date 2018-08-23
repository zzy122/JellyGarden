//
//  PersonalInfoHeader.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let BodyImageHeight = 90 * SCALE

class PersonalInfoHeader: UIView {
    
    
    @IBOutlet weak var centerContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var VipLabl: UILabel!
    @IBOutlet weak var userInfoContentView: UIView!
    @IBOutlet weak var centerContentView: UIView!
    
    @IBOutlet weak var ImageContentView: UIView!
    @IBOutlet weak var hostLab: UILabel!
    @IBOutlet weak var bodyWeightLab: UILabel!
    @IBOutlet weak var bodyHeightLab: UILabel!
    @IBOutlet weak var attestationDetailLab: UILabel!//通过了安全认证
    @IBOutlet weak var attestationLab: UILabel!//可靠  未认证
    @IBOutlet weak var cityLab: UILabel!//约会范围
    @IBOutlet weak var distanceLab: UILabel!//距离
    @IBOutlet weak var detailLab: UILabel!//地址所在地 年龄 职业
    @IBOutlet weak var nikeNameLab: UILabel!//昵称
    @IBOutlet weak var headerImage: UIImageView!

    var userModel:UserModel?{
        didSet{
            self.headerImage.sd_DownLoadImage(url: userModel?.avatar ?? "")
           self.nikeNameLab.text = userModel?.nickname
            if let has_authentication =
                userModel?.has_authentication ,has_authentication {
                 attestationDetailLab.text = "通过了面具公园的安全审核"
                attestationLab.text = "可靠"
            }
            else
            {
                attestationDetailLab.text = ""
                attestationLab.text = "未认证"
                attestationLab.backgroundColor = UIColor.gray
                attestationDetailLab.isHidden = true
            }
            let distance = Float.init(userModel?.distance ?? "0.0")
            detailLab.text = continueString(strAry: [userModel?.city ?? "", "\(String.init(format: "%d", userModel?.age ?? 0))岁",userModel?.identity ?? ""],separetStr:"  ")
           
            distanceLab.text = String.init(format: "%.1fkm", distance ?? 0.0)
            cityLab.text = continueString(strAry: userModel?.appointment_place,separetStr:"  ")
            let hostStr = String.init(format: "%d", userModel?.bust ?? 0)
            let bodyWeightStr = String.init(format: "%d", userModel?.weight ?? 0)
            let bodyHeightStr = String.init(format: "%d", userModel?.stature ?? 0)
             
            hostLab.text = "\(hostStr)CM"
            bodyWeightLab.text = "\(bodyWeightStr)KG"
            bodyHeightLab.text = "\(bodyHeightStr)CM"
            if let vip = userModel?.vip_level,vip > 0 {
                if let time = userModel?.vip_expire_time, time > 0
                {
                    self.VipLabl.isHidden = false
                }
            }
            guard let ary = userModel?.custom_photos,ary.count > 0 else {
                self.imageBodyView.isHidden = true
                return
            }
            self.imageBodyView.isHidden = false
        }
    }
    
    lazy var imageBodyView:PersonInfoImageView = { 
        let view = PersonInfoImageView.init(frame:  CGRect.init(x: 0, y: 0, width: (self.frame.width), height: (self.frame.height) - self.ImageContentView.frame.minY))
        view.userModel = self.userModel
        self.ImageContentView.addSubview(view)
        return view
    }()
    class func createPersonalInfoHeader() -> PersonalInfoHeader?{
        let nibView = CustomCreateNib<PersonalInfoHeader>().createXibView()
        guard let view = nibView else {
            return nil
        }
        view.headerImage.layer.cornerRadius = 35
        view.VipLabl.layer.cornerRadius = 9
        view.VipLabl.clipsToBounds = true
        view.VipLabl.isHidden = true
        view.headerImage.clipsToBounds = true
        view.centerContentView.layer.cornerRadius = 8
        view.centerContentView.clipsToBounds = true
        view.userInfoContentView.clipsToBounds = true
        view.userInfoContentView.layer.cornerRadius = 8
        view.attestationLab.layer.cornerRadius = 8.0
        view.attestationLab.clipsToBounds = true
        return view
        
    }
    
//    override func draw(_ rect: CGRect) {
//        self.frame = tagFrame!
//    }
    override func layoutSubviews() {//视图没加载出来的时候gaibianframe不会调用
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
