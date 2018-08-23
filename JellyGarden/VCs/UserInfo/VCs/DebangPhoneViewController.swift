//
//  DebangPhoneViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class DebangPhoneViewController: BaseMainViewController {

    @IBOutlet weak var codeText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "绑定手机号"
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBtn.setTitle("确认更改", for: UIControlState.normal)
        rightBtn.isHidden = false
    }
    override func clickRightBtn() {
        guard let phoneStr = phoneText.text,phoneStr.count > 0 else {
            alertHud(title: "请输入手机号")
            return
            
        }
        guard let password = passWordText.text,password.count > 0 else {
            alertHud(title: "请输入手机号")
            return
            
        }
        guard let codeStr = codeText.text,codeStr.count > 0 else {
            alertHud(title: "请输入手机号")
            return
            
        }
        
        let param:[String:Any] = ["phone":phoneStr,"password":password.zzy.md5(),"verify_code":codeStr]
        
        TargetManager.share.debangPhoneNumber(params: param) { (success) in
            if success
            {
               let model = CurrentUserInfo
                model?.phone = phoneStr
                NSDictionary.init(dictionary: model?.toJSON() ?? [:]).write(toFile: UserPlist, atomically: true)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func clickCodeBtn(_ sender: TimingButton) {
        if !verifyPhoneStr(phone: phoneText.text) {
            return
        }
        
        let params = ["phone":phoneText.text!]
        sender.starTime()
        
        TargetManager.share.getMSCode(params: params) { (result, eror) in
           
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
