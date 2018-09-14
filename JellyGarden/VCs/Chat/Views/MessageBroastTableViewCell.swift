//
//  MessageBroastTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/9.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class MessageBroastTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var desCriptionLab: UILabel!
    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var model1:RemindNoticeModel?
    {
        didSet{
            self.nickName.text = model1?.user_name
            var str:String = ""
            switch model1?.type {//1约会定价 //2查看照片 3//购买Vip 4解锁相册 5 查看联系方式 6 私聊
            case 1:
                str = "支付了定金"
                break
            case 2:
                str = "查看了您的红包照片"
                break
            case 3:
//                str = "支付了定金"
                break
            case 4:
                str = "查看了您的相册"
                break
            case 5:
                str = "查看了您的联系方式"
                break
            default:
                break
            }
            
            self.desCriptionLab.text = "付费\(model1?.moeny ?? 0)\(str)"
            self.timeLab.text = distanceTime(time: model1?.time ?? 0)
            self.headerView.sd_DownLoadImage(url: model1?.user_image ?? "", complection: { (image) in
                
            })
        }
    }
    var model:BroastModel?  {
        didSet{
            self.nickName.text = model?.user_name
            self.desCriptionLab.text = "在\(model?.city ?? "")发布了一条约会广播"
            self.timeLab.text = distanceTime(time: model?.time ?? 0)
            self.accessoryView = {
                let lable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 30))
                lable.textColor = UIColor.gray
                lable.text = "去看看>"
                lable.font = kFont_system10
                lable.textAlignment = NSTextAlignment.right
                lable.backgroundColor = UIColor.clear
                return lable
            }()
            self.headerView.sd_DownLoadImage(url: model?.attachment ?? "", complection: { (image) in
                
            })
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
        headerView.layer.cornerRadius = 25
        headerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
