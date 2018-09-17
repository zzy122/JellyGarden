//
//  ChatDepositAlertView.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/31.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ChatDepositAlertView: UIView {
    typealias clickChatDepositBlock = (Bool,String?,String?) -> Void
    var timeStr:String = ""
    
    @IBOutlet weak var timeBackView: UIView!
    @IBOutlet weak var textBackView: UIView!
    lazy var picker:ZZYdatepicker = {
        let pickerView = ZZYdatepicker()
        pickerView.back = {[weak pickerView](str) in
            DebugLog(message: "\(String(describing: str))")
            self.timeStr = str ?? ""
            self.timeLab.text = str
            pickerView?.hidenPickerView()
        }
        return pickerView
        
    }()
    
    @IBAction func clickSureBtn(_ sender: UIButton) {
        if (depositAmountTextFiled.text?.count ?? 0) < 1
        {
            alertHud(title: "请输入订金")
            return
        }
        if (timeStr.count < 2)
        {
            alertHud(title: "请选择约会时间")
            return
        }
        clickBlock?(true,depositAmountTextFiled.text,timeStr)
    }
    @IBAction func clickCancelBtn(_ sender: UIButton) {
        clickBlock?(false,depositAmountTextFiled.text,timeStr)
    }
    
    @IBAction func clickSelectTimeBtn(_ sender: UIButton) {
        self.depositAmountTextFiled.resignFirstResponder()
        self.picker.showPickerView()
    }
    override func layoutSubviews() {
        
        textBackView.layer.cornerRadius = 22.5
        textBackView.clipsToBounds = true
        timeBackView.layer.cornerRadius = 22.5
        timeBackView.backgroundColor = UIColor.white
        timeBackView.layer.borderColor = UIColor.lightGray.cgColor
        timeBackView.clipsToBounds = true
        timeBackView.layer.borderWidth = 1.0
        
    }
    @IBOutlet weak var timeLab: UILabel!
    var clickBlock:clickChatDepositBlock?
    @IBOutlet weak var depositAmountTextFiled: APPTextfiled!
    class func createChatDepositAlertView() -> ChatDepositAlertView
    {
        let nib = CustomCreateNib<ChatDepositAlertView>().createXibView()
        return nib!
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
