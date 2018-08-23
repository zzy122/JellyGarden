//
//  RegisterViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var codeTextfiled: APPTextfiled!
    @IBOutlet weak var userPhone: APPTextfiled!
    @IBOutlet weak var passWordFiled: APPTextfiled!
    var msg_id:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        // Do any additional setup after loading the view.
    }

    @IBAction func clickRegister(_ sender: UIButton) {
        if !verifyPhoneStr(phone: self.userPhone.text) {
            return
        }
        if codeTextfiled.text?.count == 0 {
            alertHud(title: "请输入验证码")
            return
        
        }
        if passWordFiled.text?.count == 0 {
            alertHud(title: "请输入密码")
            return
        }
        let params = ["phone":userPhone.text!,"password":self.passWordFiled.text!.zzy.md5() ,"verify_code":codeTextfiled.text!,"msg_id":self.msg_id] as [String : Any]
        
        
        TargetManager.share.registerUser(params: params) { (resut, error) in
            if error == nil{//注册成功
                self.gotoLogin()
            }
        }
        
        
    }
    func gotoLogin() {
        
        loginActionParams(params: ["phone":self.userPhone.text!,"password":self.passWordFiled.text!.zzy.md5()], nav: self.navigationController)
    }
    @IBAction func clickSendCode(_ sender: TimingButton) {
        if !verifyPhoneStr(phone: userPhone.text) {
            return
        }
        
        let params = ["phone":userPhone.text!]
        sender.starTime()
        
        TargetManager.share.getMSCode(params: params) { (result, eror) in

            self.msg_id = result!["msg_id"] as! String
        }
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
