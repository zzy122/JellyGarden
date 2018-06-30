//
//  MianUserListRequest.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/14.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

func request(page:Int,type:SearchType?,page_size:Int,sex:sexType?,locaCity:String?,complection:@escaping ([MainListmodel]?,Error?) -> Void) {
    
    var params:[String:Any] = ["page":page,"page_size":page_size,"user_id":CurrentUserInfo?.data?.user_id ?? ""]
    if let city = locaCity
    {
        params["city"] = city
    }
    
    
    if sex == .man {
        params["sex"] = 0
    }
    else if sex == .woman
    {
        params["sex"] = 1
    }
    if let tagType = type
    {
        switch tagType {
        case .hot:
            params["query"] = "hot"
            break
        case .attestation:
            params["query"] = "authorization"
            break
        case .new:
            params["query"] = "latest"
            break
        }
    }
    
    
    TargetManager.share.geiMainUserList(params: params) { (modelList, error) in
        complection(modelList,error)
    }
}
