//
//  ApplayForCodeViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/6.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ApplayForCodeViewController: BaseViewController {

    @IBOutlet weak var suggestPersonFiled: APPTextfiled!
    @IBOutlet weak var wechatAccountFiled: APPTextfiled!
    @IBOutlet weak var messageFiled: APPTextfiled!
    @IBOutlet weak var localCityTextfiled: APPTextfiled!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "申请邀请码"
        // Do any additional setup after loading the view.
    }

    @IBAction func clickAplayBtn(_ sender: UIButton) {
        guard let localStr = localCityTextfiled.text,localStr.count > 0 else {
           alertHud(title: "请输入所在地")
            return
        }
        guard let channal = messageFiled.text,channal.count > 0 else {
            alertHud(title: "请输入信息渠道")
            return
        }
        guard let wxStr = wechatAccountFiled.text,wxStr.count > 0 else {
            alertHud(title: "请输入微信号")
            return
        }
        
        var params:[String:Any] = ["city":localStr,"channel":channal,"wechat":wxStr,"user_id":CurrentUserInfo?.user_id ?? ""]
        
        if let sugesStr = suggestPersonFiled.text,sugesStr.count > 0 {
            params["referee"] = sugesStr
        }
        TargetManager.share.inviteCode(params: params) { (result, error) in
            if (result)
            {
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
