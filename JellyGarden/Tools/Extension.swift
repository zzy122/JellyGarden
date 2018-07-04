//
//  Extension.swift
//  JellyGarden
//
//  Created by weipinzhiyuan on 2018/7/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import Foundation

extension  {
    
    func cancel(title: String?, cancel: (() -> Void)?) -> UIAlertController {
        
        let action = UIAlertAction(title: title, style: UIAlertActionStyle.cancel) { (action) in
            cancel()
        }
        return self
    }
    
    func others(
}
