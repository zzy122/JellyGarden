//
//  NetCostom.swift
//
//  Created by zzy on 2018/4/10.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD




var Defult_jsonError = "error"
var Defult_exceptionMessage = "message"
var Defult_errorReson = "errorReson"

var Defult_Invalid_user = "role.invalid_user"

final class NetCostom: NSObject {
    
    typealias BackRequestSuccess = (Any) -> Void
    typealias BackRequestError = (_ error:NSError) -> Void
    typealias BackRequestIsFinish = (Bool) -> Void
    var manager:NetworkReachabilityManager?
    
    //单列;
    static let shared = NetCostom()
    private override init() {
        
    }
    let headers: HTTPHeaders = [
//        "Content-Type":"application/json",
        "Content-Type":"application/x-www-form-urlencoded",
        "Accept": "application/json"
    ]
    
}
extension NetCostom {
    func downLoad(urlStr:String,toFile:String,progressPercent:@escaping (CGFloat) -> Void, finished:@escaping BackRequestIsFinish) -> () {//文件下载
        
        let destination:DownloadRequest.DownloadFileDestination = {_,_ in
            //下载文件路径URL
            let documentPath:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = documentPath.appendingPathComponent(String.init(format: "%@/%@", UserPath,toFile))
            return (filePath, [.removePreviousFile, .createIntermediateDirectories])
            
            
        }
        Alamofire.download(urlStr, to: destination).downloadProgress(queue: DispatchQueue.main) { (progress) in
            progressPercent(CGFloat(progress.completedUnitCount / progress.totalUnitCount))
            DispatchQueue.main.async {
                
            }
            
            }.responseData { (response) in
                if response.result.value != nil
                 {
                    DispatchQueue.main.async {
                        finished(true)
                    }
                    
                    //下载完成
                }
                else if response.result.error != nil
                {
                    DispatchQueue.main.async {
                        finished(false)
                    }
                }
        }
    }
    func request(method:HTTPMethod, wengen:String ,params:[String:Any]?, success: @escaping BackRequestSuccess, failture: @escaping BackRequestError) -> () {//
        
        var coding = URLEncoding.httpBody
        if method == .get {
            coding = URLEncoding.queryString
        }
        HUD.flash(.labeledProgress(title: nil, subtitle: "请稍后..."))
        let urlStr:String = self.getUrl(wengen: wengen)
        DebugLogLine(message: "URLPath:\(urlStr)\n post:->->->\n\(String(describing: params))")
        Alamofire.request(urlStr, method: method, parameters: params, encoding: coding, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                DispatchQueue.main.async {
                     HUD.hide(animated: false)
                    DebugLogLine(message: "\nRequestResultSuccess:<-<-<-\n\(String(describing: response.result.value))")
                    self.dealWithRequestResult(value: value as! [String:Any], success: success, error: failture)
                }

                break

            case .failure(let error):
                DispatchQueue.main.async {
                     HUD.hide(animated: false)
                    DebugLogLine(message: "\nRequestResultError:<-<-<-\n\(error.localizedDescription)")
                    let errorMessage = NSError.init(domain: "NSApplicationErrorDomain", code: 1, userInfo: [Defult_errorReson:error.localizedDescription])
                    self.showErrorMessg(error: errorMessage, backError: failture)
                }

                break

            }
        }
    }
    
    func requestTest(method:HTTPMethod, wengen:String ,params:[String:Any]?, success: @escaping BackRequestSuccess, failture: @escaping BackRequestError) -> () {//get请求
        HUD.flash(.labeledProgress(title: nil, subtitle: "请稍后..."))
        let urlStr:String = self.getUrl(wengen: wengen)
        DebugLogLine(message: "URLPath:\(urlStr)\n post:->->->\n\(String(describing: params))")
        Alamofire.request(urlStr, method: method, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                DispatchQueue.main.async {
                    HUD.hide(animated: false)
                    DebugLogLine(message: "\nRequestResultSuccess:<-<-<-\n\(String(describing: response.result.value))")
                    self.dealWithRequestResult(value: value as! [String:Any], success: success, error: failture)
                }
                
                break
                
            case .failure(let error):
                DispatchQueue.main.async {
                    HUD.hide(animated: false)
                    DebugLogLine(message: "\nRequestResultError:<-<-<-\n\(error.localizedDescription)")
                    alertHud(title: "网络连接失败")
                    failture(error as NSError)

                }
                
                break
                
            }
        }
    }
    
}
extension NetCostom {
    func getUrl(wengen:String) -> (String) {//拼接url
        var str:String = SERVER_HOST
        str.append(wengen);
        return str
    }
    func dealWithRequestResult(value:Any,success:@escaping BackRequestSuccess,error:@escaping BackRequestError) -> Void {//处理服务器返回信息
        guard let resultDic = value as? [String:Any]else {
            alertHud(title: "返回值不是字典")
            return
        }
        guard let code = resultDic["code"] as? String   else {
            alertHud(title: "没有code字段")
            return
        }
        
        if code == "200"
        {
            guard let dataDic = resultDic["data"] else
            {
                alertHud(title: "没有data数据")
                success(resultDic)
                return
            }
            success(dataDic)
        }
       else
        {
            guard  let mesg:String = resultDic["msg"] as? String else
            {
                let errorMessage = NSError.init(domain: "NSApplicationErrorDomain", code: Int(code)!, userInfo: [Defult_errorReson:"没有msg错误信息"])
                 self.showErrorMessg(error: errorMessage, backError: error)
                return
            }
            let errorMessage = NSError.init(domain: "NSApplicationErrorDomain", code: Int(code)!, userInfo: [Defult_errorReson:mesg])
            self.showErrorMessg(error: errorMessage, backError: error)
        }
        
        /*
        guard let resultDic = value as? [String:Any],resultDic["data"] != nil else {//不是字典 就是返回错误
            let errorMessage = NSError.init(domain: "NSApplicationErrorDomain", code: 1, userInfo: [Defult_errorReson:"请求地址错误"])
           
                        
            return
        }
        if resultDic[Defult_jsonError] == nil && resultDic["errors"] == nil {
            success(value)
            if let message = resultDic[Defult_exceptionMessage] as? String
            {
                 alertHud(title: message)
            }
            return
        }

        if let errorStr = resultDic[Defult_jsonError] as? String {
            let errorMessage = NSError.init(domain: "NSApplicationErrorDomain", code: 1, userInfo: [Defult_errorReson:errorStr])
            self.showErrorMessg(error: errorMessage, backError: error)
            return
        }
        if let errorStr = resultDic["errors"] as? [String:Any] {
            let str:String = errorStr.description
            let errorMessage = NSError.init(domain: "NSApplicationErrorDomain", code: 1, userInfo: [Defult_errorReson:str])
            self.showErrorMessg(error: errorMessage, backError: error)
            return
        }
        */
    }
    func showErrorMessg(error:Any, backError:@escaping BackRequestError) {
        var message:String?
        if let err = error as? NSError
        {
            message = err.userInfo[Defult_errorReson] as? String
            backError(err)
        }
        else if let err = error as? Error
        {
            message = err.localizedDescription
            backError(NSError.init(domain: "NSApplicationErrorDomain", code: 1, userInfo: ["_exceptionMessage":message ?? ""]))
        }
        alertHud(title: message!)
        
        
//        AlertViewCoustom().showalertView(style: .alert, title: alertTitle, message: message, cancelBtnTitle: alertConfirm, touchIndex: { (index) in
//
//        }, otherButtonTitles: "")
       
        
    }
    func checkNetEnable() {
        self.manager = NetworkReachabilityManager.init(host: "http://www.baidu.com")
        manager?.listener = { status in
            switch status {
            case .notReachable:
                 DebugLog(message: "网络状态:无网络")
                break
            case .unknown:
                 DebugLog(message: "网络状态:无网络")
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
             DebugLog(message: "网络状态:蜂窝")
            break
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
             DebugLog(message: "网络状态:Wifi")
            break
            }
        }
            self.manager?.startListening()
    }
    
}



