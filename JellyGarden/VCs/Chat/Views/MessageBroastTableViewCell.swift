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
    override func layoutSubviews() {
        headerView.layer.cornerRadius = 25
        headerView.clipsToBounds = true
        headerView.image = imageName(name: "loginicon")
        nickName.text = "zzy"
        desCriptionLab.text = "在北京发布了一条约会广播"
        timeLab.text = distanceTime(time: 12635552)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
