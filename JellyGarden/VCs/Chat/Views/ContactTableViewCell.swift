//
//  ContactTableViewCell.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var numLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var descriptionLab: UILabel!
    @IBOutlet weak var nickLab: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        commentBtn.layer.cornerRadius = 12
        commentBtn.layer.borderWidth  = 1.0
        commentBtn.clipsToBounds = true
        commentBtn.layer.borderColor = APPCustomBtnColor.cgColor
        
        headerImage.layer.cornerRadius = 25
        headerImage.clipsToBounds = true
        // Initialization code
    }

    @IBAction func clickCommentBtn(_ sender: UIButton) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
