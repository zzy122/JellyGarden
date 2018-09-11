//
//  NotyfyListModels.swift
//  JellyGarden
//
//  Created by kfzs on 2018/9/11.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

struct BroastModel:JSON//广播model
{
    var user_name:String?
    var city:String?
    var attachment:String?
    var time:Int = 0
}

struct SeeApplyModel:JSON {//申请查看model
    var apply_image:String?
     var is_agree:Bool = false//是否允许
    var time:Int = 0//时间
//    var view_userid:Int?
    var is_apply:Bool = false
    var user:UserModel?
}
struct EvaluateNoticeModel:JSON//评价
{
    var user_image:String?
    var sex:Int = 0;
}
struct RemindNoticeModel:JSON//收益
{
    var user_image:String?
    var user_name:String?
    var moeny:Int = 0
    var time:Int = 0
    var type:Int = 0//1约会定价 //2查看照片 3//购买Vip 4解锁相册 5 查看联系方式 6 私聊
}
struct GardenNoticeModel:JSON//果冻花园通知
{
    var id:Int = 0
    var content:String?
    var send_type:Int = 0
    var send_time:Int = 0;
    var send_obj:String?
    var channel:String?
    var url:String?
    var admin_user:String?
    var addtime:Int = 0
}


class NotyfyListModels: NSObject {

}
