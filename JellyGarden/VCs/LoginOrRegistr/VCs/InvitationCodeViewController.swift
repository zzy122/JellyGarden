//
//  InvitationCodeViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/6.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class InvitationCodeViewController: BaseViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var codeTextFiled: APPTextfiled!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSize.init(width: ScreenWidth, height: bottomView.frame.maxY)
    }

    @IBAction func clickOpen(_ sender: UIButton) {
        let vc = VipCenterViewController()
        vc.isHaveUserHeader = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func checkCodeBtn(_ sender: UIButton) {//查收邀请码
        
    }
    @IBAction func applyForCode(_ sender: UIButton) {//申请
        
        self.navigationController?.pushViewController(ApplayForCodeViewController(), animated: true)
    }
    @IBAction func clickSure(_ sender: UIButton) {
        guard let codeStr = self.codeTextFiled.text,codeStr.count > 0 else{
            
            alertHud(title: "请输入邀请码")
            return
        }
        let params:[String:Any] = ["user_id":CurrentUserInfo?.user_id ?? "","code":codeStr]
        
        TargetManager.share.inviteCodeBind(params: params) { (result, error) in
            if result{
                //更新用户数据
                self.navigationController?.pushViewController(ManFillInformationViewController(), animated: true)
                

                
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
