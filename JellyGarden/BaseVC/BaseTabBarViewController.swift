//
//  BaseTabBarViewController.swift
//  LeShanBankSwift
//
//  Created by zzy on 2018/4/16.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController ,UITabBarControllerDelegate{
    var tabBarAry:NSMutableArray = NSMutableArray()
    var tabBarItems:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabbarView()
        
        // Do any additional setup after loading the view.
    }
    func tabbarView() {
        let test1 = MainViewController()
        let test1Nv = CustomNavigationViewController.init(rootViewController: test1)
        
        
        let item1 = UITabBarItem()
        item1.image = imageName(name: "果冻花园")
        item1.selectedImage = imageName(name: "果冻花园-press")
        item1.title = "果冻花园"
        test1Nv.tabBarItem = item1
        
        let test2 = AppointViewController()
        let test2Nv = CustomNavigationViewController.init(rootViewController: test2)
        let item2 = UITabBarItem()
        item2.image = imageName(name: "寂寞告白")
        item2.selectedImage = imageName(name: "寂寞告白-press")
        item2.title = "寂寞告白"
        test2Nv.tabBarItem = item2
        
        let test3 = ChatListViewController()
        let test3Nv = CustomNavigationViewController.init(rootViewController: test3)
        let item3 = UITabBarItem()
        item3.image = imageName(name: "消息")
        item3.selectedImage = imageName(name: "消息-press")
        item3.title = "消息"
        test3Nv.tabBarItem = item3
        
        let test4 = UserInfoViewController()
        let test4Nv = CustomNavigationViewController.init(rootViewController: test4)
        let item4 = UITabBarItem()
        item4.image = imageName(name: "我的")
        item4.selectedImage = imageName(name: "我的-press")
        item4.title = "我的"
        test4Nv.tabBarItem = item4
        
        tabBarAry.add(test1Nv)
        tabBarAry.add(test2Nv)
        tabBarAry.add(test3Nv)
        tabBarAry.add(test4Nv)
        tabBarItems.add(item1)
        tabBarItems.add(item2)
        tabBarItems.add(item3)
        tabBarItems.add(item4)
        
        RootViewController = self
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.white
        self.viewControllers = tabBarAry as? [UIViewController]
    }
    
    func hideTheTabbar() {
        self.tabBar.isHidden = true
    }
    func showTheTabbar() {
        self.tabBar.isHidden = false
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
