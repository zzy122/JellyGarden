//
//  ApplayCheckTableViewCell.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/16.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ApplayCheckTableViewCell: UITableViewCell {

    @IBOutlet weak var nickLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var limitDateBtn: UIButton!
    @IBOutlet weak var refuseBtn: UIButton!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var commentImag: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clickMainBtn(_ sender: UIButton) {
    }
    @IBAction func clickDateBtn(_ sender: UIButton) {
    }
    @IBAction func clickRefuseBtn(_ sender: UIButton) {
    }
    override func layoutSubviews() {
        mainBtn.layer.cornerRadius = 12
        mainBtn.clipsToBounds = true
        mainBtn.layer.borderColor = APPCustomBtnColor.cgColor
        mainBtn.layer.borderWidth = 1
        headerImage.layer.cornerRadius = 25
        headerImage.clipsToBounds = true
        refuseBtn.layer.cornerRadius = 18
        refuseBtn.clipsToBounds = true
        refuseBtn.layer.borderColor = APPCustomBtnColor.cgColor
        refuseBtn.layer.borderWidth = 1
        limitDateBtn.layer.cornerRadius = 18
        limitDateBtn.clipsToBounds = true
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
