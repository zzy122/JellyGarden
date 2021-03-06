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
    var model:PhotoModel?
    {
        didSet{
            
            var type:LookImageType = .clearness
            switch model?.type {
            case 0?://普通
                break
            case 1?://阅后即焚
                type = .effect
                break
            case 2?://红包
                break
            case 3?:
                break
            default:
                break
            }
            
            if let users = model?.view_users,users.contains((CurrentUserInfo?.user_id)!)
            {
               type = .lookAfter
            }
            
            self.setImage(imageStr: model?.url_list ?? "", isImplement: type,image:nil)
        }
    }
    var type:LookImageType = .clearness
    
    func setImage(imageStr:String?,isImplement:LookImageType,image:Image?)
    {
        if let str = imageStr
        {
            self.imageV.sd_DownLoadImage(url: str, complection: { (image) in
                
            })
        }
       if let ima = image
       {
        self.imageV.image = ima
        }
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
//    override func layoutSubviews() {
//       self.imageV.frame = self.bounds
//    }
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
