//
//  BlacklistTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/8.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickCancelBlack = "ClickCancelBlack"
class BlacklistTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nickLable: UILabel!
    @IBOutlet weak var headerImag: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var model:BlackModel? {
        didSet{
            headerImag.sd_DownLoadImage(url: model?.avatar ?? "", complection: { (image) in
                
            })
            nickLable.text = model?.nickname
        }
    }
    
    override func layoutSubviews() {
        cancelBtn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
        cancelBtn.layer.cornerRadius = 15
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = APPCustomBtnColor.cgColor
        cancelBtn.clipsToBounds = true
        
        headerImag.layer.cornerRadius = 25
        headerImag.clipsToBounds = true
        
    }
    @IBAction func clickCancelBtn(_ sender: UIButton) {
        zzy.router(name: ClickCancelBlack, object: nil, info: self.tag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
