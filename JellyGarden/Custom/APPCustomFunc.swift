//
//  APPCustomFunc.swift
//  Swift
//
//  Created by zzy on 2018/4/12.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
enum AppiontCellType {
    case detail;
    case mainList;
}

typealias loginFinish = (Bool) -> Void
class APPCustomFunc: NSObject {
    static let shareCustomFunc = APPCustomFunc()
    
    private override init() {
    }
    
    
    
}

var RootViewController:BaseTabBarViewController?

func TopViewContoller() -> BaseViewController? {
    if let tabVC = RootViewController {
        
        if let nav:CustomNavigationViewController = tabVC.selectedViewController as? CustomNavigationViewController
        {
            return nav.topViewController as? BaseViewController
        }
        else if let vc = tabVC.selectedViewController as? BaseViewController
        {
            return vc
        }
        else
        {
            return tabVC.selectedViewController as?BaseViewController
        }
    }
    return nil
}
func RootNav() -> CustomNavigationViewController {
    let nav:CustomNavigationViewController = RootViewController?.selectedViewController as! CustomNavigationViewController
    
    return nav
}

//登录跳转
func gotoLoginVC(finish:@escaping loginFinish) -> () {
    
}
func createCustomBtn(frame:CGRect,sel:Selector,target:AnyObject,title:String) -> UIButton {
    let btn = UIButton.init(frame: frame)
    btn.layer.cornerRadius = BTNHEIGHT / 2.0
    
    btn.addTarget(target, action: sel, for: UIControlEvents.touchUpInside)
    btn.backgroundColor = APPCustomBtnColor
    btn.setTitle(title, for: UIControlState.normal)
    btn.setTitleColor(UIColor.white, for: UIControlState.normal)
    return btn
    
}
func continueString(strAry:[String]?,separetStr:String) -> String {
    guard let ary = strAry else {
        return ""
    }
    var str = ""
    for i in 0 ..< ary.count {
        if i == ary.count - 1
        {
            str.append(ary[i])
        }
        else{
            str.append(ary[i])
            str.append(separetStr)
        }
    }
    return str
}
//清除用户信息
func clearUserInfo()
{
   try? FileManager.default.removeItem(atPath: UserPlist)
}
//添加照片的协议方法
var UnreadCount:Int {
    get {
        return Int(RCIMClient.shared().getUnreadCount([NSNumber.init(value: UInt8(RCConversationType.ConversationType_PRIVATE.rawValue)),NSNumber.init(value: UInt8(RCConversationType.ConversationType_DISCUSSION.rawValue)),NSNumber.init(value: UInt8(RCConversationType.ConversationType_GROUP.rawValue)),NSNumber.init(value: UInt8(RCConversationType.ConversationType_APPSERVICE.rawValue)),NSNumber.init(value: UInt8(RCConversationType.ConversationType_SYSTEM.rawValue))]))
    }
}
//手机号验证
func verifyPhoneStr(phone:String?) -> Bool
{
    guard let phoneStr = phone else {
        
        alertHud(title: "请输入手机号")
        return false
    }
    
    if phoneStr.count == 0 {
        alertHud(title: "请输入手机号")
        return false
    }
    if phoneStr.count != 11 {
        alertHud(title: "手机号不正确,请重新输入")
        return false
    }
    return true
}
//根据两点经纬度计算两点距离
func getDistance(lat1:Double,lng1:Double,lat2:Double,lng2:Double) -> Double {
    let EARTH_RADIUS:Double = 6378137.0
    
    let radLat1:Double = radian(d: lat1)
    let radLat2:Double = radian(d: lat2)
    
    let radLng1:Double = radian(d: lng1)
    let radLng2:Double = radian(d: lng2)
    
    let a:Double = radLat1 - radLat2
    let b:Double = radLng1 - radLng2
    
    var s:Double = 22 * asin(sqrt(pow(sin(a/2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b/2), 2)))
    s = s * EARTH_RADIUS
    return s
}
func radian(d:Double) -> Double {
    return d * Double.pi/180.0
}
//根据弧度计算角度
func angle(r:Double) -> Double {
    return r * 180/Double.pi
}

func caculateCellHeight(type:AppiontCellType,model:lonelySpeechDetaileModel) -> CGFloat//计算高度 type : detail就没有查看报名
{
    let str = model.requirement ?? ""
    let textHeight = str.zzy.caculateHeight(font: kFont_system15, width: ScreenWidth - 40, lineSpace: 8.0)
    var oringinTopX:CGFloat = textHeight + 135 + 18
    if type == .detail {
        oringinTopX -= 45
    }
    let inageAry:[String] = model.attachment ?? []//图片资源
    if inageAry.count == 0 {
        
    }else
    {
        let intege = getLines(ary: inageAry, veryCount: 4)
        
        oringinTopX = oringinTopX + CGFloat(intege) * (BodyImageHeight + 10)
    }
//    let commentAry:[[String:Any]] = [["title":"手机号发","comment":"阿斯蒂芬还记得示范户为福建省的合法理发师点击返回撒地方"],["title":"时间的话发酵","comment":"申达股份had"],["title":"可是对方","comment":"闪光点发的反馈"]]
    let commentAry:[commentsModel] = model.comments ?? []
    
    
    for commentModel in commentAry
    {
        oringinTopX = oringinTopX + CommentGetHeight.getHeightCell(title: commentModel.publisher_name ?? "", commentStr: commentModel.content ?? "") + 5
    }
    return oringinTopX
    
    
}
func getLines(ary:[Any]?,veryCount:Int) -> Int
{
    guard let dataAry = ary else {
        return 0
    }
    
    var intege = Int(dataAry.count / veryCount)
    let yushu:CGFloat = CGFloat(dataAry.count).truncatingRemainder(dividingBy: CGFloat(veryCount))
    if Int(yushu) > 0 {
        intege += 1
    }
    return intege
}
func getPikerModels(data:[Any]?) ->[PikerModel]?
{
    if let dataStrAry = data as? [String] {
        var ary:[[String:Any]] = []
        if dataStrAry.count == 0 {
            return nil
        }
        for ident in dataStrAry {
            let dic = ["citysName":ident]
            ary.append(dic)
        }
        return JSONDeserializer<PikerModel>.deserializeModelArrayFrom(array: ary) as? [PikerModel]
    }
    return nil
}
//更新用户信息
func updateUserInfo()
{
    TargetManager.share.getDetailUserInfo(userid: CurrentUserInfo?.data?.user_id ?? "", isUpdateUser: true) { (model, error) in
        
    }
}

func getImageName() -> String
{
    let time = getTimeStamp(date: Date())
    return String.init(format: "%@%d.png", CurrentUserInfo?.data?.phone ?? "",time)
    
}


