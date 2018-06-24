//
//  ChatRoomViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/22.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let PLUGIN_BOARD_DEPOSIT_FILE_TAG = 2004//定金
let PLUGIN_BOARD_GIFT_FILE_TAG = 2005//礼物
let PLUGIN_BOARD_VIDEO_FILE_TAG = 2001//视频通话
let PLUGIN_BOARD_READ_FILE_TAG = 2002//阅后即焚
let PLUGIN_BOARD_REDBAG_FILE_TAG = 2003//红包
class ChatRoomViewController: RCConversationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //增加收取定金功能和礼物打赏功能
        if self.conversationType != RCConversationType.ConversationType_APPSERVICE && self.conversationType != RCConversationType.ConversationType_PUBLICSERVICE {
            let image = imageName(name: "阅后即焚-1")
            let image2 = imageName(name: "礼物打赏")
            let image3 = imageName(name: "位置")
            let image4 = imageName(name: "订金")
            let image5 = imageName(name: "红包")
            let image6 = imageName(name: "视屏通话")
            
            
            let plugin = self.chatSessionInputBarControl.pluginBoardView;
            plugin?.insertItem(with: image6, title: "视频通话", tag: PLUGIN_BOARD_VIDEO_FILE_TAG)
            plugin?.insertItem(with: image, title: "阅后即焚", tag: PLUGIN_BOARD_READ_FILE_TAG)
            plugin?.insertItem(with: image5, title: "红包", tag: PLUGIN_BOARD_REDBAG_FILE_TAG)
            plugin?.insertItem(with: image4, title: "收取定金", tag: PLUGIN_BOARD_DEPOSIT_FILE_TAG)
            plugin?.insertItem(with: image2, title: "打赏礼物", tag: PLUGIN_BOARD_GIFT_FILE_TAG)
//            plugin?.updateItem(withTag: 1001, image: , title: <#T##String!#>)
            plugin?.updateItem(at: 0, image: imageName(name: "相册"), title: "相册")
            plugin?.updateItem(at: 2, image: image3, title: "位置")
            plugin?.updateItem(at: 1, image: imageName(name: "拍摄"), title: "拍摄")
            
        }
        self.register(DepositMessageCell.self, forMessageClass: DepositMessage.self)//自定义收取定金消息
        // Do any additional setup after loading the view.
    }
    override func pluginBoardView(_ pluginBoardView: RCPluginBoardView!, clickedItemWithTag tag: Int) {
        switch tag {
        case PLUGIN_BOARD_REDBAG_FILE_TAG://红包
            break
        case PLUGIN_BOARD_READ_FILE_TAG://阅后即焚
            break
        case PLUGIN_BOARD_VIDEO_FILE_TAG://视频
            break
        case PLUGIN_BOARD_GIFT_FILE_TAG://礼物
            break
        case PLUGIN_BOARD_DEPOSIT_FILE_TAG://收定金
            let mess = DepositMessage.init(content: "[红包]")
            mess?.isPay = NSNumber.init(value: 0)
            mess?.amotStr = "200"
            RCIM.shared().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: self.targetId, content: mess, pushContent: "测试", pushData: "yiha", success: { (resunt) in
                 DebugLog(message: "发送成功\(resunt)")
            }, error: { (code, errcod) in
                DebugLog(message: "发送失败\(errcod)")
            }) 
//            self.sendMessage(mess, pushContent: "test")
            
            
            break
        case 1003://位置
            break
        default:
             super.pluginBoardView(pluginBoardView, clickedItemWithTag: tag)
             break
            
           
        }
    
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func didTapMessageCell(_ model: RCMessageModel!) {
        super.didTapMessageCell(model)
        let content = model.content as? DepositMessage
        if content != nil && model.messageDirection == RCMessageDirection.MessageDirection_RECEIVE
        {
            DebugLog(message: "点击了红包 怎么刷新")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
