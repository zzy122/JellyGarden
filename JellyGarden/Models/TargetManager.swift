//
//  TargetManager.swift
//  LeShanBankSwift
//
//  Created by zzy on 2018/4/25.
//  Copyright © 2018年 zzy. All rights reserved.
//

import Foundation
import HandyJSON
class TargetManager: NSObject {

    static var share = TargetManager()
    private override init() {
        
    }
    
    
    //获取用户信息
    func getDetailUserInfo(userid:String,isUpdateUser:Bool, complection:@escaping (UserModel?,Error?) -> Void)  {//gardens/\(userid)?my_user_id=\(CurrentUserInfo?.user_id ?? "")
        let param = ["view_userid":userid,"user_id":CurrentUserInfo?.user_id ?? ""]
        NetCostom.shared.request(method:.post ,wengen: "admin/user/get_user_message", params: param, success: { (result) in
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
    func getConditions(complection:@escaping (ConditionModel?,Error?) -> Void)  {//config
        NetCostom.shared.request(method:.post ,wengen: "admin/user/get_config", params: nil, success: { (result) in
             let model = BaseModel<ConditionModel,ConditionModel>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //完善用户信息
    func fillUserInfo(params:[String:Any],complection:@escaping ([String:Any]?,Error?) -> Void)
    {//users/\(userId)
        NetCostom.shared.request(method: .post, wengen: "admin/user/api_user_message", params: params, success: { (result) in
            complection(result as? [String:Any],nil)
        }) { (error) in
             complection(nil,error)
        }
    }
    //登录
    func loginAction(params:[String:Any],complection:@escaping (UserModel?,Error?) -> Void)  {//users/login
        NetCostom.shared.request(method:.post ,wengen: "admin/user/login", params: params, success: { (result) in
            guard let user = result as? [String:Any] else {
                return
            }
            let model = BaseModel<UserModel,UserModel>.init(resultData: user)
            let user1 = model.resultData?.toJSON()!
            NSDictionary.init(dictionary: user1!).write(toFile: UserPlist, atomically: true)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    func thirdLoginAction(params:[String:Any],complection:@escaping (UserModel?,Error?) -> Void)
    {
        NetCostom.shared.request(method:.post ,wengen: "admin/user/third_login", params: params, success: { (result) in
            guard let user = result as? [String:Any] else {
                return
            }
            let model = BaseModel<UserModel,UserModel>.init(resultData: user)
            let user1 = model.resultData?.toJSON()!
            NSDictionary.init(dictionary: user1!).write(toFile: UserPlist, atomically: true)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    
    //注册
    func registerUser(params:[String:Any]?,complection:@escaping ([String:Any]?,Error?) -> Void)//users/register
    {
        NetCostom.shared.request(method:.post ,wengen: "admin/user/register", params: params, success: { (result) in
            complection(result as? [String:Any],nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    
    //获取主页面列表
    func geiMainUserList(params:[String:Any],complection:@escaping ([MainListmodel],Error?) -> Void) {
        NetCostom.shared.request(method:.post ,wengen: "admin/user/user_list", params: params, success: { (result) in
            let model = BaseModel<MainListmodel,[MainListmodel]>.init(resultData: result)
            complection(model.resultData ?? [],nil)
            }) { (error) in
           complection([], error)
        }
    }
    
    //获取寂寞告白列表
    func getLonelySpeechList(params:[String:Any],complection:@escaping ([lonelySpeechDetaileModel],Error?) -> Void) {
        NetCostom.shared.request(method: .post, wengen: "admin/video/appointment_list", params: params, success: { (result) in
            if let jsonStr = result as? [String:Any], let datas = jsonStr["appointment"] as? [[String: Any]] {
                
                let models = [lonelySpeechDetaileModel].deserialize(from: datas) ?? []
                
                complection(models as! [lonelySpeechDetaileModel], nil)
            }
            else {
                 complection([], nil)
            }
        }) { (error) in
            complection([],error)
        }
    }
    
    //发布约会
    func issueAppiont(params:[String:Any],complection:@escaping (Bool,Error?) -> Void){
        NetCostom.shared.request(method:.post ,wengen: "admin/video/appointment_add", params: params, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //获取寂寞列表详情
    
    //获取约会详情   仅限用户自己能调用
    func getAppiontDetail(appointment_id:String,complection:@escaping (lonelySpeechDetaileModel?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "admin/video/appointment_detail", params: ["appointment_id": appointment_id], success: { (result) in
            if let jsonStr = result as? [String:Any] {
                let model = BaseModel<lonelySpeechDetaileModel,lonelySpeechDetaileModel>.init(resultData: jsonStr["data"] ?? "")
                complection(model.resultData,nil)
            }
            else {
                alertHud(title: "数据返回错误")
            }
        }) { (error) in
            complection(nil,error)
        }
    }
    
    //发布评论
    func issueComment(appointment_id:String, params:[String:Any],complection:@escaping (commentsModel?,Error?) -> Void) {
        NetCostom.shared.request(method:.post ,wengen: "admin/video/appointment_comments", params: params, success: { (result) in
            let model = BaseModel<commentsModel,commentsModel>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //点赞
    func likeAppiont(appointment_id:String,complection:@escaping (Bool,Error?) -> Void) {
        let params = ["user_id":CurrentUserInfo?.user_id ?? "", "appointment_id": appointment_id] as [String:Any]
        NetCostom.shared.request(method:.post ,wengen: "admin/video/appointment_likes", params: params, success: { (result) in
             complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //报名 params [user_id,attachment:string//多张图片 用,隔开   content  has_pay_deposit:是否支付定金]
    func signUpAppiont(appointment_id:String?,params:[String:Any]?,complection:@escaping (Bool,Error?) -> Void){
        NetCostom.shared.request(method:.post ,wengen: "admin/video/signup_appointment", params: params, success: { (result) in
//            alertHud(title: dic["msg"] as! String)
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    
    //获取短信验证码
    func getMSCode(params:[String:Any],complection:@escaping ([String:Any]?,Error?) -> Void) {
        NetCostom.shared.request(method:.post ,wengen: "admin/user/send_code", params: params, success: { (result) in
            complection(result as? [String:Any],nil)
        }) { (error) in
           complection(nil,error)
        }
    }
    
   //跟新位置
    func uploadMyLocation(params: [String:Any], complection: ((Bool,Error?) -> Void)?) {
        NetCostom.shared.request(method: .post, wengen: "admin/user/update_position", params: params, success: { (result) in
            complection?(true,nil)
        }) { (error) in
            complection?(false,error)
        }
    }
    
    //获取位置信息
    func getCitysModel(complection:@escaping ([PikerModel]?,Error?) -> Void) {//config/city
        NetCostom.shared.request(method: .post, wengen: "admin/user/get_city", params: nil, success: { (result) in
             let ary:[Any] = result as! [Any]
            NSArray.init(array: ary).write(toFile: LocalCitys, atomically: true)
            let model = BaseModel<PikerModel,[PikerModel]>.init(resultData: ary)
            complection(model.resultData,nil)
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
    //提现
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
        NetCostom.shared.request(method: .post, wengen: "admin/user/get_vip_package", params: nil, success: { (result) in
            let model = BaseModel<VipPageModel,[VipPageModel]>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            
        }
    }
    //购买套餐
    func vipBuy(params:[String:Any]?,complection:@escaping (Any?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "admin/order/vip_order", params: params, success: { (result) in
            complection(result,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //邀请码
    func inviteCode(params:[String:Any]?,complection:@escaping (Bool,Error?) -> Void)//inviteCode
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/get_invite_code", params: params, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //验证邀请码
    func inviteCodeBind(params:[String:Any]?,complection:@escaping (Bool,Error?) -> Void)//inviteCode/bind
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/code_vilidata", params: params, success: { (result) in
            complection(true,nil)
        }) { (error) in
            complection(false,error)
        }
    }
    //请求融云token
    func rongcloudToken(isRefresh:Bool, complection:@escaping (RCTokenModel?) -> Void) {//rongcloud/token
        DebugLog(message: "内存中的: \(CurrentUserInfo?.user_id ?? "")")
        let param = ["user_id":CurrentUserInfo?.user_id ?? "","nickname":CurrentUserInfo?.nickname ?? "","avatar":CurrentUserInfo?.avatar ?? ""]
        var wengen = "admin/video/get_rongcloud_token"
        if isRefresh
        {
            wengen = "admin/video/refresh_rongcloud_token    "
        }
        NetCostom.shared.request(method: .post, wengen: wengen, params: param, success: { (result) in
            
            let model = BaseModel<RCTokenModel,RCTokenModel>.init(resultData: result)
            complection(model.resultData)
        }) { (error) in
            complection(nil)
        }
        
    }
    //点赞用户
    func gardensUserLikes(params:[String:Any],complection:@escaping (Bool) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/user_like", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //请求首页单独某个列表
    func getMainListUserInfo(userId:String,complection:@escaping (MainListmodel?,Error?) -> Void)
    {
        NetCostom.shared.request(method:.post ,wengen: "gardens/\(userId)", params: nil, success: { (result) in
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
    //添加照片  或者红包照片 阅后即焚
    func addImageToServer(params:[String:Any],complection:@escaping (Bool) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "custom_photos", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //查看照片，阅后即焚
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
    //获取用户所有广播
    func requestUserAllBroadcast(userid:String,complection:@escaping (lonelySpeechModel?,Error?) -> Void)
    {
        let param:[String:String] = ["user_id":userid];
        NetCostom.shared.request(method: .post, wengen: "admin/video/get_allappointment_byuserid", params: param, success: { (result) in
            let model = BaseModel<lonelySpeechModel,lonelySpeechModel>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //删除某条约会
    func deleteUserBrocast(appointment_id:String,complection:@escaping (Bool) -> Void)
    {
        NetCostom.shared.request(method: .delete, wengen: "users/\(CurrentUserInfo?.user_id ?? "")/appointments/\(appointment_id)", params: nil, success: { (resulet) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }

    func getAllComments(user_id:String,complection:@escaping([commentsModel]?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "gardens/comments?user_id=\(user_id)", params: nil, success: { (result) in
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
        NetCostom.shared.request(method: .post, wengen: "admin/user/user_assess", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //修改密码
    func xiugaiPassword(params:[String:Any],complection:@escaping(Bool) ->Void)
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/modifyPassword", params: params, success: { (result) in
            let model = CurrentUserInfo
            model?.password = params["new_password"] as? String
            NSDictionary.init(dictionary: (model?.toJSON())!).write(toFile: UserPlist, atomically: true)
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //绑定手机号
    func debangPhoneNumber(params:[String:Any],complection:@escaping(Bool) ->Void)
    {
        NetCostom.shared.request(method: .post, wengen: "users/\(CurrentUserInfo?.user_id ?? "")/bindPhone", params: params, success: {(result) in
            let model = CurrentUserInfo
            model?.phone = params["phone"] as? String
            NSDictionary.init(dictionary: (model?.toJSON())!).write(toFile: UserPlist, atomically: true)
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //视频认证
    func certificationVideoUser(params:[String:Any],complection:@escaping(Bool) ->Void)//certification
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/video_rz", params: params, success: {(result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //自拍认证
    func certificationImageUser(params:[String:Any],complection:@escaping(Bool) ->Void)//certification
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/image_rz", params: params, success: {(result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //拉黑
    func userReportRequest(params:[String:Any],complection:@escaping(Bool) ->Void)
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/report", params: params, success: {(result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //取消拉黑
    func cancelUserReportRequest(report_user_id:String,complection:@escaping (Bool) ->Void)
    {
        let param:[String:Any] = ["user_id":CurrentUserInfo?.user_id ?? "","report_user_id":report_user_id]
        NetCostom.shared.request(method: .post, wengen: "admin/user/remove_black", params: param, success: {(result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    // 获取拉黑列表
    func userReportList(params:[String:Any],complection:@escaping ([BlackModel]?,Error?) ->Void)//userReport
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/get_report_list", params: params, success: {(result) in
            let model = BaseModel<BlackModel,[BlackModel]>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //获取我喜欢的列表
    func myLikesList(params:[String:Any]?,complection:@escaping ([MainListmodel]?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/like_user_list", params: params, success: { (result) in
           
            let model = BaseModel<MainListmodel,[MainListmodel]>.init(resultData: result)
            complection(model.resultData,nil)
        
        }) { (error) in
           complection(nil,error)
        }
    }
    //更新权限
    func updatePermission(params:[String:Any] ,complection:@escaping(Bool) ->Void)//users/\(CurrentUserInfo?.user_id ?? "")/permission
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/edit_permission", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //检查认证状态
    func checkIdentyResult(complection:@escaping (IdentityModel?,Error?) -> Void )
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/user_certificate_back", params: ["user_id":CurrentUserInfo?.user_id ?? ""], success: { (result) in
            let model = BaseModel<IdentityModel,IdentityModel>.init(resultData: result)
            
          complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //个人中心上传图片
    func addUserPhotos(params:[String:Any],complection:@escaping(Bool) -> Void)//custom_photos
    {
        NetCostom.shared.request(method: .post, wengen: "admin/video/user_photos_add", params: params, success: { (result) in
            self.addUserPhotos(params: params)
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //个人中心删除图片@WeakObj();
    func deletePhoto(imageUrl:String,complection:@escaping(Bool) -> Void)//custom_photos?user_id=\(CurrentUserInfo?.user_id ?? "")&url=\(imageUrl)
    {
        let param:[String:Any] = ["user_id":CurrentUserInfo?.user_id ?? "","url_list":imageUrl]
        NetCostom.shared.request(method: .post, wengen: "admin/video/user_photo_delete", params: param, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    private func addUserPhotos(params:[String:Any])
    {
        //本地添加图片
        let model = JSONDeserializer<PhotoModel>.deserializeFrom(dict: params)
        let user = CurrentUserInfo
        user?.custom_photos?.append(model!)
        NSDictionary.init(dictionary: (user?.toJSON())!).write(toFile: UserPlist, atomically: true)
    }
    //更新个人中心图片状态
    func updateUserPhotos(params:[String:Any],complection:@escaping(Bool) -> Void)//custom_photos
    {
        NetCostom.shared.request(method: .post, wengen: "admin/video/user_photos_add", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //查看支付宝账号
    func getAlipayAccount(params:[String:Any],complection:@escaping([AlipayModel]?,Error?) -> Void)//alipay
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/get_alipay_num", params: params, success: { (result) in
            let model = BaseModel<AlipayModel,[AlipayModel]>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
            
        }
    }
    //添加支付宝账号
    func addAlipayAccount(params:[String:Any],complection:@escaping(Bool) -> Void)//
    {
        NetCostom.shared.request(method: .post, wengen: "admin/user/add_alipay", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //删除支付宝账号
    func deleteAlipayAccount(alipay_account_id:String,complection:@escaping(Bool) -> Void)
    {
        NetCostom.shared.request(method: .delete, wengen: "alipay/\(alipay_account_id)", params: nil, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //申请查看资料
    func applayToDetail(params:[String:Any],complection:@escaping(Bool) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "users/applyPermission", params: params, success: { (result) in
            guard let dic = result as? [String:Any] else{
                return
            }
            alertHud(title: dic["msg"] as! String)
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //查看联系方式
    func checkContackType(params:[String:Any],complection:@escaping(Bool) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "users/applyContact", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //获取多少人看过和图片被焚毁多少次
    func getCountWithView(complection:@escaping (ViewCountModel?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "admin/video/view_num_user", params: ["user_id":CurrentUserInfo?.user_id ?? ""], success: { (result) in
            let model:BaseModel = BaseModel<ViewCountModel,ViewCountModel>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //恢复已焚毁的照片
    func recoverMyPicture(complection:@escaping(Bool) -> Void)
    {
        let params = ["user_id":CurrentUserInfo?.user_id ?? ""]
        NetCostom.shared.request(method: .post, wengen: "admin/video/recover_distoryimg", params: params, success: { (result) in
            complection(true)
        }) { (error) in
            complection(false)
        }
    }
    //请求发的广播通知列表
    func requestBroastModels(complection:@escaping([BroastModel]?, Error?) -> Void)
    {
        let params = ["user_id":CurrentUserInfo?.user_id ?? ""]
        NetCostom.shared.request(method: .post, wengen: "admin/message/radio_broadcast", params: params, success: { (result) in
            let model = BaseModel<BroastModel,[BroastModel]>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //请求查看申请通知列表
    func requestSeeApply(complection:@escaping([SeeApplyModel]?, Error?) -> Void)
    {
        let params = ["user_id":CurrentUserInfo?.user_id ?? ""]
        NetCostom.shared.request(method: .post, wengen: "admin/message/see_apply", params: params, success: { (result) in
            let model = BaseModel<SeeApplyModel,[SeeApplyModel]>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //收益通知列表
    func requestRemindNotice(complection:@escaping([RemindNoticeModel]?, Error?) -> Void)
    {
        let params = ["user_id":CurrentUserInfo?.user_id ?? ""]
        NetCostom.shared.request(method: .post, wengen: "admin/message/profit_remind", params: params, success: { (result) in
            let model = BaseModel<RemindNoticeModel,[RemindNoticeModel]>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //评价通知列表
    func requestEvaluateNotice(complection:@escaping([EvaluateNoticeModel]?, Error?) -> Void)
    {
        let params = ["user_id":CurrentUserInfo?.user_id ?? ""]
        NetCostom.shared.request(method: .post, wengen: "admin/message/evaluate_notice", params: params, success: { (result) in
            let model = BaseModel<EvaluateNoticeModel,[EvaluateNoticeModel]>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    //果冻花园官方通知列表
    func requestJellyGardenNotice(complection:@escaping([GardenNoticeModel]?, Error?) -> Void)
    {
        let params = ["user_id":CurrentUserInfo?.user_id ?? ""]
        NetCostom.shared.request(method: .post, wengen: "admin/message/jelly_garden", params: params, success: { (result) in
            let model = BaseModel<GardenNoticeModel,[GardenNoticeModel]>.init(resultData: result)
            complection(model.resultData,nil)
        }) { (error) in
            complection(nil,error)
        }
    }
    
    //约会定金支付
    func requestDepositPay(param:[String:Any], complection:@escaping(Any?,Error?) -> Void)
    {
        NetCostom.shared.request(method: .post, wengen: "admin/order/deposit ", params: param, success: { (result) in
             complection(result,nil)
        }) { (error) in
            complection(nil,error)
        }
    }

    
    
}

