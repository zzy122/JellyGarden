//
//  AddImageCollectionViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/16.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickDeleteCell = "ClickDeleteCell"

class AddImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deletBtn: UIButton!
    @IBOutlet weak var imageV: UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
        deletBtn.layer.cornerRadius = 10
        deletBtn.clipsToBounds = true
//        self.imageV.frame = self.bounds
//        self.deletBtn.frame = CGRect.init(x: self.bounds.width - 20, y: 0, width: 20, height: 20)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var imageStr:String = "" {
        didSet{
            self.imageV.sd_DownLoadImage(url: imageStr)
            self.imageV.contentMode = UIViewContentMode.scaleToFill
        }
    }


    @IBAction func clickDelete(_ sender: UIButton) {
        self.zzy.router(name: ClickDeleteCell, object: nil, info: self.tag)
    }
}
