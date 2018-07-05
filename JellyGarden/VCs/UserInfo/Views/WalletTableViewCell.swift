//
//  WalletTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLab: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var describtionlable: UILabel!
    @IBOutlet weak var nickNameLable: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
