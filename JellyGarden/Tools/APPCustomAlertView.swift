//
//  APPCustomAlertView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class APPCustomAlertView: UIView {
    typealias clickSureEvent = (Bool,String?) -> Void
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var horizenView: UIView!
    @IBOutlet weak var detailLab: UILabel!
    @IBOutlet weak var inputTextView: APPTextfiled!
    @IBOutlet weak var titleLab: UILabel!
    var clickEvent:clickSureEvent?
    var tagFrame:CGRect?
    
    class func createAlertView(title:String?,placeHodel:String,detailTitle:String?,detailImage:UIImage?,frame:CGRect,click:@escaping clickSureEvent) -> APPCustomAlertView? {
        let nibView = CustomCreateNib<APPCustomAlertView>().createXibView()
        guard let view = nibView else {
            return nil
        }
        var height:CGFloat = 0
        if detailTitle == nil {
            height = 230
            view.detailImage.isHidden = true
            view.detailLab.isHidden = true
        }
        else
        {
            height = 250
        }
        
        view.detailImage.image = detailImage
        view.detailLab.text = detailTitle
        view.titleLab.text = title
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        view.clickEvent = click
        view.inputTextView.placeholder = placeHodel
        view.tagFrame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
        var frame = view.horizenView.frame
        frame.size = CGSize.init(width: frame.size.width, height: 1.0 / scale)
        view.horizenView.frame = frame
        
        return view

    }
    override func draw(_ rect: CGRect) {
        self.frame = tagFrame!
    }
    @IBAction func clickSure(_ sender: UIButton) {
        self.clickEvent!(true,inputTextView.text)
        
    }
    @IBAction func clickCancel(_ sender: UIButton) {
        self.clickEvent!(false,inputTextView.text)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
