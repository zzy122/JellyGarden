//
//  PackageView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let PackageViewClick = "PackageViewClick"

class PackageView: UIView {
    @IBOutlet weak var origPriceLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var descriptionLab: UILabel!
    let color  = k_CustomColor(red: 255, green: 0, blue: 138)
    var tagFrame:CGRect?
    class func getPackageView() -> PackageView? {
        let nibView = CustomCreateNib<PackageView>().createXibView()
        guard let view = nibView else {
            return nil
        }
        
        view.layer.cornerRadius = 10.0;
        view.clipsToBounds = true
        view.isSelected = false
//        view.layer.borderColor = view.color.cgColor
        view.layer.borderWidth = 3.0
        return view
    }
    var model:VipPageModel?{
        didSet{
            self.origPriceLab.attributedText = getDeleteStr(str: String.init(format: "%d", model?.package_original_price ?? 0))
            self.priceLab.attributedText = getPriceStr(str: String.init(format: "¥%d", model?.package_discount_price ?? 0)) 
            self.descriptionLab.text = model?.package_name
        }
    }
    
   
    func getPriceStr(str:String) -> NSMutableAttributedString {
        let aStr = NSMutableAttributedString.init(string: str)
        aStr.addAttributes([NSAttributedStringKey.font:kFont_SmallNormal], range: NSRange.init(location: 0, length: 1))
        aStr.addAttributes([NSAttributedStringKey.font:kFont_system23], range: NSRange.init(location: 1, length: str.count - 1))
        aStr.addAttributes([NSAttributedStringKey.foregroundColor:color], range: NSRange.init(location: 0, length: str.count))
        let  style:NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        style.alignment = NSTextAlignment.center
        aStr.addAttributes([NSAttributedStringKey.paragraphStyle:style], range: NSRange.init(location: 0, length: str.count))
        return aStr
    }
    func getDeleteStr(str:String) -> NSMutableAttributedString  {
        let aStr = NSMutableAttributedString.init(string: str)
        aStr.addAttributes([NSAttributedStringKey.font:kFont_SmallNormal], range: NSRange.init(location: 0, length: 1))
        aStr.addAttribute(NSAttributedStringKey.strikethroughStyle, value:  NSNumber(value: 1), range: NSRange.init(location: 0, length: str.count))
        aStr.addAttribute(NSAttributedStringKey.strikethroughColor, value:  color, range: NSRange.init(location: 0, length: str.count))
        aStr.addAttributes([NSAttributedStringKey.foregroundColor:color], range: NSRange.init(location: 0, length: str.count))
        return aStr
    }
    var _isSelected:Bool = false
    var isSelected:Bool {
        set{
            _isSelected = newValue
            if _isSelected {
                self.layer.borderColor = color.cgColor
            }
            else
            {
                self.layer.borderColor = UIColor.white.cgColor
            }
        }
        get{
            
            return _isSelected
        }
    }
    
//    func isSelected(select:Bool) {
//        if select {
//            self.layer.borderColor = color.cgColor
//        }
//        else
//        {
//            self.layer.borderColor = UIColor.white.cgColor
//        }
//
//    }
    @IBAction func clickBtn(_ sender: UIButton) {
        if isSelected {
            return
        }
        self.zzy.router(name: PackageViewClick, object: nil, info: self.tag)
        self.isSelected = true
    }
    override func draw(_ rect: CGRect) {
        self.frame = tagFrame!
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
