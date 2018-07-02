//
//  LoginVIewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class LoginVIewController: BaseViewController {
    @IBOutlet weak var userPhone: APPTextfiled!
    
    @IBOutlet weak var userPassword: APPTextfiled!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func clickLogin(_ sender: UIButton) {
//        let tabbarVC = BaseTabBarViewController()
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        delegate?.setRootViewController(vc: tabbarVC)
        guard let username = self.userPhone.text,username.count > 0 else{
            alertHud(title: "请输入手机号")
            return
        }
        guard let password = self.userPassword.text,password.count > 0 else{
            alertHud(title: "请输入密码")
            return
        }
        
        
        
        return
            loginActionParams(params: ["phone":username,"password":password.zzy.md5()], nav: self.navigationController)
        
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
