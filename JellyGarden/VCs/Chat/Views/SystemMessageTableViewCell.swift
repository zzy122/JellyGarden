//
//  SystemMessageTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/26.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class SystemMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTopDistance: NSLayoutConstraint!
    @IBOutlet weak var messageTime: UILabel!
    @IBOutlet weak var messageCount: UILabel!
    @IBOutlet weak var messageDetail: UILabel!
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    var models:[NotifyModel]?
    {
        didSet {
            self.messageTime.text = nil
            self.messageDetail.text = nil
            guard let tagModels = models , tagModels.count > 0 else
            {
                self.setNeedsLayout()
                return
            }
            self.messageCount.isHidden = false
            if tagModels.count == 1
            {
                if tagModels.last?.readView == true
                {
                    self.messageCount.text = "1"
                }
                else
                {
                    self.messageCount.isHidden = true
                }
            }
            else
            {
                   self.messageCount.text = "\(tagModels.count)"
            }
            self.messageTime.text = distanceTime(time: (tagModels.last?.currentTime)!)
            self.messageDetail.text = tagModels.last?.message
            self.setNeedsLayout()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        self.messageCount.backgroundColor = APPCustomRedColor
        self.messageCount.layer.cornerRadius = 10.0
        
        self.messageCount.clipsToBounds = true
        if messageDetail.text?.count == 0 || messageDetail.text?.count == nil
        {
            titleTopDistance.constant = (self.bounds.height - 20) / 2.0 
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
