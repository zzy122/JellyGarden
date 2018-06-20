//
//  BaseModel.swift
//  LeShanBankSwift
//
//  Created by zzy on 2018/4/24.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
typealias JSON = HandyJSON
struct BaseError {
    var localizedDescription: String
    
    var code: Int
    
    var error: Error?
    
    init(code: Int, localizedDescription: String, error: Error?)
    {
        self.code = code
        self.localizedDescription = localizedDescription
        self.error = error
    }
}

struct BaseModel<T:JSON,Z> {//Z:最后要获取的类型  T:z里面包含的类型
    var resultData:Z?
    var error:Error?
    private func transformResultData(data:Any?) -> Z?{
        if let result = data as? [[String:Any]], Z.self == [T].self//判断是不是数组
        {
           return JSONDeserializer<T>.deserializeModelArrayFrom(array: result) as? Z
        }
        else if let result = data as? [String:Any], Z.self == T.self
        {
            return JSONDeserializer<T>.deserializeFrom(dict: result) as? Z
        }
        else if let result = data as? Z
        {
            return result
        }
        else if let result = data as? String ,Z.self == Bool.self
        {
            return ["true", "True", "TRUE", "Yes", "yes", "YES", "1"].contains(result) as? Z
        }
        else if let result = data as? Int64, Z.self == Bool.self
        {
            return (result > 0) as? Z
        }
        else if let result = data as? Int64, Z.self == String.self
        {
            return String.init(result) as? Z
        }
        else if let result = data as? Double, Z.self == String.self
        {
            return String(result) as? Z
        }
        else if let result = data as? String, Z.self == Double.self
        {
            return Double(result) as? Z
        }
        else if let result = data as? String, Z.self == Int64.self
        {
            return Int64(result) as? Z
        }
        
        return nil
    }
    init(resultData:Any) {
        self.resultData = self.transformResultData(data: resultData)
    }
    
    
    
}
