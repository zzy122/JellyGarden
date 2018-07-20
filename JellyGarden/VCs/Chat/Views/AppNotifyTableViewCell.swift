//
//  AppNotifyTableViewCell.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/16.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class AppNotifyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        self.appImageView.layer.cornerRadius = 25
        self.appImageView.clipsToBounds = true
    }
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    @IBOutlet weak var appImageView: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
