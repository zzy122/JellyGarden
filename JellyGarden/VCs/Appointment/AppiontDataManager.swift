//
//  AppiontDataManager.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/19.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
enum ModifyLikeType {
    case add;
    case subtract;//减
}
let CommentPath:String = {
    let path = "\(UserPath)/Appiont.plist"
    if (!FileManager.default.fileExists(atPath: path))
    {
        if !FileManager.default.createFile(atPath: path, contents: nil, attributes: nil) {
            DebugLog(message: "创建用户文件失败")
        }
    }
    return path
}()
let UserCommentListPath:String = {//用户的广播
    let path = "\(UserPath)/userAppiont.plist"
    if (!FileManager.default.fileExists(atPath: path))
    {
        if !FileManager.default.createFile(atPath: path, contents: nil, attributes: nil) {
            DebugLog(message: "创建用户文件失败")
        }
    }
    return path
}()
class AppiontDataManager: NSObject {
    static let share = AppiontDataManager.init()
    private override init() {
        super.init()
    }
    private func createPath()
    {
        
        if (!FileManager.default.fileExists(atPath: self.conmentPath))
        {
            if !FileManager.default.createFile(atPath: self.conmentPath, contents: nil, attributes: nil) {
                DebugLog(message: "创建用户文件失败")
            }
        }
    }
    var conmentPath:String = ""
    {
        didSet {
            self.createPath()
        }
    }
    func clearData(){
        do {
            
            try FileManager.default.removeItem(atPath: CommentPath)
        } catch let error {
            DebugLog(message: "\(String.init(describing: error))")
        }
    }
    func writeData(param:[[String:Any]]) {
        NSArray.init(array: param).write(toFile: self.conmentPath, atomically: true)
        self.appiontAry = NSArray.init(contentsOfFile: self.conmentPath) as? [[String : Any]]
    }
    
    var appiontAry:[[String:Any]]?
    
    
    func modifyLikes(index:Int,type:ModifyLikeType)//修改点赞数
    {
        var dic:[String:Any] = self.appiontAry?[index] ?? [:]
        var count:Int = dic["likes_count"] as? Int ?? 0
        if  type == .add {
            count += 1
            dic["is_like"] = 1
        }
        else
        {
            if count > 0{
                count -= 1
                dic["is_like"] = 0
            }
        }
        dic["likes_count"] = count
        self.appiontAry?.replaceSubrange(Range(index..<index+1), with: [dic])
    }
    func insertComment(content:String, create_at:Int,index:Int) {//修改评论
        
        let commentDic:[String:Any] = ["publisher_id":CurrentUserInfo?.data?.user_id ?? "","content":content,"create_at":create_at,"publisher_avatar":CurrentUserInfo?.data?.avatar ?? "","publisher_name":CurrentUserInfo?.data?.nickname ?? ""]
        
        var userDic:[String:Any] = self.appiontAry?[index] ?? [:]
        
        var commenAry:[Any] = userDic["comments"] as? [Any] ?? []
        commenAry.append(commentDic)
        userDic["comments"] = commenAry
        self.appiontAry?.replaceSubrange(Range(index..<index+1), with: [userDic])
    }
    var commentModels:[lonelySpeechDetaileModel]? {
        get{
            return JSONDeserializer<lonelySpeechDetaileModel>.deserializeModelArrayFrom(array: self.appiontAry) as? [lonelySpeechDetaileModel]
        }
    }
    
    
}
