//
//  SystemMessageTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/26.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class SystemMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTime: UILabel!
    @IBOutlet weak var messageCount: UILabel!
    @IBOutlet weak var messageDetail: UILabel!
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        self.messageCount.backgroundColor = APPCustomRedColor
        self.messageCount.layer.cornerRadius = 10.0
        self.messageCount.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
