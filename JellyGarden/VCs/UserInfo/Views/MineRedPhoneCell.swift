//
//  MineRedPhoneCell.swift
//  JellyGarden
//
//  Created by weipinzhiyuan on 2018/6/24.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import SnapKit

let ClickSettingRedpacket = "ClickSettingRedpacket"
let ClickFirstPhoto = "ClictFirstPhoto"

class MineRedPhoneCell: UITableViewCell {
    lazy var imageBodyView:PersonInfoImageView = {
        let view = PersonInfoImageView.init(frame:  CGRect.init(x: 0, y: 0, width: (self.frame.width), height: self.frame.height))
//        view.userModel = CurrentUserInfo?.data
        view.itemHeight = (ScreenWidth - 3 * 10) / 4
        self.addSubview(view)
        return view
    }()
    @IBOutlet weak var descriptionLab: UILabel!
    override func layoutSubviews() {
        
        if let photos = CurrentUserInfo?.custom_photos,photos.count > 0
        {
            imageBodyView.frame = self.bounds
            self.imageBodyView.isHidden = false
            self.imageBodyView.userModel = CurrentUserInfo
        }
        else
        {
            self.imageBodyView.isHidden = true
        }
        
        if CurrentUserInfo?.sex == 0
        {
            descriptionLab.text = "有照片才能吸引女士哦"
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
    
    @IBAction func touchRedPhoto() {
        guard let photos = CurrentUserInfo?.custom_photos,photos.count > 0 else
        {
            alertHud(title: "请先上传图片")
            return
        }
        
        zzy.router(name: ClickSettingRedpacket, object: nil, info: nil)
        
    }
    
    @IBAction func uploadFirstPhoto() {
        zzy.router(name: ClickFirstPhoto, object: nil, info: nil)
    }
}

