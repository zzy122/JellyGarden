//
//  DepositRefundTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class DepositRefundTableViewCell: UITableViewCell {
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var descriptionLab: UILabel!
    @IBOutlet weak var amountLab: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var nikeLable: UILabel!
    @IBOutlet weak var headerImag: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        headerImag.layer.cornerRadius = 25
        headerImag.clipsToBounds = true
    }

    @IBAction func clickAgreeBtn(_ sender: UIButton) {
    }
    @IBAction func clickDisagree(_ sender: UIButton) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
