
//
//  UserModel.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/6.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
class PhotoModel:JSON
{
    var view_users:[String]?
    var url:String?
    var price:Int?
    var type:Int?
    var can_view_duration:Int?
    
    required init() {
        
    }
}
class UserInfo:JSON {
    var custom_photos:[PhotoModel]?
    var permission:String?
    var bust:Int?//胸围
    var age:Int?//年龄
    var lon:Double?//经度
    var lat:Double?//纬度
    var user_id:String?
    var contact_wechat:String?//微信号
    var self_introduction:String?//自我介绍
    var password:String?//密码
    var contact_qq:String?//QQ号
//    var photos:[String]?//相册
    var dress_style:[String]?//打扮方式
    var nickname:String?//昵称
    var stature:Int?//身高
    var phone:String?//电话号码
    var has_authentication:Bool?//是否认证
    var avatar:String?//头像地址
    var appointment_program:[String]?//约会项目
    var appointment_condition:[String]?//约会条件
    var language:[String]?//语言
    var identity:String?//身份
    var tags:[String]?//标签
    var emotion_status:String?//情感状态
    var city:String?
    var weight:Int?
    var sex:Int?// 0 男 1女
    var appointment_place:[String]?//约会范围
    var vip_expire_time:Int?
    var vip_level:Int?
    var balance:Int?//用户余额
    var likes:[String]?
    var distance:String?
    var frozen_balance:Int?//用户必须剩的钱
    required init() {
        
    }
}

class UserModel:JSON {
    var code: Int?
    var data: UserInfo?
    var msg: String?
    required init() {
        
    }
}
//信息填写修改等需要的字段
class UserFillModel:JSON
{
    var bust:Int?//胸围
    var age:Int?//年龄
    var contact_wechat:String?//微信号
    var self_introduction:String?//自我介绍
    var contact_qq:String?//QQ号
    var dress_style:[String]?//打扮方式
    var nickname:String?//昵称
    var stature:Int?//身高
    var avatar:String?//头像地址
    var appointment_program:[String]?//约会项目
    var appointment_condition:[String]?//约会条件
    var language:[String]?//语言
    var identity:String?//身份
    var tags:[String]?//标签
    var emotion_status:String?//情感状态
    var weight:Int?
    var sex:Int?// 0 男 1女
    var appointment_place:[String]?//约会范围
    required init() {
        
    }
}
