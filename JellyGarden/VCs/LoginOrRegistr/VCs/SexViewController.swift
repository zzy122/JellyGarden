//
//  SexViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class SexViewController: BaseViewController {

    @IBAction func manBtn(_ sender: UIButton) {
        self.gotoResister(man: true)
    }
    @IBAction func womanBtn(_ sender: UIButton) {
        self.gotoResister(man: false)
    }
    func gotoResister(man:Bool) {
        if man {
        self.navigationController?.pushViewController(InvitationCodeViewController(), animated: true)
        }
        else
        {
           self.navigationController?.pushViewController(FillInformationFirstViewController(), animated: true)
        }
        UserDefaults.standard.set(man, forKey: RegisterSexMan)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "你是"
        // Do any additional setup after loading the view.
    }
    override func clickLeftBtn() {
        AlertViewCoustom().showalertView(style: .alert, title: "确定退出么", message: "您还未完善个人信息,现在退出下次进入果冻花园请用已注册的账号直接登录", cancelBtnTitle: "确定退出", touchIndex: { (index) in
            if index == 0{
                clearUserInfo()
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }, otherButtonTitles: "继续完善")
    }
    @IBAction func clickNextBtn(_ sender: UIButton) {
        
        
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
