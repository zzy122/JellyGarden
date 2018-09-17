//
//  DepositListModel.swift
//  JellyGarden
//
//  Created by zzy on 15/9/18.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
struct DepositStatus {
    let pay_NoSure = "已支付,待确认"
    let sured = "已确认"
    let askFor = "索回中"
    let hasAskFor = "索回成功，已完成"
    let reviewing = "审核中"
    let askForFailed = "索回失败"
    
    //女的
    let pay_WomanMan_NoSure = "待确认"
    let pay_refund = "已退款"
    let womanReview = "已提交审核"
    let reviewSuccess = "审核成功,已完成"
    let reviewFailed = "审核失败，已完成"
}






struct DepositListModel: JSON {
    init() {
        
    }
    var pay_money:String?
    var yue_time:Int?
    var pay_time:String?
    var user_name:String?
    var user_image:String?
    var status:String = DepositStatus().pay_NoSure
    var order_num:String? //订单号
}
