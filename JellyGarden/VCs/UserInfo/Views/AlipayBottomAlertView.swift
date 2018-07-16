//
//  AlipayBottomAlertView.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/11.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class AlipayBottomAlertView: UIView {
    typealias backAmount = (String) -> Void
    
    var model:AlipayModel? {
        didSet{
            self.nameLab.text = model?.name
            self.accountlab.text = model?.account
        }
    }
    class func createAlipayBottomAlertView() -> AlipayBottomAlertView
    {
        let nibView = CustomCreateNib<AlipayBottomAlertView>().createXibView()
        return nibView!
    }
    var backStr:backAmount?
    var clickChageAccount:(() -> Void)?
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var maxAmountLab: UILabel!
    @IBOutlet weak var amountTextFiled: UITextField!
    @IBOutlet weak var accountlab: UILabel!
    @IBAction func clickSureBtn(_ sender: UIButton) {
       self.backStr?(self.amountTextFiled.text ?? "")
        
    }
    
    @IBAction func clickChangeAccountBtn(_ sender: UIButton) {
        self.clickChageAccount?()
    }
    
    
    
    /*
    
     // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
