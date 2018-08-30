//
//  EnlistDetailTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class EnlistDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var headerIMageView: UIImageView!
    @IBOutlet weak var desCriptionLab: UILabel!
    @IBOutlet weak var nikeNameLab: UILabel!
    @IBOutlet weak var commentTimeLab: UILabel!
    @IBOutlet weak var headerBtn: UIButton!
    @IBOutlet weak var contentImageBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    var model:sign_up? {
        didSet{
            self.headerIMageView.sd_DownLoadImage(url: (model?.avatar)!)
            self.contentImageView.sd_DownLoadImage(url: model?.attachment?.last ?? "")
            self.commentTimeLab.text = timeStampToDate(time: Int64(model?.create_at ?? 0), backType: DateFormatterType.second)
            desCriptionLab.text = "报名了您的约会广播"
            self.nikeNameLab.text = model?.nickname

            desCriptionLab.textColor = UIColor.gray
            if model?.has_pay_deposit == true
            {
                desCriptionLab.text = "报名并支付了定金"
                desCriptionLab.textColor = APPCustomBtnColor
            }
        }
    }
    override func layoutSubviews() {
        self.headerIMageView.layer.cornerRadius = 15
        self.headerIMageView.clipsToBounds = true
    }
    @IBAction func clickAppiontBtn(_ sender: UIButton) {//约会
        
    }
    @IBAction func clickContentBtn(_ sender: UIButton) {//点击图片
        let vc = LookImageViewController()
        
        vc.imageUrl = model?.attachment?.first ?? ""
//        vc.type = .clearness
        RootNav().pushViewController(vc, animated: true)
    }
    @IBAction func clickPrivateChateBtn(_ sender: UIButton) {//私聊
        let vc = ChatRoomViewController.init(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: model?.user_id ?? "")
        vc?.targetId = model?.user_id ?? ""
        RCIM.shared().userInfoDataSource.getUserInfo(withUserId: model?.user_id) { (info) in
            vc?.title = info?.name
           RootNav().pushViewController(vc!, animated: true)
        }
    }
    @IBAction func clickHeaderBtn(_ sender: UIButton) {//头像
        if CurrentUserInfo?.sex == 0
        {
            
            let vc = PersonInfoViewController()
            //                vc.showType = .validation//查看权限
            TargetManager.share.getDetailUserInfo(userid: model?.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
                guard let user = userinfo else{
                    return
                }
                //                    user.distance = model.distance
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
                //                    user.distance = model.distance
                vc.userInfoModel = user
                RootNav().pushViewController(vc, animated: true)
            })
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
