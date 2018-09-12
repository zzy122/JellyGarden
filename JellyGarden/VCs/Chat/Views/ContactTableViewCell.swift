//
//  ContactTableViewCell.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

let ClickComent_NotifyBtn = "ClickComent_NotifyBtn"
class ContactTableViewCell: UITableViewCell {
    var model:SeePhoneModel?  {
        didSet{
            self.nickLab.text = model?.user_name
            self.descriptionLab.text = "查看了你的联系方式"
            self.timeLab.text = distanceTime(time: model?.time ?? 0)
            self.numLab.isHidden = true
            self.selectionStyle = UITableViewCellSelectionStyle.none
        }
    }
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
    }
    

    @IBAction func clickCommentBtn(_ sender: UIButton) {
//        zzy.router(name: ClickComent_NotifyBtn, object: nil, info: self.model)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
