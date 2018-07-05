//
//  TargetManager.swift
//  LeShanBankSwift
//
//  Created by zzy on 2018/4/25.
//  Copyright © 2018年 zzy. All rights reserved.
//

import Foundation

class TargetManager: NSObject {

    static var share = TargetManager()
    private override init() {
        
    }
    
    
    //获取用户信息
    func getDetailUserInfo(userid:String,isUpdateUser:Bool, complection:@escaping (UserModel?,Error?) -> Void)  {
        
            NetCostom.shared.request(method:.get ,wengen: "gardens/\(userid)", params: nil, success: { (result) in
                if isUpdateUser
                {
                    guard let user = result as? [String:Any] else {
                        return
                    }
                    NSDictionary.init(dictionary: user).write(toFile: UserPlist, atomically: true)
                }
                
                
                let model = BaseModel<UserModel,UserModel>.init(resultData: result)
                complection(model.resultData,nil)
            }) { (error) in
                complection(nil,error)
                
            }
    }
    //获取用户config信息
    func getConditions(complection:@escaping (ConditionModel?,Error?) -> Void)  {
        NetCostom.shared.request(method:.get ,wengen: "config", params: nil, success: { (result) in
             let model = BaseModel<ConditionModel,ConditionModel>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //完善用户信息
    func fillUserInfo(params:[String:Any],complection:@escaping ([String:Any]?,Error?) -> Void)
    {
        let userId = CurrentUserInfo?.data?.user_id ?? ""
        NetCostom.shared.request(method:.put ,wengen: "users/\(userId)", params: params, success: { (result) in
            complection(result as? [String:Any],nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //登录
    func loginAction(params:[String:Any],complection:@escaping (UserModel?,Error?) -> Void)  {
        NetCostom.shared.request(method:.post ,wengen: "users/login", params: params, success: { (result) in
            guard let user = result as? [String:Any] else {
                return
            }
            NSDictionary.init(dictionary: user).write(toFile: UserPlist, atomically: true)
            
            let model = BaseModel<UserModel,UserModel>.init(resultData: user)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    func thirdLoginAction(params:[String:Any],complection:@escaping (UserModel?,Error?) -> Void)
    {
        NetCostom.shared.request(method:.post ,wengen: "users/thirdlogin", params: params, success: { (result) in
            guard let user = result as? [String:Any] else {
                return
            }
            NSDictionary.init(dictionary: user).write(toFile: UserPlist, atomically: true)
            
            let model = BaseModel<UserModel,UserModel>.init(resultData: user)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    
    //注册
    func registerUser(params:[String:Any]?,complection:@escaping ([String:Any]?,Error?) -> Void)
    {
        NetCostom.shared.request(method:.post ,wengen: "users/register", params: params, success: { (result) in
            complection(result as? [String:Any],nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //获取主页面列表
    func geiMainUserList(params:[String:Any],complection:@escaping ([MainListmodel]?,Error?) -> Void) {
        NetCostom.shared.request(method:.get ,wengen: "gardens", params: params, success: { (result) in
            if let jsonStr = result as? [String:Any]
            {
            let model = BaseModel<MainListmodel,[MainListmodel]>.init(resultData: jsonStr["data"] ?? "")
                complection(model.resultData,nil)
            }
            else
            {
              alertHud(title: "数据返回错误")
            }
            
            }) { (error) in
           complection(nil, error)
        }
    }
    //获取寂寞告白列表
    func getLonelySpeechList(params:[String:Any],complection:@escaping ([lonelySpeechDetaileModel]?,Error?) -> Void) {
        NetCostom.shared.request(method: .get, wengen: "appointment", params: params, success: { (result) in
            if let jsonStr = result as? [String:Any]
            {
                
                let model = BaseModel<lonelySpeechModel,lonelySpeechModel>.init(resultData: jsonStr)
                complection(model.resultData?.data,nil)
            }
            else
            {
                alertHud(title: "数据返回错误")
            }
        }) { (error) in
            complection(nil,error)
        }
    }
    //发布约会
    func issueAppiont(params:[String:Any],complection:@escaping (Bool,Error?) -> Void){
        NetCostom.shared.request(method:.post ,wengen: "appointment/", params: params, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //获取约会详情   仅限用户自己能调用
    func getAppiontDetail(params:[String:Any],complection:@escaping (lonelySpeechDetaileModel?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .get, wengen: "appointment", params: params, success: { (result) in
            if let jsonStr = result as? [String:Any]
            {
                let model = BaseModel<lonelySpeechDetaileModel,lonelySpeechDetaileModel>.init(resultData: jsonStr["data"] ?? "")
                complection(model.resultData,nil)
            }
            else
            {
                alertHud(title: "数据返回错误")
            }
        }) { (error) in
            complection(nil,error)
        }
    }
    //发布评论
    func issueComment(appointment_id:String, params:[String:Any],complection:@escaping (commentsModel?,Error?) -> Void) {
        NetCostom.shared.request(method:.post ,wengen: "appointment/\(appointment_id)/comments", params: params, success: { (result) in
            if let jsonStr = result as? [String:Any]
            {
                
                let model = BaseModel<commentsModel,commentsModel>.init(resultData: jsonStr["data"] ?? "")
                complection(model.resultData,nil)
            }
            else
            {
                alertHud(title: "数据返回错误")
            }
        }) { (error) in
            complection(nil,error)
        }
    }
    //点赞
    func likeAppiont(appointment_id:String?,complection:@escaping (Bool,Error?) -> Void) {
        let params = ["user_id":CurrentUserInfo?.data?.user_id ?? ""] as [String:Any]
        NetCostom.shared.request(method:.post ,wengen: "appointment/\(appointment_id ?? "")/likes", params: params, success: { (result) in
             complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //取消点赞/
    func cancelLikeAppiont(appointment_id:String?,complection:@escaping (Bool,Error?) -> Void) {
        
        NetCostom.shared.request(method:.delete ,wengen: "appointment/\(appointment_id ?? "")/likes/\(CurrentUserInfo?.data?.user_id ?? "")", params: nil, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //报名 params [user_id,attachment:string//多张图片 用,隔开   content  has_pay_deposit:是否支付定金]
    func signUpAppiont(appointment_id:String?,params:[String:Any]?,complection:@escaping (Bool,Error?) -> Void){
        NetCostom.shared.request(method:.delete ,wengen: "appointment/\(appointment_id ?? "")/signup", params: params, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //获取短信验证码
    func getMSCode(params:[String:Any],complection:@escaping ([String:Any]?,Error?) -> Void)
    {
        NetCostom.shared.request(method:.post ,wengen: "verify_code", params: params, success: { (result) in
            complection(result as? [String:Any],nil)
        }) { (error) in
           complection(nil,error)
        }
    }
    
   //跟新位置
    func uploadMyLocation(params:[String:Any],complection:@escaping (Bool,Error?) -> Void)
    {
        let userid = CurrentUserInfo?.data?.user_id ?? ""
        NetCostom.shared.request(method: .put, wengen: "users/\(userid)/position", params: params, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    func getCitysModel(complection:@escaping ([PikerModel]?,Error?) -> Void) {
        NetCostom.shared.request(method: .get, wengen: "config/city", params: nil, success: { (result) in
            if let jsonStr = result as? [String:Any]
            {
                let ary:[Any] = jsonStr["data"] as! [Any]
                NSArray.init(array: ary).write(toFile: LocalCitys, atomically: true)
                let model = BaseModel<PikerModel,[PikerModel]>.init(resultData: jsonStr["data"] ?? "")
                complection(model.resultData,nil)
            }
            else
            {
                alertHud(title: "数据返回错误")
            }
        }) { (error) in
            complection(nil,error)
        }
    }
    //转账
    func transfer(params:[String:Any]?,complection:@escaping (Bool,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "transfer", params: params, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //钱包充值
    func wallatRecharge(params:[String:Any]?,complection:@escaping (Bool,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "recharge", params: params, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    func withdrawal(params:[String:Any]?,complection:@escaping (Bool,Error?) -> Void) {
        NetCostom.shared.request(method: .post, wengen: "withdrawal", params: params, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //vip套餐
    func getVipPackages(complection:@escaping ([VipPageModel]?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .get, wengen: "vip/packages", params: nil, success: { (result) in
            if let jsonStr = result as? [String:Any]
            {
                let model = BaseModel<VipPageModel,[VipPageModel]>.init(resultData: jsonStr["data"] ?? "")
                complection(model.resultData,nil)
            }
            else
            {
                alertHud(title: "数据返回错误")
            }
        }) { (error) in
            
        }
    }
    //购买套餐
    func vipBuy(params:[String:Any]?,complection:@escaping (Any?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "vip/buy", params: params, success: { (result) in
            complection(result,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //邀请码
    func inviteCode(params:[String:Any]?,complection:@escaping (Bool,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "inviteCode", params: params, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //验证邀请码
    func inviteCodeBind(params:[String:Any]?,complection:@escaping (Bool,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "inviteCode/bind", params: params, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //请求融云token
    func rongcloudToken(isRefresh:Bool, complection:@escaping (RCTokenModel?) -> Void) {
        let param = ["user_id":CurrentUserInfo?.data?.user_id ?? "","nickname":CurrentUserInfo?.data?.nickname ?? "","avatar":CurrentUserInfo?.data?.avatar ?? ""]
        var wengen = "rongcloud/token"
        if isRefresh
        {
            wengen = "rongcloud/token/refresh"
        }
        NetCostom.shared.request(method: .post, wengen: wengen, params: param, success: { (result) in
            if let jsonStr = result as? [String:Any]
            {
                let model = BaseModel<RCTokenModel,RCTokenModel>.init(resultData: jsonStr["data"] ?? "")
                complection(model.resultData)
            }
            else
            {
                complection(nil)
                alertHud(title: "数据返回错误")
            }
        }) { (error) in
            complection(nil)
        }
        
    }
    //点赞用户
    func gardensUserLikes(params:[String:Any],complection:@escaping (Bool) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "gardens/likes", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //请求首页单独某个列表
    func getMainListUserInfo(userId:String,complection:@escaping (MainListmodel?,Error?) -> Void)
    {
        NetCostom.shared.request(method:.get ,wengen: "gardens/\(userId)", params: nil, success: { (result) in
            guard let resultDic = result as? [String:Any] else
            {
                alertHud(title: "返回错误")
                return
            }
            guard let dic = resultDic["data"] as? [String:Any] else
            {
                alertHud(title: "返回错误")
                return
            }
            let model = BaseModel<MainListmodel,MainListmodel>.init(resultData: dic)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
            
        }
    }
    //添加照片  或者红包照片
    func addImageToServer(params:[String:Any],complection:@escaping (Bool) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "custom_photos", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    
    func readImageForUserid(params:[String:Any], complection:@escaping (ReadImageModel?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "custom_photos/view", params: params, success: { (result) in
            guard let resultDic = result as? [String:Any] else
            {
                alertHud(title: "返回错误")
                return
            }
            guard let dic = resultDic["data"] as? [String:Any] else
            {
                alertHud(title: "返回错误")
                return
            }
            let model = BaseModel<ReadImageModel,ReadImageModel>.init(resultData: dic)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    func requestUserAllBroadcast(userid:String,complection:@escaping ([lonelySpeechDetaileModel]?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .get, wengen: "users/\(userid)/appointments", params: nil, success: { (result) in
            if let jsonStr = result as? [String:Any]
            {

                let model = BaseModel<lonelySpeechModel,lonelySpeechModel>.init(resultData: jsonStr)
                complection(model.resultData?.data,nil)
            }
            else
            {
                alertHud(title: "数据返回错误")
            }
        }) { (error) in
            complection(nil,error)
        }
    }
    //删除某条约会
    func deleteUserBrocast(appointment_id:String,complection:@escaping (Bool) -> Void)
    {
        NetCostom.shared.request(method: .delete, wengen: "\(CurrentUserInfo?.data?.user_id ?? "")/appointments/\(appointment_id)", params: nil, success: { (resulet) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    func signUp(params:[String:Any],appointment_id:String,complection:@escaping (Bool) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "appointment/\(appointment_id)/signup", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    func getAllComments(user_id:String,complection:@escaping([commentsModel]?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .get, wengen: "gardens/comments?user_id=\(user_id)", params: nil, success: { (result) in
            if let jsonStr = result as? [String:Any]
            {
                let ary:[Any]? = jsonStr["data"] as? [Any]
                let model = BaseModel<commentsModel,[commentsModel]>.init(resultData: ary ?? "")
                complection(model.resultData,nil)
            }
            else
            {
                alertHud(title: "数据返回错误")
            }
            
        }) { (error) in
            complection(nil,error)
        }
    }
    //对用户进行评价
    func commentUser(params:[String:Any],complection:@escaping(Bool) ->Void)
    {
        NetCostom.shared.request(method: .post, wengen: "gardens/comments", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //修改密码
    func xiugaiPassword(params:[String:Any],complection:@escaping(Bool) ->Void)
    {
        NetCostom.shared.request(method: .post, wengen: "users/modifyPassword", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //绑定手机号
    func debangPhoneNumber(params:[String:Any],complection:@escaping(Bool) ->Void)
    {
        NetCostom.shared.request(method: .post, wengen: "users/\(CurrentUserInfo?.data?.user_id ?? "")/bindPhone", params: params, success: {(result) in
            updateUserInfo()
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //认证
    func certificationUser(params:[String:Any],complection:@escaping(Bool) ->Void)
    {
        NetCostom.shared.request(method: .post, wengen: "certification", params: params, success: {(result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    
    //举报 或者拉黑report_type:int 0拉黑 1举报
    func userReportRequest(params:[String:Any],complection:@escaping(Bool) ->Void)
    {
        NetCostom.shared.request(method: .post, wengen: "userReport", params: params, success: {(result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    // 获取拉黑列表
    func userReportList(params:[String:Any],complection:@escaping () ->Void)
    {
        NetCostom.shared.request(method: .post, wengen: "userReport", params: params, success: {(result) in
            
        }) { (error) in

        }
    }
    //获取我喜欢的列表
    func myLikesList(params:[String:Any]?,complection:@escaping ([MainListmodel]?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "likes", params: params, success: { (result) in
            if let jsonStr = result as? [String:Any]
            {
                let model = BaseModel<MainListmodel,[MainListmodel]>.init(resultData: jsonStr["data"] ?? "")
                complection(model.resultData,nil)
            }
        }) { (error) in
           complection(nil,error)
        }
    }
    
    
}

