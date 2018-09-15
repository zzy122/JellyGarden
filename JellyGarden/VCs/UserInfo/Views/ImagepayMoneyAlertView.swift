//
//  ImagepayMoneyAlertView.swift
//  JellyGarden
//
//  Created by kfzs on 2018/9/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ImagepayMoneyAlertView: UIView {
    class func createAlertView() -> ImagepayMoneyAlertView
    {
        let nibView = CustomCreateNib<ImagepayMoneyAlertView>().createXibView()
        return nibView!
    }
    var clickTag:clickBtn?
    typealias clickBtn = (Bool,String?) -> Void
    func clickBtnAction(back:@escaping clickBtn)
    {
        self.clickTag = back
    }
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var moneyAccountFiled: UITextField!
    @IBAction func clickSure(_ sender: UIButton) {
        guard let text = moneyAccountFiled.text else
        {
            alertHud(title: "请设置金额")
            return
        }
        
        self.clickTag?(true,text)
    }
    @IBAction func clickCloseBtn(_ sender: UIButton) {
        self.clickTag?(false,nil)
    }
    @IBOutlet weak var nickNameLab: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    override func layoutSubviews() {
        headerImage.layer.cornerRadius = 25.0
        headerImage.layer.masksToBounds = true
        backView.layer.cornerRadius = 8.0
        backView.layer.masksToBounds = true
        headerImage.sd_DownLoadImage(url: CurrentUserInfo?.avatar ?? "", complection: { (image) in
            
        })
        nickNameLab.text = CurrentUserInfo?.nickname
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
