//
//  ConditionModel.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/14.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
struct ConditionListModel:JSON {
    var appointment_condition_list:[String]?
    var identity_list:[String]?
    var language_list:[String]?
    var appointment_program_list:[String]?
    var dress_style_list:[String]?
    var emotion_status_list:[String]?
    var tag:[String]?
    
    
    
}


struct ConditionModel:JSON {
    var data:ConditionListModel?
    
}
