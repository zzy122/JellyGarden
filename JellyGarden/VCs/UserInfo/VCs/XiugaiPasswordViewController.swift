//
//  XiugaiPasswordViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/3.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class XiugaiPasswordViewController: BaseMainViewController {

    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var originPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        originPassword.isSecureTextEntry = true
        newPassword.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBtn.isHidden = false
        rightBtn.setTitle("保存", for: UIControlState.normal)
        rightBtn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
    }
    
    override func clickRightBtn() {//保存
        guard let oldpassword = originPassword.text,oldpassword.count != 0 else {
            alertHud(title: "请输入初始密码")
            return
        }
        guard let newpassword = newPassword.text,(newpassword.count > 5 && newpassword.count < 21) else {
            alertHud(title: "新密码为6 - 20位")
            return
        }
        
        
        let params:[String:Any] = ["user_id":CurrentUserInfo?.user_id ?? "","old_password":originPassword.text?.zzy.md5() ?? "","new_password":newPassword.text?.zzy.md5() ?? ""]
        TargetManager.share.xiugaiPassword(params: params) { (success) in
            if success {
                let model = CurrentUserInfo
                model?.password = newpassword.zzy.md5()
                NSDictionary.init(dictionary: model?.toJSON() ?? [:]).write(toFile: UserPlist, atomically: true)
                self.navigationController?.popViewController(animated: true)
            }
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
