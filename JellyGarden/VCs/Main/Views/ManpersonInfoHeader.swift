//
//  MainpersonInfoHeader.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/15.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ManpersonInfoHeader: UIView {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var VipLabl: UILabel!
    @IBOutlet weak var introduceContentLab: UILabel!
    @IBOutlet weak var troduceLab: UILabel!
    @IBOutlet weak var ImageContentView: UIView!
    @IBOutlet weak var userInfoContentView: UIView!
    @IBOutlet weak var attestationDetailLab: UILabel!//通过了安全认证
    @IBOutlet weak var attestationLab: UILabel!//可靠  未认证
    @IBOutlet weak var cityLab: UILabel!//约会范围
    @IBOutlet weak var distanceLab: UILabel!//距离
    @IBOutlet weak var detailLab: UILabel!//地址所在地 年龄 职业
    @IBOutlet weak var nikeNameLab: UILabel!//昵称
    @IBOutlet weak var headerImage: UIImageView!
//    var tagFrame:CGRect?
//    var imageAry:[String] = []//照片数量
    

    var userModel:UserModel?{
        didSet{
            self.headerImage.sd_DownLoadImage(url: userModel?.avatar ?? "", complection: { (image) in
                
            })
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
            self.introduceContentLab.text = userModel?.self_introduction
            
            if userModel?.custom_photos?.count == 0 {
                self.imageBodyView.isHidden = true
                return
            }
            self.imageBodyView.isHidden = false
        }
        
    }
    override func layoutSubviews() {
        
    }
    lazy var imageBodyView:PersonInfoImageView = {
        let view = PersonInfoImageView.init(frame:  CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height - self.bottomView.frame.minY - 80))
        view.userModel = self.userModel
        self.ImageContentView.addSubview(view)
        return view
    }()
    class func createManpersonInfoHeader() -> ManpersonInfoHeader?{
        let nibView = CustomCreateNib<ManpersonInfoHeader>().createXibView()
        guard let view = nibView else {
            return nil
        }
        //        view.backgroundColor = UIColor.clear
        view.headerImage.layer.cornerRadius = 35
        view.headerImage.clipsToBounds = true
        view.userInfoContentView.clipsToBounds = true
        view.userInfoContentView.layer.cornerRadius = 8
        view.attestationLab.layer.cornerRadius = 8.0
        view.attestationLab.clipsToBounds = true
        
        view.VipLabl.layer.cornerRadius = 9
        view.VipLabl.clipsToBounds = true
        view.VipLabl.isHidden = true
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
