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
    var appointment_id: String?
    var content:String?//评论内容
    var create_at:Int?//评论时间
    var avatar:String?//评论头像
    var publisher_name:String?
}
struct sign_up:JSON {
    var nickname:String?
    var has_pay_deposit:Bool?
    var user_id:String?
    var create_at:Int?
    var content:String?
    var avatar:String?
    var attachment:[String]?
    
}


class lonelySpeechDetaileModel:JSON {
    var add_time: Int64 = 0
    var time:Int64 = 0
    var user_id: String?
    var sex: Int = 0
    var user_name: String?
    var sign_up_count:Int?//报名人数
    var sign_up:[sign_up]?
    var requirement:String?//发布的内容
    var is_like:Bool?//是否点赞
//    var create_at:Int?//创建时间
//    var id:String?//发布约会者的id
//    var poster:posterModel?
    var has_authentication: Bool = false 
    var attachment:[String] = []//发布图片地址
    var is_overdue:Bool?//是否结束
    var comments:[commentsModel]?//评论信息
    var likes_count:Int?//点赞人数
    var distance:Int?//距离
    var city:String?//城市
    var need_signup: Bool = false //1 报名约会
    var deposit:Int?
    var id: String?
    var is_check: Bool = false
    var like: [lonelySpeechDetaileModelLike] = []
    var avatar: String?
    
    class lonelySpeechDetaileModelLike: JSON {
//        "appointment_id" = 5;
        var appointment_id: String?
//        avatar = "\U5730\U65b9\U73a9\U513f\U745e\U7279\U8ba9\U4ed6";
        var avatar: String?
//        id = 7;
        var id: String?
//        "user_id" = 65;
        var user_id: String?
//        "user_name" = "";
        var user_name: String?
        
        public required init() {}
    }
    
    required init() {
        
    }
}

struct lonelySpeechModel:JSON {
    var data:[lonelySpeechDetaileModel]?
    var msg:String?
    
}



