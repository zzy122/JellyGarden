//
//  ChatRoomViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/22.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import Photos
import TZImagePickerController

let PLUGIN_BOARD_DEPOSIT_FILE_TAG = 2004//定金
let PLUGIN_BOARD_GIFT_FILE_TAG = 2005//礼物
let PLUGIN_BOARD_VIDEO_FILE_TAG = 2001//视频通话
let PLUGIN_BOARD_READ_FILE_TAG = 2002//阅后即焚
let PLUGIN_BOARD_REDBAG_FILE_TAG = 2003//红包
class ChatRoomViewController: RCConversationViewController,RCRealTimeLocationObserver,TZImagePickerControllerDelegate{
    var realTimeLocation:RCRealTimeLocationProxy?
    let lookDestoryView:LookDestoryImage = {
        let view1 = LookDestoryImage.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        return view1
    }()
    var depositView:ChatDepositAlertView?
    lazy var depositAlertBackView:UIView = {
        let view1 = UIView.init(frame: CGRect.init(x: 20, y: 0, width: ScreenWidth - 40 , height: 250))
        self.depositView = ChatDepositAlertView.createChatDepositAlertView()
        self.depositView?.clickBlock =  {(sure,amountStr,timeStr) in
            self.alertAction.hiddenTheView()
        }
        self.depositView?.frame = view1.bounds
        view1.layer.cornerRadius = 8.0
        view1.clipsToBounds = true
        view1.addSubview(self.depositView!)
        return view1
    }()
    lazy var alertAction:AlipayAction = {
        let action = AlipayAction.init(showType: .center, view: self.depositAlertBackView, windowView: self.navigationController?.view)
        return action
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //增加收取定金功能和礼物打赏功能
        if self.conversationType != RCConversationType.ConversationType_APPSERVICE && self.conversationType != RCConversationType.ConversationType_PUBLICSERVICE {
            let image = imageName(name: "阅后即焚-1")
            let image2 = imageName(name: "礼物打赏")
            let image3 = imageName(name: "位置")
            let image4 = imageName(name: "收取定金")
            let image5 = imageName(name: "红包")
            let image6 = imageName(name: "视频通话")
            let plugin = self.chatSessionInputBarControl.pluginBoardView;
            plugin?.updateItem(at: 0, image: imageName(name: "相册"), title: "相册")
            plugin?.updateItem(at: 2, image: image3, title: "位置")
            plugin?.updateItem(at: 1, image: imageName(name: "拍摄"), title: "拍摄")
             plugin?.updateItem(at: 4, image: image6, title: "视频通话")
            plugin?.updateItem(at: 5, image: image5, title: "红包")
            plugin?.removeItem(at: 3)
            plugin?.insertItem(with: image, title: "阅后即焚", at: 5, tag: PLUGIN_BOARD_READ_FILE_TAG)
            plugin?.insertItem(with: image4, title: "收取定金", tag: PLUGIN_BOARD_DEPOSIT_FILE_TAG)
            plugin?.insertItem(with: image2, title: "打赏礼物", tag: PLUGIN_BOARD_GIFT_FILE_TAG)
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
            JrmfWalletSDK.openWallet()
            
            break
        case PLUGIN_BOARD_READ_FILE_TAG://阅后即焚
            let vc = TZImagePickerController.init(maxImagesCount: 1, delegate: self)
            vc?.allowPickingVideo = false
            vc?.allowPickingImage = true
            vc?.allowTakePicture = true
            vc?.didFinishPickingPhotosHandle = {(photos, assets, isSelectOriginalPhoto) in
                let yunmodel:AliyunUploadModel = AliyunUploadModel()
                yunmodel.image = photos?.last
                yunmodel.fileName = "\(getImageName()).png"
                AliyunManager.share.uploadImagesToAliyun(imageModels: [yunmodel], complection: { (urls, failCount, successCount, state) in
                    if state == UploadImageState.success
                    {
                        self.sendImage(url: urls?.last ?? "")
                    }
                })
            }
            
            self.present(vc!, animated: true, completion: nil)
            
            break
//        case PLUGIN_BOARD_VIDEO_FILE_TAG://视频
//            AlertViewCoustom().showalertView(style: .actionSheet, title: nil, message: nil, cancelBtnTitle: "取消", touchIndex: { (index) in
//                if index == 1
//                {
//                    if RCCall.shared().isAudioCallEnabled(RCConversationType.ConversationType_PRIVATE)
//                    {
//                        RCCall.shared().startSingleCall(self.targetId, mediaType: RCCallMediaType.audio)
////                        RCCall.shared().startSingleCall(targetId, mediaType: RCCallMediaType.audio)
//                    }
//
//                }
//                else if index == 2
//                {
//                    if RCCall.shared().isVideoCallEnabled(RCConversationType.ConversationType_PRIVATE)
//                    {
//                        RCCall.shared().startSingleCall(self.targetId, mediaType: RCCallMediaType.video)
//                    }
//                }
//
//            }, otherButtonTitles: "语音聊天", "视频聊天")
//            alertHud(title: "收费项目");
//            break
        case PLUGIN_BOARD_GIFT_FILE_TAG://礼物
            alertHud(title: "待定功能")
            break
        case PLUGIN_BOARD_DEPOSIT_FILE_TAG://收定金
            alertAction.showView = self.depositAlertBackView
            self.depositView?.depositAmountTextFiled.text = ""
            alertAction.showType = .center
            alertAction.backView.isUserInteractionEnabled = false
            alertAction.showTheView()
//            AlertAction.share.showAlertView(type: UIKeyboardType.numberPad, title: "订金", placeHodel: "请输入订金金额",textStr:nil, detailTitle: "收入将进入你的钱包中,可提现", detailImage: imageName(name: ""), click: { (suscces, backStr) in
//                if suscces {
//                    let mess = DepositMessage.init(content: "")
//                    mess?.senderUserInfo = RCIM.shared().currentUserInfo
//                    mess?.amotStr = backStr
//                    mess?.isPay = NSNumber.init(value: 0)
//                    RCIM.shared().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: self.targetId, content: mess, pushContent: "测试", pushData: "yiha", success: { (resunt) in
//                        DebugLog(message: "发送成功\(resunt)")
//                    }, error: { (code, errcod) in
//                        DebugLog(message: "发送失败\(errcod)")
//                    })
//                }
//            })
            
            
            
            
            break
        case 1003://位置
            
            super.pluginBoardView(self.chatSessionInputBarControl.pluginBoardView, clickedItemWithTag: 1003)
//            AlertViewCoustom().showalertView(style: .actionSheet, title: nil, message: nil, cancelBtnTitle: alertCancel, touchIndex: { (index) in
//                if index == 1
//                {
//                    super.pluginBoardView(self.chatSessionInputBarControl.pluginBoardView, clickedItemWithTag: 1003)
//                }
//                else if index == 2 {
//                    
//                    self.showRealTimeLocationViewController()
//                    
//                }
//                
//                
//            }, otherButtonTitles: "发送位置", "位置实时共享")
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
        {
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
            TargetManager.share.readImageForUserid(params: ["user_id":CurrentUserInfo?.user_id ?? "","url":mess.imageUrl ?? ""]) { (model, error) in
                if model?.has_viewed == false
                {
                    let vc = LookImageViewController()
                    vc.imageUrl = mess.imageUrl
                    vc.type = .effect
                    RootNav().pushViewController(vc, animated: true)
                }
            }
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
        let param:[String:Any] = ["user_id":RCIM.shared().currentUserInfo.userId,"url":destroy.imageUrl]
        TargetManager.share.readImageForUserid(params: param) { (readModel, error) in
            guard let tagsuc = readModel?.has_viewed,tagsuc == false else {
                if error == nil
                {
                   alertHud(title: "照片已焚毁")
                }
                return;
            }
            self.lookDestoryView.imageView.imageBack.sd_DownLoadImage(url: destroy.imageUrl ?? "", complection: { (image) in
                
            })
            self.showDestroyImage()
        }
    
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
    
    func sendImage(url:String)
    {
        let mes:ReadDestroyMessage  = ReadDestroyMessage.init()
        mes.imageUrl = url
        mes.isRead = NSNumber.init(value: 0)
        mes.senderUserInfo = RCIM.shared().currentUserInfo
        
        RCIM.shared().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: self.targetId, content: mes, pushContent: "阅后即焚", pushData: "图片", success: { (resunt) in
            DebugLog(message: "发送成功\(resunt)")
        }, error: { (code, errcod) in
            DebugLog(message: "发送失败\(errcod)")
        })
    }
    
}
