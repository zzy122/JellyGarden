//
//  BodyImageCollectionViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class BodyImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    var type:LookImageType = .clearness
    
    func setImage(image:UIImage?,isImplement:LookImageType)
    {
        self.imageV.image = image
        
        switch isImplement {
        case .clearness:
            self.implementView.isHidden = true
            self.imageTag.isHidden = true
            self.warmtitle.isHidden = true
            break
        case .lookAfter:
            self.implementView.isHidden = false
            self.imageTag.isHidden = false
            
            self.warmtitle.isHidden = false
            self.imageTag.image = imageName(name: "已焚毁")
            
            self.warmtitle.text = "已焚毁"
            break
        case .effect:
            self.implementView.isHidden = false
            self.imageTag.isHidden = false
            self.warmtitle.isHidden = false
            self.imageTag.image = imageName(name: "阅后即焚")
            self.warmtitle.text = "阅后即焚"
            break
        }
    }
    lazy var imageTag:UIImageView = {
        let imageVW = UIImageView.init(frame: CGRect.init(x: (self.bounds.size.width - 20) / 2.0 , y: self.bounds.size.height / 2.0 - 20, width: 20, height: 20))
        self.insertSubview(imageVW, aboveSubview: self.implementView)
        return imageVW;
    }()
    lazy var warmtitle:UILabel = {
        let lable = creatLable(frame: CGRect.init(x: 0, y: self.imageTag.frame.maxY, width: self.bounds.size.width, height: 30), title: nil, font: kFont_SmallNormal, textColor: UIColor.white)
        lable.backgroundColor = UIColor.clear
        lable.textAlignment = NSTextAlignment.center
        self.insertSubview(lable, aboveSubview: self.implementView)
        return lable
    }()
    lazy var implementView:UIView = {//模糊
        let beffe = UIBlurEffect.init(style: UIBlurEffectStyle.light)
        let view = UIVisualEffectView.init(effect: beffe)
        view.frame = self.bounds
        self.insertSubview(view, aboveSubview: imageV)
        view.alpha = 1.0
        
        return view
    }()

}
