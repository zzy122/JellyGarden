//
//  MainListmodel.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/14.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
class MainListmodel:JSON {
    var nickname:String?
    var appointment_place: [String] = []
    var stature: String? /// 身高
    var weight: String? /// 体重
    var avatar:String?
    var bust: String? /// 胸围
    var dress_style: [String] = []
    var language: [String] = []
    var emotion_status: String?
    var appointment_program: [String] = []
    var appointment_condition: [String] = []
    var contact_qq: String?
    var contact_wechat: String?
    var self_introduce: String?
    var tags: [String] = []
    var age:Int?
    var lat:Double?
    var city:String?
    var identity:String?
    var has_authentication:Bool?
    var user_id:String?
    var photo_count:Int?
    var lon:Double?
    var sex:Int?
    var is_like:Bool = false 
    var permission:String?
    var distance:String?
    
    required init() {
        
    }
}

