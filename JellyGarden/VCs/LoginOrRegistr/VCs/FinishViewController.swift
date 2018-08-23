//
//  FinishViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class FinishViewController: BaseViewController {
//    @IBOutlet weak var topView: UIView!

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerBtn.layer.borderWidth = 1.0
        registerBtn.layer.borderColor = APPCustomBtnColor.cgColor
        FillCondition.share.getConditions()
        clearUserInfo()
        
        self.autoLogin()
       
        
    }
    
    func autoLogin() {//自动登录
        if let user = CurrentUserInfo {
            if let nickName = user.nickname, nickName.count > 0  {
                loginActionParams(params: ["phone":user.phone ?? "","password":user.password ?? ""], nav: self.navigationController)
            }
        }
        if currentCitys == nil {
            TargetManager.share.getCitysModel(complection: { (models, error) in
                
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func clickWeiBoBtn(_ sender: UIButton) {
        UMengAcion.uMengLogin(type: UMSocialPlatformType.sina,nav:self.navigationController) { (sucess) in
           
        }
    }
    @IBAction func clickQQBtn(_ sender: UIButton) {
        UMengAcion.uMengLogin(type: UMSocialPlatformType.QQ,nav:self.navigationController) { (success) in
            
        }
    }
    @IBAction func clickWeiXinBtn(_ sender: UIButton) {
        UMengAcion.uMengLogin(type: UMSocialPlatformType.wechatSession,nav:self.navigationController) { (success) in
           
        }
    }
    func gotoManVC() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.setRootViewController(vc: BaseTabBarViewController())
    }
    @IBAction func registerBtn(_ sender: UIButton) {
        
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    @IBAction func loginBtn(_ sender: UIButton) {
        self.navigationController?.pushViewController(LoginVIewController(), animated: true)
        
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
