//
//  EnlistDetailTableViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class EnlistDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var nikeNameLab: UILabel!
    @IBOutlet weak var commentTimeLab: UILabel!
    @IBOutlet weak var headerBtn: UIButton!
    @IBOutlet weak var contentImageBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var model:commentsModel? {
        didSet{
            self.headerBtn.imageView?.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: model?.publisher_avatar ?? "http://test")!), placeholder: placeImage, options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(1)), KingfisherOptionsInfoItem.forceRefresh], progressBlock: nil, completionHandler: nil)
            self.nikeNameLab.text = model?.publisher_name
            self.commentTimeLab.text = timeStampToDate(time: model?.create_at ?? 0, backType: .second)
            
        }
    }
    @IBAction func clickContentBtn(_ sender: UIButton) {
    }
    @IBAction func clickHeaderBtn(_ sender: UIButton) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
