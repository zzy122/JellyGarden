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
//        clearUserInfo()
        FillCondition.share.getConditions()
        self.autoLogin()
        // Do any additional setup after loading the view.
    }
    
    func autoLogin() {//自动登录
        if let user = CurrentUserInfo {
            if let nickName = user.data?.nickname, nickName.count > 0  {
                loginActionParams(params: ["phone":user.data?.phone ?? "","password":user.data?.password ?? ""], nav: self.navigationController)
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
       
//        let post  = ["stature": 25.0, "dress_style": "[\"制服\"]", "nickname": "zzy1", "age": 17.0, "identity": "白领", "language": "[\"粤语\"]", "appointment_place": "[\"自贡\"]", "contact_qq": "1332365", "tags": "[\"学霸\",\"女神经\"]", "self_introduction": "", "emotion_status": "已婚", "appointment_condition": "[\"有车\"]", "avatar": "", "contact_wechat": "", "weight": 25.0, "appointment_program": "[\"唱歌\"]", "sex": "1", "bust": 25.0] as [String : Any]
//        let params = ["user_json":post]
//
//
//        NetCostom.shared.requestTest(method: .put, wengen: "users/5b225c0bf0fae043f502adac", params: params, success: { (result) in
//
//        }) { (error) in
//
//        }
        
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
