//
//  NotifyModel.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/23.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit



struct NotifyModel: JSON {
    var type:Int = 0//1电台广播 2//收益提醒 //3果冻花园 //4联系方式 // 5查看申请 6//评价通知 7//定金通知
    var readView:Bool = false//已读未读
    var currentTime:Int = getTimeStamp(date: Date())
    var message:String?//消息
}
