//
//  APPNotyfyDealwith.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/18.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
class RelativeNotifyAry:JSON {
    var Radio_APP_BroadcastNotify:[NotifyModel] = []//电台广播通知
    var Reminding_APP_IncomeNotify:[NotifyModel] = []//收益提醒通知
    var Official_APP_Notify:[NotifyModel] = []//果冻花园通知
    var Contact_APP_StyleNotify:[NotifyModel] = []//联系方式通知
    var Check_APP_ApplyNotify:[NotifyModel] = []//查看申请通知
    var Evaluate_APP_Notify:[NotifyModel] = []//评价通知
    var Deposit_APP_Notify:[NotifyModel] = []//定金通知
    required init() {
    }
}
let Radio_APP_BroadcastNotify = "Radio_APP_BroadcastNotify"//电台广播通知
let Reminding_APP_IncomeNotify = "Reminding_APP_IncomeNotify"//收益提醒通知
let Official_APP_Notify = "Official_APP_Notify"//果冻花园通知
let Contact_APP_StyleNotify = "Contact_APP_StyleNotify"//联系方式通知
let Check_APP_ApplyNotify = "Check_APP_ApplyNotify"//查看申请通知
let Evaluate_APP_Notify = "Evaluate_APP_Notify"//评价通知
let Deposit_APP_Notify = "Deposit_APP_Notify"//定金通知
class APPNotyfyDealwith: NSObject {
    static var share = APPNotyfyDealwith()
    private override init() {
        super.init()
        self.createNotifyFile()
    }
    let notifyPath = "\(UserPath)/notify.plist"
    private func createNotifyFile()
    {

        if (!FileManager.default.fileExists(atPath: notifyPath))
        {
            if !FileManager.default.createFile(atPath: notifyPath, contents: nil, attributes: nil) {
                DebugLog(message: "创建用户文件失败")
            }
            let dic:RelativeNotifyAry = RelativeNotifyAry()
            NSDictionary.init(dictionary: dic.toJSON()!).write(toFile: notifyPath, atomically: true)
            
        }
    }
    func addNotifyInfo(info:[String:Any]?)
    {
        guard let info1 = info else {
            return
        }
        guard let infos = info1["data"] as? [String:Any] else {
            return
        }
        let dataDic:[String:Any] = NSDictionary.init(contentsOfFile: notifyPath) as! [String : Any]
        let modelAry:RelativeNotifyAry = JSONDeserializer<RelativeNotifyAry>.deserializeFrom(dict: dataDic)!
        let model:NotifyModel = JSONDeserializer<NotifyModel>.deserializeFrom(dict: infos)!
        switch (model.type) {
        case 1://广播
            modelAry.Radio_APP_BroadcastNotify.append(model)
            break
        case 2://收益提醒
            modelAry.Reminding_APP_IncomeNotify.append(model)
            break
        case 3://果冻花园
             modelAry.Official_APP_Notify.append(model)
            break
        case 4://联系方式
             modelAry.Contact_APP_StyleNotify.append(model)
            break
        case 5://查看申请
            modelAry.Check_APP_ApplyNotify.append(model)
            break
        case 6://评价通知
            modelAry.Evaluate_APP_Notify.append(model)
            break
        case 7://定金通知
            modelAry.Deposit_APP_Notify.append(model)
            break
        default:
            
            break
        }
        NSDictionary.init(dictionary: modelAry.toJSON()!).write(toFile: notifyPath, atomically: true)
        
    }
    func setReadedNotify(notiStr:String) {//已读
        var dic:[String:Any] = NSDictionary.init(contentsOfFile: notifyPath) as! [String : Any]
        let aryModel:RelativeNotifyAry = JSONDeserializer<RelativeNotifyAry>.deserializeFrom(dict: dic)!
        guard let modelDicAry = dic[notiStr] as? Array<[String:Any]> else
        {
            alertHud(title: "读取数据错误")
            return
        }
        let models = JSONDeserializer<NotifyModel>.deserializeModelArrayFrom(array: modelDicAry)
        
        guard let tagModels:[NotifyModel] = models as? [NotifyModel],tagModels.count > 0 else {
            DebugLog(message: "没有通知数据")
            return
        }
        var model:NotifyModel = tagModels.last!
        model.readView = true
        switch notiStr {
        case Radio_APP_BroadcastNotify:
            aryModel.Radio_APP_BroadcastNotify = [model]
            break
        case Reminding_APP_IncomeNotify:
            aryModel.Reminding_APP_IncomeNotify = [model]
            break
        case Official_APP_Notify:
            aryModel.Official_APP_Notify = [model]
            break
        case Contact_APP_StyleNotify:
            aryModel.Contact_APP_StyleNotify = [model]
            break
        case Check_APP_ApplyNotify:
            aryModel.Check_APP_ApplyNotify = [model]
            break
        case Evaluate_APP_Notify:
            aryModel.Evaluate_APP_Notify = [model]
            break
        case Deposit_APP_Notify:
            aryModel.Deposit_APP_Notify = [model]
            break
        default:
            break
        }
        
        NSDictionary.init(dictionary: aryModel.toJSON()!).write(toFile: notifyPath, atomically: true)
    }
    
    func getAllNotifyDic() -> RelativeNotifyAry
    {
        let dic:[String:Any]? =  NSDictionary.init(contentsOfFile: notifyPath) as? [String:Any]
        return  JSONDeserializer<RelativeNotifyAry>.deserializeFrom(dict: dic)!
    }
    
}
