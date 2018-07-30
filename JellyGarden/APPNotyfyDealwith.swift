//
//  APPNotyfyDealwith.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/18.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
struct RadioModel:JSON {
    
}
struct RemindingModel:JSON {
    
}
struct OfficialModel:JSON {
    
}
struct ContactModel:JSON {
    
}
struct CheckModel:JSON {
    
}
struct EvaluateModel:JSON {
    
}
struct DepositModel:JSON {
    
}
let Radio_APP_BroadcastNotify = "Radio_APP_Broadcast"//电台广播通知
let Reminding_APP_IncomeNotify = "Reminding_APP_Income"//收益提醒通知
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
    func createNotifyFile()
    {

        if (!FileManager.default.fileExists(atPath: notifyPath))
        {
            if !FileManager.default.createFile(atPath: notifyPath, contents: nil, attributes: nil) {
                DebugLog(message: "创建用户文件失败")
            }
//            let dic:[String:Any] = [Radio_APP_BroadcastNotify:[[:]],Reminding_APP_IncomeNotify:[[:]],Official_APP_Notify:[[:]],Contact_APP_StyleNotify:[[:]],Check_APP_ApplyNotify:[[:]],Evaluate_APP_Notify:[[:]],Deposit_APP_Notify:[[:]]]
//            NSDictionary.init(dictionary: dic).write(toFile: notifyPath, atomically: true)
            
        }
    }
    private func addData(Key:String,objc:[String:Any]?)
    {
        guard let info = objc else {
            return
        }
        let dataDic = NSDictionary.init(contentsOfFile: notifyPath)
        guard var dataAry = dataDic?.object(forKey: Key) as? Array<Any>  else {
            alertHud(title: "元数据不对")
            return
        }
        dataAry.insert(info, at: 0)
        dataDic?.setValue(dataAry, forKey: Key)
        dataDic?.write(toFile: notifyPath, atomically: true)
    }
    func addNotifyInfo(info:[String:Any]?)
    {
        guard let infos = info else {
            return
        }
        let model = JSONDeserializer<NotifyModel>.deserializeFrom(dict: infos)
        switch model!.type {
        case 1://广播
            self.addData(Key: Radio_APP_BroadcastNotify, objc: infos["data"] as? [String : Any])
            break
        case 2://评论内容
     self.addData(Key: Evaluate_APP_Notify, objc: infos["data"] as? [String : Any])
            break
        case 3://申请查看资料
             self.addData(Key: Check_APP_ApplyNotify, objc: infos["data"] as? [String : Any])
            break
        case 4://申请查看联系方式
             self.addData(Key: Contact_APP_StyleNotify, objc:infos["data"] as? [String : Any])
            break
        default:
            
            break
        }
        
    }
    func getNotifyData(key:String) -> [[String:Any]]?
    {
        let dataDic = NSDictionary.init(contentsOfFile: notifyPath)
        
        guard let dataAry = dataDic?.object(forKey: key) as? [[String:Any]]  else {
            alertHud(title: "元数据不对")
            return nil
        }
        return dataAry
    }
//    func getNotifyData<T:JSON>(key:String) -> [T]?
//    {
//        let dataDic = NSDictionary.init(contentsOfFile: notifyPath)
//
//        guard let dataAry = dataDic?.object(forKey: key) as? Array<Any>  else {
//            alertHud(title: "元数据不对")
//            return nil
//        }
//        return JSONDeserializer<T>.deserializeModelArrayFrom(array: dataAry)  as? [T]
//
//    }
    func getAllNotifyDic() -> [String:Any]?
    {
        return NSDictionary.init(contentsOfFile: notifyPath) as? [String:Any]
    }
    
}
