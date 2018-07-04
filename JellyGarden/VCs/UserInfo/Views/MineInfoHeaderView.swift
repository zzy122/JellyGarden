//
//  MineInfoHeaderView.swift
//  JellyGarden
//
//  Created by weipinzhiyuan on 2018/6/24.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

let Mine_Info_Renzhen = "Mine_Info_Renzhen"
let Mine_Info_HeaderInfo = "Mine_Info_HeaderInfo"
let Mine_Info_Wallet = "Mine_Info_Wallet"
let Mine_Info_Dingjing = "Mine_Info_Dingjing"
let Mine_Info_Guangbo = "Mine_Info_Guangbo"
let Mine_Info_Like = "Mine_Info_Like"

class MineInfoHeaderView: UIView {
    
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameInfoLabel: UILabel!
    @IBOutlet weak var appointmentLabel: UILabel!
    @IBOutlet weak var renzhenButton: UIButton!
    
    var userInfo: UserModel? {
        didSet {
            headerButton.kf.setImage(with: URL(string: userInfo?.data?.avatar ?? ""),
                                     for: UIControlState.normal,
                                     placeholder: UIImage(named: "照片缺省"),
                                     options: nil,
                                     progressBlock: nil,
                                     completionHandler: nil)
            nameLabel.text = userInfo?.data?.nickname
            var info = ""
            if let city = userInfo?.data?.city {
                info += city
            }
            if let age = userInfo?.data?.age {
                info += " \(age)岁"
            }
            if let identify = userInfo?.data?.identity {
                info += identify
            }
            nameInfoLabel.text = info
            appointmentLabel.text = "约会范围：\(userInfo?.data?.appointment_place?.joined(separator: " ") ?? "")"
            if userInfo?.data?.has_authentication == true {
                renzhenButton.setTitle("已认证", for: UIControlState.normal)
                renzhenButton.backgroundColor = hexString(hex: "6388C5")
                renzhenButton.isEnabled = false
            }
            else {
                renzhenButton.setTitle("去认证", for: UIControlState.normal)
                renzhenButton.backgroundColor = hexString(hex: "E8E8E8")
                renzhenButton.isEnabled = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        renzhenButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        renzhenButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        renzhenButton.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }

    @IBAction func touchRenzhen() {
        zzy.router(name: Mine_Info_Renzhen, object: nil, info: nil)
    }
    
    @IBAction func touchHeader() {
        zzy.router(name: Mine_Info_HeaderInfo, object: nil, info: nil)
    }
    
    @IBAction func touchWallet() {
        zzy.router(name: Mine_Info_Wallet, object: nil, info: nil)
    }
    
    @IBAction func touchDingjing() {
        zzy.router(name: Mine_Info_Dingjing, object: nil, info: nil)
    }
    
    @IBAction func touchGuangbo() {
        zzy.router(name: Mine_Info_Guangbo, object: nil, info: nil)
    }
    
    @IBAction func touchLike() {
        zzy.router(name: Mine_Info_Like, object: nil, info: nil)
    }
}
