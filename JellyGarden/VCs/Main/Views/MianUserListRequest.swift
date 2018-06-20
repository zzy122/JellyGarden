//
//  MianUserListRequest.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/14.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

func request(page:Int,type:SearchType,page_size:Int,complection:@escaping ([MainListmodel]?,Error?) -> Void) {
    var params:[String:Any] = ["page":page,"query":"","page_size":page_size]
    switch type {
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
    
    TargetManager.share.geiMainUserList(params: params) { (modelList, error) in
        complection(modelList,error)
    }
}
