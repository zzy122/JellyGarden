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
        self.navigationController?.pushViewController(FillInformationThirdViewController(), animated: true)
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
