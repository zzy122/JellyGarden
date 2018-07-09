//
//  MessgeCenterViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/26.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class MessgeCenterViewController: BaseMainViewController,UIScrollViewDelegate {
    lazy var scrollItemView:ITemScrollView = {
        
        let itemScroll = ITemScrollView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 45), dataAry: ["聊天","系统消息"], back: { (index) in
            self.bodyScrollView.setContentOffset(CGPoint.init(x: CGFloat(index) * ScreenWidth, y: 0), animated: true)
        })
        return itemScroll
        
    }()
    
    
    lazy var messageVC:ChatListViewController  = {
       let chatVC = ChatListViewController()
        self.addChildViewController(chatVC)
        self.bodyScrollView.addSubview(chatVC.view)
        return chatVC
    }()
    lazy var sysTemVc:SystemMessageViewController = {
        let vc = SystemMessageViewController()
        self.addChildViewController(vc)
        self.bodyScrollView.addSubview(vc.view)
        return vc
    }()
    lazy var bodyScrollView:UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.frame = CGRect.init(x: 0, y: self.scrollItemView.frame.maxY, width: ScreenWidth, height: self.view.frame.height - self.scrollItemView.frame.maxY)
        scrollView.contentSize = CGSize.init(width: scrollView.frame.width * 2, height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    override func viewWillLayoutSubviews() {
        self.bodyScrollView.frame = CGRect.init(x: 0, y: self.scrollItemView.frame.maxY, width: ScreenWidth, height: self.view.frame.height - self.scrollItemView.frame.maxY)
        self.bodyScrollView.contentSize = CGSize.init(width: bodyScrollView.frame.width * 2, height: bodyScrollView.frame.height)
        self.messageVC.view.frame = CGRect.init(x: 0, y: 0, width: bodyScrollView.contentSize.width, height: bodyScrollView.contentSize.height)
        self.sysTemVc.view.frame = CGRect.init(x: ScreenWidth, y: 0, width: bodyScrollView.contentSize.width, height: bodyScrollView.contentSize.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.scrollItemView)
        view.addSubview(self.bodyScrollView)
        self.title = "消息中心"
         self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBtn.setTitle("设置", for: UIControlState.normal)
        rightBtn.isHidden = false
        self.rightBtn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
    }
    override func viewDidAppear(_ animated: Bool) {
        if UnreadCount > 0 {
            self.scrollItemView.showrightTageView(tags: [0])
        }
    }
    override func clickRightBtn() {
        RootViewController?.hideTheTabbar()
        
        self.navigationController?.pushViewController(MessagePushSettingViewController(), animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x:CGFloat = scrollView.contentOffset.x
        if x > 10 {
            self.scrollItemView.setItemtarget(index: 1)
        }
        else{
             self.scrollItemView.setItemtarget(index: 0)
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

