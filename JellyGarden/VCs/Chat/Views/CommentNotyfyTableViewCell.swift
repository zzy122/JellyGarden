//
//  CommentNotyfyTableViewCell.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class CommentNotyfyTableViewCell: UITableViewCell {

    @IBOutlet weak var appealBtn: UIButton!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var commentView: ZZYDisplayView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        appealBtn.layer.cornerRadius = 8
        appealBtn.clipsToBounds = true
        appealBtn.layer.borderColor = APPCustomBtnColor.cgColor
        appealBtn.layer.borderWidth = 1.0
        appealBtn.isHidden = true
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
