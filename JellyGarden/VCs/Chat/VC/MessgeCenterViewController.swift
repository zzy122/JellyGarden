//
//  MessgeCenterViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/26.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HTHorizontalSelectionList

class MessgeCenterViewController: BaseMainViewController,UIScrollViewDelegate {
    lazy var scrollItemView: HTHorizontalSelectionList = {
        let list = HTHorizontalSelectionList()
        list.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 45)
        list.delegate = self
        list.dataSource = self
        list.bottomTrimHidden = true
        list.selectionIndicatorColor = APPCustomBtnColor
        list.setTitleFont(UIFont.systemFont(ofSize: 14), for: UIControlState.normal)
        list.setTitleColor(UIColor.black, for: UIControlState.normal)
        list.setTitleColor(APPCustomBtnColor, for: UIControlState.selected)
        list.selectionIndicatorHeight = 2
        list.centerButtons = true
        list.selectedButtonIndex = 0
        return list
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
    
    override func clickRightBtn() {
        RootViewController?.hideTheTabbar()
        self.navigationController?.pushViewController(MessagePushSettingViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5)
        scrollItemView.setSelectedButtonIndex(index, animated: true)
    }
}

extension MessgeCenterViewController: HTHorizontalSelectionListDelegate {
    
    func selectionList(_ selectionList: HTHorizontalSelectionList, didSelectButtonWith index: Int) {
        bodyScrollView.setContentOffset(CGPoint(x: bodyScrollView.bounds.size.width * CGFloat(index), y: 0), animated: true)
    }
}

extension MessgeCenterViewController: HTHorizontalSelectionListDataSource {
    
    func selectionList(_ selectionList: HTHorizontalSelectionList, badgeValueForItemWith index: Int) -> String? {
        return nil
    }
    
    func numberOfItems(in selectionList: HTHorizontalSelectionList) -> Int {
        return 2
    }
    
    func selectionList(_ selectionList: HTHorizontalSelectionList, titleForItemWith index: Int) -> String? {
        return 0 == index ? "聊天" : "系统消息"
    }
}

