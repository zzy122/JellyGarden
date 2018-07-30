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
    var model:NotifyDataModel?  {
        didSet{
            self.nickName.text = model?.nickname
            self.desCriptionLab.text = "在\(model?.city ?? "")发布了一条约会广播"
            self.timeLab.text = "1小时前"
            self.accessoryView = {
                let lable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 30))
                lable.textColor = UIColor.gray
                lable.text = "去看看>"
                lable.font = kFont_system10
                lable.textAlignment = NSTextAlignment.right
                lable.backgroundColor = UIColor.clear
                return lable
            }()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
        headerView.layer.cornerRadius = 25
        headerView.clipsToBounds = true
        headerView.image = imageName(name: "loginicon")
        timeLab.text = distanceTime(time: 12635552)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
