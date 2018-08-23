//
//  FillCondition.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/14.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
class FillCondition: NSObject {
     static let share = FillCondition()
    private override init() {
        
    }
    var conditionTag:[String] = []//个人介绍
    
    
    var identityListModel:[PikerModel]? = []
    var languageListModel:[PikerModel]? = []
    var appointmentConditionListModel:[PikerModel]? = []//条件
    var appointmentProgramListModel:[PikerModel]? = []//项目

    var dressStyleListModel:[PikerModel]? = []//风格
    var emotionStatusList:[PikerModel]? = []
    
    
    
    func createModel(list:[String]?,backModel:@escaping ([PikerModel]?) ->Void) {
        backModel(getPikerModels(data: list))
    }
    
    func getConditions() {
        TargetManager.share.getConditions { (model, error) in
            if let result = model
            {
                self.createModel(list: result.appointment_condition_list, backModel: { (model) in
                    self.appointmentConditionListModel = model
                })
                self.createModel(list: result.appointment_program_list, backModel: { (model) in
                    self.appointmentProgramListModel = model
                })
                self.createModel(list: result.language_list, backModel: { (model) in
                    self.languageListModel = model
                })
                self.createModel(list: result.identity_list, backModel: { (model) in
                    self.identityListModel = model
                })
                self.createModel(list: result.dress_style_list, backModel: { (model) in
                    self.dressStyleListModel = model
                })
                self.createModel(list: result.emotion_status_list, backModel: { (model) in
                    self.emotionStatusList = model
                })
                self.conditionTag = result.tag ?? []
            }
        }
    }
    
}
