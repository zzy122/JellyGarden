//
//  LookImageBodyView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/8.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let finishLookComplete = "finishLookComplete"


class LookImageBodyView: UIView {
    
    @IBOutlet weak var subWarmLab: UILabel!
    @IBOutlet weak var warmTitleLab: UILabel!
    @IBOutlet weak var imageShow: UIImageView!
    @IBOutlet weak var imageBack: UIImageView!
    lazy var gester: UILongPressGestureRecognizer = {
        let gexter:UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(LongToch))
        gexter.minimumPressDuration = 3.0//长按3秒
        return gexter
    }()
    lazy var implementView:UIView = {
        let beffe = UIBlurEffect.init(style: UIBlurEffectStyle.light)
        let view = UIVisualEffectView.init(effect: beffe)
        self.insertSubview(view, aboveSubview: imageBack)
        view.alpha = 0.0
        view.addGestureRecognizer(self.gester)

        return view
    }()
    class func createLookImageView() ->LookImageBodyView? {
        
        let nibView = CustomCreateNib<LookImageBodyView>().createXibView()
        return nibView
    }
//    var tagFrame:CGRect = CGRect.zero {
//        didSet{
//            self.implementView.frame = CGRect.init(x: 0, y: 0, width: tagFrame.width, height: tagFrame.height)
//        }
//    }
//    override func draw(_ rect: CGRect) {
//        self.frame = tagFrame
//    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    
    func starLookEffect(type:LookImageType) {
        if type == .clearness {
            self.imageShow.isHidden = true
            self.warmTitleLab.isHidden = true
            self.subWarmLab.isHidden = true
            self.implementView.alpha = 0.0
        }
        else if type == .lookAfter
        {
            self.imageShow.isHidden = false
            self.imageShow.image = imageName(name: "已焚毁")
            self.warmTitleLab.text = "照片已焚毁"
            self.warmTitleLab.isHidden = false
            self.subWarmLab.isHidden = true
            self.implementView.alpha = 1.0
        }
        else
        {
            self.imageShow.isHidden = true
            self.warmTitleLab.text = "阅后即焚"
            self.warmTitleLab.isHidden = false
            self.subWarmLab.isHidden = false
            self.subWarmLab.text = "按住屏幕查看"
            self.implementView.alpha = 1.0
        }
        
    }
    
    @objc func LongToch() {
        self.starLookEffect(type: LookImageType.clearness)
        self.zzy.router(name: finishLookComplete, object: nil, info: nil)
        self.implementView.removeGestureRecognizer(self.gester)
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
