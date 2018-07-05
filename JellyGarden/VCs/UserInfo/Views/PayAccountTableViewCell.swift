//
//  PayAccountTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class PayAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var contentbackView: UIView!
    @IBOutlet weak var accountlable: UILabel!
    @IBOutlet weak var imageTag: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
