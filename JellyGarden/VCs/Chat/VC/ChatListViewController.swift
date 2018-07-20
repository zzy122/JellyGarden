//
//  ChatListViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ChatListViewController: RCConversationListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDisplayConversationTypes([NSNumber.init(value: UInt8(RCConversationType.ConversationType_PRIVATE.rawValue)),NSNumber.init(value: UInt8(RCConversationType.ConversationType_DISCUSSION.rawValue)),NSNumber.init(value: UInt8(RCConversationType.ConversationType_GROUP.rawValue)),NSNumber.init(value: UInt8(RCConversationType.ConversationType_APPSERVICE.rawValue)),NSNumber.init(value: UInt8(RCConversationType.ConversationType_SYSTEM.rawValue))])
        self.createImputView()
        // Do any additional setup after loading the view.
    }
    func createImputView()
    {
        let view1 = UIView.init(frame: self.view.bounds)
        view1.backgroundColor = customBackViewColor
        let image = UIImageView.init(image: imageName(name: "聊天"))
        image.frame  = CGRect.init(x: (self.view.bounds.size.width - 108) / 2.0, y:(self.view.bounds.size.height - 54) / 2.0 , width: 108, height: 54)
        view1.addSubview(image)
        let lable = creatLable(frame: CGRect.init(x: 0, y: image.frame.maxY + 30, width: ScreenWidth, height: 30), title: "你可以在对方的用户详情页面发起私聊哦", font: kFont_SmallNormal, textColor: UIColor.gray)
        lable.backgroundColor = UIColor.clear
        lable.textAlignment = NSTextAlignment.center
        view1.addSubview(lable)
        self.emptyConversationView = view1
    }
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        RootViewController?.hideTheTabbar()
        let vc = ChatRoomViewController()
        vc.conversationType = model.conversationType
        vc.targetId = model.targetId
        vc.title = model.conversationTitle
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RootViewController?.showTheTabbar()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
