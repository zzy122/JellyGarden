//
//  AliyunManager.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/21.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class AliyunManager: NSObject {
    static let share = AliyunManager()
    private override init() {
        
    }
    func uploadImagesToAliyun(imageModels:[AliyunUploadModel] ,complection:@escaping ([String]?,Int,Int,UploadImageState) -> Void) {
        HUD.flash(.labeledProgress(title: nil, subtitle: "上传中"))
        AliyunUpload.share().uploadImage(toAliyun: imageModels, isAsync: true) { (urls, succeeCount, failedCount, state) in
            DispatchQueue.main.async {
                HUD.hide(animated: false)
                if failedCount != 0 && succeeCount != 0 {
                    alertHud(title: "成功\(succeeCount)张,失败\(failedCount)张")
                }
                complection(urls,succeeCount,failedCount,state)
            }
            
        }
    }
    func uploadVedioToAliyun(vedioPath:String ,vedioName:String ,complection:@escaping (String?,UploadImageState) -> Void) {
        HUD.flash(.labeledProgress(title: nil, subtitle: "上传中"))
        AliyunUpload.share().upLoadVedio(toAliyun: vedioPath, name: vedioName) { (url, state) in
            DispatchQueue.main.async {
                HUD.hide(animated: false)
                complection(url,state)
            }
           
        }
    }
}
