//
//  APPCustomDefine.swift
//
//  Created by zzy on 2018/4/10.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON

class APPCustomDefine: NSObject {

}

var NeedGesterPassword:Bool = false {
    didSet{
        UserDefaults.standard.set(NeedGesterPassword, forKey: "NeedGesterPassword")
    }
}

let SERVER_HOST:String = "http://mianju.sxyunshui.com/"
//let SERVER_HOST:String = "http://mianju.sxyunshui.com/admin/user/"

let UserPath:String = {
    let path:String = "\(documentPath)/User"
    
    if (!FileManager.default.fileExists(atPath: path))
    {
        do {
            
           try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        catch(let error)
        {
            
        }
    }
    return path
    
}()
let UserPlist:String = {
    let path:String = "\(UserPath)/user.plist"
    
    if (!FileManager.default.fileExists(atPath: path))
    {
    
        if !FileManager.default.createFile(atPath: path, contents: nil, attributes: nil) {
            print("创建用户文件失败")
            return ""
//            DebugLog(message: "")
        }
        NSDictionary.init(dictionary: ["":""]).write(toFile: path, atomically: true)
    }
    return path
}()
let LocalCitys:String = {
    let path:String = "\(UserPath)/citys.plist"
    
    if (!FileManager.default.fileExists(atPath: path))
    {
        if !FileManager.default.createFile(atPath: path, contents: nil, attributes: nil) {
            print("创建用户文件失败")
        }
    }
    return path
    
}()
var currentCitys:[PikerModel]?
{
    get{
        let dic = NSArray.init(contentsOfFile: LocalCitys)
        if let user = dic {
            
            return  JSONDeserializer<PikerModel>.deserializeModelArrayFrom(array: user) as? [PikerModel]
        }
        return nil
    }
}

var CurrentUserInfo: UserModel? {
    get{
        let dic = NSDictionary.init(contentsOfFile: UserPlist)
        if let user = dic {
           return  UserModel.deserialize(from: user)
        }
        return nil
    }
}//当前用户信息

let RegisterSexMan = "RegisterSexMan"
let BTNHEIGHT:CGFloat = 48

let APPCustomRedColor = k_CustomColor(red: 233, green: 81, blue: 153)

let APPCustomGrayColor = UIColor.init(red: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
let APPCustomBtnColor = UIColor.init(red: 84.0 / 255.0, green: 131.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
let customBackViewColor = k_CustomColor(red: 243, green: 245, blue: 249)
let RongIMKey = "ik1qhw09ip0hp"//融云key
let JPushNOtification = "JPushNOtification"//收到信鸽推送发送通知

//极光
let JPushChannel:String = "App Store"
let JPushAppKey = "8cc1244924af16e493b9d08f"

//友盟key
let UMengKey = "5b2347a2f43e4806580000c9"
//微信分享
let WeiChatShareKey = "wxd2e1aa0feed6b934"
let WeiChatShareScrete = "4b89be2b0c428ff608a18e98f5140b1e"//4b89be2b0c428ff608a18e98f5140b1e   jXBXYm7rz6b7RVJNpa5mSy5L0Fy96sz3
//QQ分享
let QQShareKey = "1106938724"
let QQShareSecrete = "Bo3kPkPS8ICSMdgZ"
let scale = UIScreen.main.scale
let placeImage = imageName(name: "loginicon")

















