//
//  ChatRoomViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/22.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import Photos

let PLUGIN_BOARD_DEPOSIT_FILE_TAG = 2004//定金
let PLUGIN_BOARD_GIFT_FILE_TAG = 2005//礼物
let PLUGIN_BOARD_VIDEO_FILE_TAG = 2001//视频通话
let PLUGIN_BOARD_READ_FILE_TAG = 2002//阅后即焚
let PLUGIN_BOARD_REDBAG_FILE_TAG = 2003//红包
class ChatRoomViewController: RCConversationViewController,RCRealTimeLocationObserver,PhotoPickerControllerDelegate {
    var realTimeLocation:RCRealTimeLocationProxy?
    let lookDestoryView:LookDestoryImage = {
        let view1 = LookDestoryImage.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        return view1
    }()
    
    
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
        /*******************实时地理位置共享***************/

        self.register(RealTimeLocationStartCell.self, forMessageClass: RCRealTimeLocationStartMessage.self)
        self.register(RealTimeLocationStartCell.self, forMessageClass: RCRealTimeLocationEndMessage.self)
        RCRealTimeLocationManager.shared().getRealTimeLocationProxy(self.conversationType, targetId: self.targetId, success: { [weak self](location) in
            self?.realTimeLocation = location
            self?.realTimeLocation?.add(self)
            
        }) { (code) in
            
        }
        self.register(RealTimeLocationEndCell.self, forMessageClass: RCRealTimeLocationEndMessage.self)

        
        self.register(DepositMessageCell.self, forMessageClass: DepositMessage.self)//自定义收取定金消息
        self.register(TagStatueCell.self, forMessageClass: TagStatueMessage.self)
        self.register(ReadDestroyCell.self, forMessageClass: ReadDestroyMessage.self)
        // Do any additional setup after loading the view.
    }
    override func pluginBoardView(_ pluginBoardView: RCPluginBoardView!, clickedItemWithTag tag: Int) {
        switch tag {
        case PLUGIN_BOARD_REDBAG_FILE_TAG://红包
            break
        case PLUGIN_BOARD_READ_FILE_TAG://阅后即焚
            let vc = QPPhotoPickerViewController(type: PageType.AllAlbum)
            vc.imageSelectDelegate = self
            //最大照片数量
            vc.imageMaxSelectedNum = 1
            self.present(vc, animated: true, completion: nil)
            break
        case PLUGIN_BOARD_VIDEO_FILE_TAG://视频
            alertHud(title: "收费项目");
            break
        case PLUGIN_BOARD_GIFT_FILE_TAG://礼物
            alertHud(title: "待定功能")
            break
        case PLUGIN_BOARD_DEPOSIT_FILE_TAG://收定金
            AlertAction.share.showAlertView(type: UIKeyboardType.numberPad, title: "订金", placeHodel: "请输入订金金额", detailTitle: "收入将进入你的钱包中,可提现", detailImage: imageName(name: ""), click: { (suscces, backStr) in
                if suscces {
                    let mess = DepositMessage.init(content: "")
                    mess?.senderUserInfo = RCIM.shared().currentUserInfo
                    mess?.amotStr = backStr
                    mess?.isPay = NSNumber.init(value: 0)
                    RCIM.shared().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: self.targetId, content: mess, pushContent: "测试", pushData: "yiha", success: { (resunt) in
                        DebugLog(message: "发送成功\(resunt)")
                    }, error: { (code, errcod) in
                        DebugLog(message: "发送失败\(errcod)")
                    })
                }
            })
            
            
            
            
            break
        case 1003://位置
            AlertViewCoustom().showalertView(style: .actionSheet, title: nil, message: nil, cancelBtnTitle: alertCancel, touchIndex: { (index) in
                if index == 1
                {
                    super.pluginBoardView(self.chatSessionInputBarControl.pluginBoardView, clickedItemWithTag: 1003)
                }
                else if index == 2 {
                    
                    self.showRealTimeLocationViewController()
                    
                }
                
                
            }, otherButtonTitles: "发送位置", "位置实时共享")
            break
        default:
             super.pluginBoardView(pluginBoardView, clickedItemWithTag: tag)
             break
            
           
        }
    
        
    }
    func popupChatViewController()
    {
        super.leftBarButtonItemPressed(nil)
        self.realTimeLocation?.remove(self)
        
        
    }
    func showRealTimeLocationViewController()
    {
        let vc = RealTimeLocationViewController()
        vc.realTimeLocationProxy = self.realTimeLocation
        if self.realTimeLocation?.getStatus() == RCRealTimeLocationStatus.REAL_TIME_LOCATION_STATUS_CONNECTED
        {
           self.realTimeLocation?.joinRealTimeLocation()
        }
        else if self.realTimeLocation?.getStatus() == RCRealTimeLocationStatus.REAL_TIME_LOCATION_STATUS_IDLE
        {
           self.realTimeLocation?.startRealTimeLocation()
        }
        
        self.navigationController?.present(vc, animated: true, completion: {
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func didTapMessageCell(_ model: RCMessageModel!) {
        super.didTapMessageCell(model)
        
        if let content = model.content as? DepositMessage, model.messageDirection == RCMessageDirection.MessageDirection_RECEIVE
        {//跳转支付宝或者微信发起支付
            let params:[String:Any] = ["type":0,"user_id":model.userInfo.userId,"amount":Int(content.amotStr) ?? 0,"recipient":content.senderUserInfo.userId]
            
//            TargetManager.share.transfer(params: params, complection: { (result, error) in
//                if result {
//                    
//                }
//            })
            
            let mess = TagStatueMessage.init(content: "")
            mess?.senderUserInfo = RCIM.shared().currentUserInfo
            RCIM.shared().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: self.targetId, content: mess, pushContent: "测试", pushData: "yiha", success: { (resunt) in
                DebugLog(message: "发送成功\(resunt)")
            }, error: { (code, errcod) in
                DebugLog(message: "发送失败\(errcod)")
            }) 
            
            self.reloadDataIsPay(message: content)

            DebugLog(message: "点击了红包 怎么刷新")
        }
        if (model.content as? RCRealTimeLocationStartMessage) != nil  {
            self.showRealTimeLocationViewController()
        }
        if let mess = model.content as? ReadDestroyMessage {
            DebugLog(message: "地址:\(mess.imageUrl)");
            self.hiddenDestroyImage()
        }
        if let mess = model.content as? RCImageMessage {
            DebugLog(message: "地址:\(mess.imageUrl)");
            
        }
        
    }
    func reloadDataIsPay(message:DepositMessage)  {
        DispatchQueue.main.async {
            for i:Int in 0 ..< self.conversationDataRepository.count
            {
                let mess:RCMessageModel = self.conversationDataRepository.object(at: i) as! RCMessageModel
                if mess.content == message
                {
                    message.isPay = NSNumber.init(value: 1)
                    mess.content = message
                }
            }
            let ary = self.conversationMessageCollectionView.indexPathsForVisibleItems
            for i:Int in 0 ..< ary.count
            {
                let index = ary[i]
                let model:RCMessageModel = self.conversationDataRepository.object(at: index.row) as! RCMessageModel
                if model.content == message
                {
                    self.conversationMessageCollectionView.reloadItems(at: [index])
                }
            }
        }
    }
    override func didLongTouchMessageCell(_ model: RCMessageModel!, in view: UIView!) {//长按
        guard let destroy = model.content as? ReadDestroyMessage else {
            super.didLongTouchMessageCell(model, in: view)
            return
        }
    self.lookDestoryView.imageView.imageBack.sd_DownLoadImage(url: destroy.imageUrl ?? "")
        self.showDestroyImage()
    }
    func hiddenDestroyImage() {
        self.lookDestoryView.removeFromSuperview()
    }
    func showDestroyImage() {
        UIApplication.shared.keyWindow?.addSubview(lookDestoryView)
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
extension ChatRoomViewController
{
    
   
    func onImageSelectFinished(images: [PHAsset]) {
        
        QPPhotoDataAndImage.getImagesAndDatas(photos: images) { (array) in
            
            let model:QPPhotoImageModel? = array?.last
            let mes:ReadDestroyMessage  = ReadDestroyMessage.init()
            mes.originalImage = model?.bigImage!
            mes.isRead = NSNumber.init(value: 0)
            mes.senderUserInfo = RCIM.shared().currentUserInfo
            RCIM.shared().sendMediaMessage(RCConversationType.ConversationType_PRIVATE, targetId: self.targetId, content: mes, pushContent: "阅后即焚", pushData: "图片", progress: { (gress, messageId) in
                DebugLog(message: "进度:\(gress)userid:\(messageId)")
                
            }, success: { (code) in
                DebugLog(message: "发送图片成功")
            }, error: { (errorCode, code) in
                
            }, cancel: { (tag) in
                
            })
            
            
            //发送阅后即焚消息
            MM_WARNING
            
        }
    }
    
}
