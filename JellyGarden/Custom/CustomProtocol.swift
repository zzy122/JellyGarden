//
//  CustomProtocol.swift
//
//  Created by zzy on 2018/5/15.
//  Copyright © 2018年 zzy. All rights reserved.
//

import Foundation
public protocol CustomNSError : Error {
    /// The domain of the error.
    static var errorDomain: String { get }
    /// The error code within the given domain.
    var errorCode: Int { get }
    /// The user-info dictionary.
    var errorUserInfo: [String : Any] { get }
}
protocol ResponderRouter {
    func interceptRoute(name:String,objc:UIResponder?,info:Any?)
}

