//
//  DepositManagerTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class DepositManagerTableViewCell: UITableViewCell {


    @IBOutlet weak var statusLab: UILabel!
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
        statusLab.addCorners(roundCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.bottomLeft.rawValue) | UInt8(UIRectCorner.topLeft.rawValue))), cornerSize: CGSize.init(width: 8, height: 8))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
