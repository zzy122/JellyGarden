//
//  MainUserListTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickLikeHeart = "ClickLikeHeart"
class MainUserListTableViewCell: UITableViewCell {

    @IBOutlet weak var userHeaderImage: UIImageView!//头像
    @IBOutlet weak var userNameLab: UILabel!//昵称
    @IBOutlet weak var imageCountLab: UILabel!//照片数量
    @IBOutlet weak var heartImage: UIImageView!//心形View
    @IBOutlet weak var lookLab: UILabel!//申请浏览Lab
    @IBOutlet weak var lookUserImage: UIImageView!//申请浏览图片
    @IBOutlet weak var userStatuLab: UILabel!//用户状态lab
    @IBOutlet weak var distanceLab: UILabel!//距离lab
    @IBOutlet weak var realityLab: UILabel!//真实状态lab 未认证
    @IBOutlet weak var identityLab: UILabel!//身份lab
    @IBOutlet weak var ageLab: UILabel!//年龄lab
    @IBOutlet weak var siteLab: UILabel!//位置Lab
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    var model:MainListmodel? {
        didSet{
            self.userHeaderImage.sd_DownLoadImage(url: model?.avatar ?? "")
            self.userNameLab.text = model?.nickname
            self.siteLab.text = model?.city
            self.ageLab.text = "\(model?.age ?? 0)岁"
            self.identityLab.text = model?.identity
            self.distanceLab.text = "\(getDistance(lat1: UserLocation.coordinate.latitude, lng1: UserLocation.coordinate.longitude, lat2: model?.lat ?? 0.0, lng2: model?.lon ?? 0.0))km"
            self.imageCountLab.text = "\(model?.photo_count ?? 0)"
            if let trueth = model?.has_authentication,trueth {
                realityLab.backgroundColor = APPCustomRedColor
                realityLab.text = "真实"
            }
            else
            {
                realityLab.backgroundColor = UIColor.gray
                realityLab.text = "未认证"
            }
            heartImage.image = imageName(name: "赞-空")
            if let isLike = model?.is_like ,isLike{
                heartImage.image = imageName(name: "赞-实")
            }
            if model?.permission == permissionAry[1]//相册付费
            {
                lookUserImage.isHidden = false
                lookLab.isHidden = false
                lookLab.text = "付费相册"
            }
            else if model?.permission == permissionAry[2]//申请查看权限
            {
                lookUserImage.isHidden = false
                lookLab.isHidden = false
                lookLab.text = "申请浏览"
            }
            else
            {
                lookUserImage.isHidden = true
                lookLab.isHidden = true
            }
            
        }
    }
    
    @IBAction func clickHeart(_ sender: UIButton) {//点击心形Btn
        zzy.router(name: ClickLikeHeart, object: nil, info: self.tag)
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
