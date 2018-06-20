//
//  DepositView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/2.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import SnapKit
class DepositView: UIView {
    
    var imag = UIImage()
    
   @objc public lazy var imageView:UIImageView = {
        let iMV = UIImageView()
        iMV.frame = CGRect.init(x: 15, y: 10, width: 30, height: 30)
        iMV.image = imageName(name: "")
        self.addSubview(iMV)
        return iMV
    }()
   @objc public lazy var amountLab:UILabel = {
        let lable = UILabel()
        lable.font = kFont_system16
        lable.textColor =  UIColor.white
        lable.backgroundColor = UIColor.clear
        self.addSubview(lable)
        lable.snp.makeConstraints({ (make) in
            make.left.equalTo(self.imageView.snp.right).offset(8)
            make.top.equalTo(imageView.snp.top)
            make.height.equalTo(18)
        })
        return lable
    }()
   @objc public lazy var subLab:UILabel = {
        let lable = UILabel()
        lable.font = kFont_SmallNormal
        lable.textColor =  UIColor.gray
        lable.backgroundColor = UIColor.white
        self.addSubview(lable)
        lable.text = "  订单支付红包"
        lable.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.bottom.equalToSuperview().offset(0)
            make.right.equalTo(0)
            make.height.equalTo(18)
            
        })
        return lable
    }()
   @objc public lazy var detailLab:UILabel = {
        let lable = UILabel()
        lable.font = kFont_SmallNormal
        lable.textColor =  UIColor.white
        lable.backgroundColor = UIColor.clear
        self.addSubview(lable)
        lable.snp.makeConstraints({ (make) in
            make.left.equalTo(self.amountLab.snp.left).offset(0)
            make.top.equalTo(self.amountLab.snp.bottom).offset(0)
        })
        return lable
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 1.0, green: 155.0 / 255.0, blue: 0, alpha: 1.0)
        self.imageView.isHidden = false
        subLab.isHidden = false
        amountLab.isHidden = false
        detailLab.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
