//
//  SelectPayView.swift
//  JellyGarden
//
//  Created by kfzs on 2018/9/13.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
protocol SelectPayViewDelegate:NSObjectProtocol {
    func clickAlipai()
    func clickWeiChatPay()
    func clickClose()
}

class SelectPayView: UIView {
    var delegate:SelectPayViewDelegate?
    
    @IBOutlet weak var alipayBtn: UIButton!
    @IBOutlet weak var weichatBtn: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        self.addCorners(roundCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topLeft.rawValue) | UInt8(UIRectCorner.topRight.rawValue))), cornerSize: CGSize.init(width: 10, height: 10))
    }
    @IBAction func clickWeiChatPai(_ sender: UIButton) {
        delegate?.clickWeiChatPay()
    }
    @IBAction func clickAlipay(_ sender: UIButton) {
        delegate?.clickAlipai()
    }
    @IBAction func clickClose(_ sender: UIButton) {
        delegate?.clickClose()
    }
    
    class func createSelectPayView() -> SelectPayView? {
        let nibView = CustomCreateNib<SelectPayView>().createXibView()
        guard let view = nibView else {
            return nil
        }
        view.backgroundColor = UIColor.white
        return view;
    }
}
