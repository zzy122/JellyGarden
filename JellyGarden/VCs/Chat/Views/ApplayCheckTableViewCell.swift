//
//  ApplayCheckTableViewCell.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/16.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ApplayCheckTableViewCell: UITableViewCell {

    @IBOutlet weak var nickLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var limitDateBtn: UIButton!
    @IBOutlet weak var refuseBtn: UIButton!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var commentImag: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var model:NotifyDataModel?
    {
        didSet{
            self.nickLab.text = model?.nickname
            self.commentImag.sd_DownLoadImage(url: "")
        }
    }
    
    @IBAction func clickMainBtn(_ sender: UIButton) {//他的首页
        if model?.sex == 1
        {
            
            let vc = PersonInfoViewController()
            TargetManager.share.getDetailUserInfo(userid: model?.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
                guard let user = userinfo else{
                    return
                }
                user.distance = self.model?.distance
                vc.userInfoModel = user
                RootNav().pushViewController(vc, animated: true)
            })
        }
        else
        {
            let vc = ManPersonInfoViewController()
            TargetManager.share.getDetailUserInfo(userid: model?.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
                guard let user = userinfo else{
                    return
                }
                user.distance = self.model?.distance
                vc.userInfoModel = user
                RootNav().pushViewController(vc, animated: true)
            })
        }
        
    }
    @IBAction func clickDateBtn(_ sender: UIButton) {//允许
        
    }
    @IBAction func clickRefuseBtn(_ sender: UIButton) {//拒绝
        
    }
    override func layoutSubviews() {
        mainBtn.layer.cornerRadius = 12
        mainBtn.clipsToBounds = true
        mainBtn.layer.borderColor = APPCustomBtnColor.cgColor
        mainBtn.layer.borderWidth = 1
        headerImage.layer.cornerRadius = 25
        headerImage.clipsToBounds = true
        refuseBtn.layer.cornerRadius = 18
        refuseBtn.clipsToBounds = true
        refuseBtn.layer.borderColor = APPCustomBtnColor.cgColor
        refuseBtn.layer.borderWidth = 1
        limitDateBtn.layer.cornerRadius = 18
        limitDateBtn.clipsToBounds = true
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
