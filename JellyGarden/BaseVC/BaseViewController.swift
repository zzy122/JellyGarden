//
//  BaseViewController.swift
//  LeShanBankSwift
//
//  Created by zzy on 2018/4/12.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var leftBtn:ImageRightBtn = {
        let btn = ImageRightBtn()
        btn.setImage(imageName(name: "返回"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(clickLeftBtn), for: UIControlEvents.touchUpInside)
        let barbutton = UIBarButtonItem.init(customView: btn)
        self.navigationItem.leftBarButtonItem = barbutton
        
        return btn
    }()
    
    lazy var rightBtn:UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(clickRightBtn), for: UIControlEvents.touchUpInside)
        btn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
        let barbutton = UIBarButtonItem.init(customView: btn)
        self.navigationItem.rightBarButtonItem = barbutton
        return btn
    }()
    
    var logoTopBackView:UIImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.autoresizesSubviews = true
//        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.edgesForExtendedLayout = UIRectEdge.all
        self.view.backgroundColor = customBackViewColor
        self.logoTopBackView = UIImageView.init(image: imageName(name: ""))
        self.logoTopBackView.frame = CGRect.init(x: (ScreenWidth - 200) / 2.0, y: 8, width: 200, height: 30)
        self.logoTopBackView.tag = 600
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barTintColor = k_CustomColor(red: 200, green: 200, blue: 200)
        
       //设置导航栏透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //隐藏下划线
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.isTranslucent = true//导航栏覆盖view
        //设置title样式
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font:kFont_system20]
        self.leftBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.rightBtn.isHidden = true
        if self.navigationController?.viewControllers.count == 1
        {
            self.leftBtn.isHidden = true
        }
        self.rightBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        
        if let view = self.navigationController?.navigationBar.viewWithTag(666)
        {
            view.isHidden = true
        }
        else
        {
            self.navigationController?.navigationBar.addSubview(self.logoTopBackView)
        }
        
    }
    @objc public func clickLeftBtn()
    {
        self.view.endEditing(true)
        self.navigationController?.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @objc public func clickRightBtn()
    {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

