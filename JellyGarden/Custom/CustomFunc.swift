//
//  CustomFunc.swift
//
//  Created by zzy on 2018/4/12.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class CustomFunc: NSObject {
    

}
class CustomCreateNib<T>: NSObject {
    func createXibView() -> T?
    {
        let str = NSStringFromClass(T.self as! AnyClass)
        let classStr = str.zzy.zzy_subString(fromStr: ".")
        let nibVIew = Bundle.main.loadNibNamed(classStr, owner: nil, options: nil)
        guard let view = nibVIew?.first as? T else {
            return nil
        }
        return view
    }
}


func DebugLog<T>(message:T){
    #if DEBUG
        print("\(message)")
    #endif
}

/// 打印内容，并包含类名和打印所在行数
///
/// - Parameters:
///   - message: 打印消息
///   - file: 打印所属类
///   - lineNumber: 打印语句所在行数
func DebugLogLine<T>(message : T, file : String = #file, lineNumber : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):line:\(lineNumber)]- \(message)")
        
    #endif
}
func k_CustomColor(red:Int, green:Int, blue:Int) -> UIColor{
    
    return UIColor.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    
}

func imageName(name:String) -> UIImage? {
    return UIImage.init(named: name, in: Bundle.main, compatibleWith: nil)
}
//保存数据到指定文件
func saveDataToFile(data:[String:Any], file:String)
{
    if !FileManager.default.fileExists(atPath: User_Path) {
        do
        {
            try FileManager.default.createDirectory(atPath: User_Path, withIntermediateDirectories: true, attributes: nil)
        }
        catch{}
    }
    NSDictionary(dictionary:data).write(toFile: file, atomically: true)
}


func creatLable(frame:CGRect?,title:String?,font:UIFont?,textColor:UIColor?) -> UILabel {
    let lable = UILabel.init(frame: frame ?? CGRect.zero)
    lable.font = font ?? kFont_system15
    lable.text = title ?? ""
    lable.textColor = textColor ?? UIColor.black
    lable.backgroundColor = UIColor.white
    return lable
    
}
func alertHud(title:String)
{
    HUD.flash(HUDContentType.label(title), onView: UIApplication.shared.keyWindow, delay: 1) { (result) in
        
    }
}
func getJSONStringFromObject(dictionary:Any) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
    
}
func getTimeStamp(date:Date) -> Int{
    let timeInterval:TimeInterval = date.timeIntervalSince1970
    let timeStamp = Int(timeInterval)
    return timeStamp
}
enum DateFormatterType{
    case second;
    case day;
}
func timeStampToDate(time:Int , backType:DateFormatterType) -> String{
    //转换为时间
    let timeSecond = time / 1000
    let timeInterval:TimeInterval = TimeInterval.init(timeSecond)
    let date = Date.init(timeIntervalSince1970:timeInterval)
    
    //格式话输出
    let dformatter = DateFormatter()
    if backType == .day {
        dformatter.dateFormat = "yyyy-MM-dd"
    }
    else
    {
       dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    return dformatter.string(from: date)
}
func stringToTimeStamp(dateStr:String?) -> Int{
    let dateFormatter = DateFormatter.init()
    
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    guard let str = dateStr else {
        
        return getTimeStamp(date: Date())
    }
    
    let date = dateFormatter.date(from: str)
    return getTimeStamp(date: date ?? Date())
}

//反地理编码
func reverseGeocode(latitude:Double, longitude: Double) -> String?{
    let geocoder = CLGeocoder()
    var cityName:String? = ""
    let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
    geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
        guard error == nil else {
            return print(error!.localizedDescription)
        }
        
        guard let p = placemarks?[0] else {
            return print("没有找到一个地址")
        }
        cityName = p.name
    }
    
    return cityName
}
//地理编码
func locationEncode(cityName:String)  -> CLLocation? {
    let geocoder = CLGeocoder()
    var location:CLLocation?
    
    geocoder.geocodeAddressString(cityName) { (placemarks, error) in
        guard error == nil else {
            return print(error!.localizedDescription)
        }
        
        guard let p = placemarks?[0] else {
            return print("没有找到一个地址")
        }
        location = p.location
        let longitude = p.location?.coordinate.longitude
        let latitude = p.location?.coordinate.latitude
        print("经度：\(longitude),维度：\(latitude)")
    }
    return location
}






