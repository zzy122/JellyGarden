//
//  LonelySpeechModel.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/19.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
struct posterModel:JSON {
    var avatar:String?//头像
    var user_id:String?
    
    var has_authentication:Bool?//是否认证
    var nickname:String?
    var sex:Int?
}
struct commentsModel:JSON {
    var publisher_id:String?//评论id
    var content:String?//评论内容
    var create_at:Int?//评论时间
    var publisher_avatar:String?//评论头像
    var publisher_name:String?
}


class lonelySpeechDetaileModel:JSON {
    var time:Int?
    var sign_up_count:Int?//报名人数
    var requirement:String?//发布的内容
    var is_like:Bool?//是否点赞
    var create_at:Int?//创建时间
    var appointment_id:String?//发布约会者的id
    var poster:posterModel?
    var attachment:[String]?//发布图片地址
    var is_overdue:Bool?//是否结束
    var comments:[commentsModel]?//评论信息
    var likes_count:Int?//点赞人数
    var distance:Int?//距离
    var city:String?//城市
    var need_signup:Bool?//yes 报名约会
    required init() {
        
    }
}
struct lonelySpeechModel:JSON {
    var data:[lonelySpeechDetaileModel]?
    var msg:String?
    
}



