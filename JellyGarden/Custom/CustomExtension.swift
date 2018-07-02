//
//  CustomExtension.swift
//
//  Created by zzy on 2018/4/12.
//  Copyright © 2018年 zzy. All rights reserved.
//

import Foundation
import UIKit
protocol GeneralExt {
    associatedtype DT
    /// 访问原来的value
    var v: DT { get }
}
/// 扩展点基础实现:
public final class ExtBaseImpl<T>: GeneralExt {
    typealias ZT = T
    public let v: T
    public init(v: T) {
        self.v = v
    }
}
/// 扩展点protocol：作为扩展和访问点
protocol ExtPoint {
    associatedtype ZT
    
    /// 访问 扩展功能（这个可以修改为其他的名字，所有的功能在该属性下访问 zzy.*），比如修改 ch，那么就通过 zzy.*
    var zzy: ZT { get }
}
//给string添加扩展
extension String: ExtPoint {
    
    var zzy: ExtBaseImpl<String> {
        return ExtBaseImpl.init(v: self)
        
    }
}

extension GeneralExt where DT == String
{
    
    
    func containts(str:String) ->Bool//标准判断
    {
        if v.range(of: str) != nil {
            return true
        }
        
        return false
    }
    
    func containsIgnoringCase(find: String) -> Bool{//忽略字母大小写
        return v.range(of: find, options: .caseInsensitive) != nil
    }
    //字符串操作
    //字符串操作
    func zzy_subString(fromStr:String) -> String {//从某个位置开始
        if v.count > 0 {
            let indexRange:NSRange = self.nsRange(from: v.range(of: fromStr)) ?? NSRange.init(location: 0, length: 0)
            let strIndex = v.index(v.endIndex, offsetBy: -(v.count - indexRange.location - indexRange.length))
            
            return String(v[strIndex...])
            
        }
        return ""
    }
    func zzy_subString(toStr:String) -> String {//截取到某个位置
        
        let indexRange:NSRange = self.nsRange(from: v.range(of: toStr)) ?? NSRange.init(location: 0, length: 0)
        if indexRange.location == 0 {
            return ""
        }
        
        let strIndex = v.index(v.startIndex, offsetBy: indexRange.location - 1)
        return String(v[...strIndex])
    }
    
    func zzy_subString(star:Int, length:Int) -> String {//
        let starIndex = v.index(v.startIndex, offsetBy: star)
        let endIndex = v.index(starIndex, offsetBy: length)
        
        return String(v[starIndex..<endIndex])
        
        
    }
    func zzy_subString(fromIndex:Int) -> String {
        if v.count > fromIndex {
            let index = v.index(v.endIndex, offsetBy: fromIndex - v.count)
            return String(v[index...])
        }
        return ""
    }
    func zzy_subString(toIndex:Int) -> String {
        if v.count > toIndex {
            let index = v.index(v.startIndex, offsetBy: toIndex)
            return String(v[...index])
        }
        return ""
    }
    
    
    func nsRange(from range: Range<String.Index>?) -> NSRange? {//range->nsrange
        if let range1 = range {
            return NSRange.init(range1, in: v)
        }
        return nil
        
        
    }
    func range(from nsRange: NSRange) -> Range<String.Index>? {//nsrang->range
        guard
            let from16 = v.utf16.index(v.utf16.startIndex, offsetBy: nsRange.location, limitedBy: v.utf16.endIndex),
            let to16 = v.utf16.index(from16, offsetBy: nsRange.length, limitedBy: v.utf16.endIndex),
            let from = String.Index(from16, within: v),
            let to = String.Index(to16, within: v)
            else { return nil }
        return from ..< to
    }
    //计算文字高度
    func caculateHeight(font:UIFont,width:CGFloat,lineSpace : CGFloat) -> CGFloat {
        
        //        let size = CGSizeMake(width,CGFloat.max)
        if v.count == 0 {
            return 0.0
        }
        
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = lineSpace
        
        paragraphStyle.lineBreakMode = .byWordWrapping;
        
        let attributes = [NSAttributedStringKey.font:font, NSAttributedStringKey.paragraphStyle:paragraphStyle.copy()]

        let rect = v.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height
    }
    func caculateWidth(font:UIFont) -> CGFloat {
        
        let str = v as NSString
        let rect = str.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: 30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil)
        
        return ceil(rect.width)
    }
    //md5加密
    func md5() ->String!{
        let str =
            v.cString(using: String.Encoding.utf8)
  
        let strLen = CUnsignedInt(v.lengthOfBytes(using: String.Encoding.utf8))
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
    
}

extension UIResponder: ExtPoint {
    
    var zzy: ExtBaseImpl<UIResponder> {
        return ExtBaseImpl.init(v: self)
        
    }
}

extension GeneralExt where DT == UIResponder
{
    func router(name:String, object:UIResponder?,info:Any?) {
        if let intercept = v.next as? ResponderRouter {
            intercept.interceptRoute(name: name, objc: nil, info: info)
            return
        }
        v.next?.zzy.router(name: name, object: object, info: info)
    }
}


extension UIImageView
{
    func sd_DownLoadImage(url:String){
        self.kf.setImage(with: URL.init(string: url) ?? URL.init(fileURLWithPath: "loginicon"), placeholder: placeImage, options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(1)), KingfisherOptionsInfoItem.fromMemoryCacheOrRefresh], progressBlock: nil, completionHandler: nil)
    }
}

func hexString(hex: String) -> UIColor {
    var red: CGFloat   = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat  = 0.0
    var alpha: CGFloat = 1.0
    
    let scanner = Scanner(string: hex)
    var hexValue: CUnsignedLongLong = 0
    if scanner.scanHexInt64(&hexValue) {
        switch (hex.count) {
        case 3:
            red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
            green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
            blue  = CGFloat(hexValue & 0x00F)              / 15.0
        case 4:
            red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
            green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
            blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
            alpha = CGFloat(hexValue & 0x000F)             / 15.0
        case 6:
            red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
            blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
        case 8:
            red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
            alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
        default:
            // Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8
            return UIColor()
        }
    } else {
        // "Scan hex error
        return UIColor()
    }
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}






