//
//  CommentTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/13.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleWidth: NSLayoutConstraint!
    @IBOutlet weak var commentLab: UILabel!
    @IBOutlet weak var nickNameLab: UILabel!
    var title:String = ""  {
        didSet{
            self.titleWidth.constant = title.zzy.caculateWidth(font: kFont_system15)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
