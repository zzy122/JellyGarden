//
//  NotifyModel.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/23.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
struct NotifyDataModel:JSON {
    var _id:[String:Any]?
    var attachment:[Any]?
    var city:String?
    var comments:[Any]?
    var create_at:Int?
    var deposit:Int?
    var likes:[Any]?
    var need_signup:Int?
    var pay_user_ids:[Any]?
    var poster_id:String?
    var requirement:String?
    var sign_up:[Any]?
    var time:String?
    
}


struct NotifyModel: JSON {
    var type:Int?
    var data:NotifyDataModel?
}
