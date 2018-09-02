//
//  SetRedpacketCollectionViewCell.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/27.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickSelected_RedPacket = "ClickSelected_RedPacket"
class SetRedpacketCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagBtn: UIButton!
    @IBOutlet weak var contentImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var model:PhotoModel?
    {
        didSet{
            self.contentImageView.sd_DownLoadImage(url: model?.url_list ?? "")
        }
    }
    @IBAction func clickSelectCellBtn(_ sender: UIButton) {
        zzy.router(name: ClickSelected_RedPacket, object: nil, info: self.tag)
        self.tagBtn.isSelected = true
    }
}
