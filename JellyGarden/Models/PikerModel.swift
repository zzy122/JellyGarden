//
//  PikerModel.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
class PikerModel: JSON {
    var citysName:String?
    var citys:[PikerModel]?
    required init() {
        
    }
    func mapping(mapper: HelpingMapper) {
        
        mapper.specify(property: &citysName, name: "provinceName")
        mapper.specify(property: &citysName, name: "citysName")
    }
}
