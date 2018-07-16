//
//  WalletViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class WalletViewController: BaseTableViewController,ResponderRouter {
    var modelAry:[Any] = []
    
    
    var aplayPayData:[AlipayModel]?
    
    var currentAliPayModel:AlipayModel?
    
    lazy var alertAction:AlipayAction = {
       let action = AlipayAction.init(showType: .bottom, view: self.bottomView, windowView: self.navigationController?.view)
        return action
    }()
    
    var aliPayView:AlipayBottomAlertView?
    
    lazy var bottomView:UIView = {
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: 340))
        view1.backgroundColor = UIColor.white
        self.aliPayView = AlipayBottomAlertView.createAlipayBottomAlertView()
        self.aliPayView?.frame = view1.bounds
        self.reloadAmountData()
        self.aliPayView?.backStr = {[weak self] backStr in
        
            DebugLog(message: "确定支付\(backStr)")
            
            self?.alertAction.hiddenTheView()
            
            self?.payAccount(amountStr: backStr)
            
            
        }
        
        
        self.aliPayView?.clickChageAccount = {[weak self] in
             
            self?.alertAction.hiddenTheView()
            let vc = AdministerPayAccountViewController()
            vc.backSelectModel = {model in
                self?.currentAliPayModel = model

            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        view1.addSubview(self.aliPayView!)
        return view1
    }()
    lazy var headerView:WalletHeaderView = {
        let view1 = WalletHeaderView.createWalletHeaderView()
        let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 250))
        
        backView.backgroundColor = UIColor.clear
        backView.addSubview(view1!)
        self.tableView.tableHeaderView = backView
        view1?.frame = backView.bounds
        
        return view1!
    }()

    lazy var ruleView:UIView = {
        let view1 = DepositRuleView.createRuleView()
        let backView = UIView.init(frame: CGRect.init(x: 25, y: (ScreenHeight - 160) / 2.0, width: ScreenWidth - 50, height: 160))
        view1.clickClose {
            self.alertAction.hiddenTheView()
        }
        backView.backgroundColor = UIColor.clear
        backView.addSubview(view1)
        return backView
        
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱包"
        self.headerView.isHidden = false
        tableView.register(UINib.init(nibName: "WalletTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WalletTableViewCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RootViewController?.hideTheTabbar()
        rightBtn.setTitle("提现规则", for: UIControlState.normal)
        rightBtn.isHidden = false
        rightBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        getAlipayModel()
    }
    func payAccount(amountStr:String)
    {
        guard amountStr.count > 0 else
        {
            return
        }
        let amountTag = Float.init(amountStr)
        guard let  amount = amountTag,amount > Float(0) else
        {
           return
        }
        let params:[String:Any] = ["amount":Int(amount),"user_id": CurrentUserInfo?.data?.user_id ?? "","alipay_account":currentAliPayModel?.alipay_account_id ?? ""]
        TargetManager.share.withdrawal(params: params) { (success, error) in
            if success {
                //余额查询
               self.reloadAmountData()
                
            }
        }
        
        
    }
    func reloadAmountData()
    {
        updateUserInfo(complection: { (result) in
            self.headerView.reloadData()//支付成功刷新余额信息
            self.aliPayView?.maxAmountLab.text = "最多可提现¥\(self.headerView.depositLab.text ?? "0.00")"
        })
    }
    func getAlipayModel()
    {
        TargetManager.share.getAlipayAccount(params: ["user_id":CurrentUserInfo?.data?.user_id ?? ""]) { (models, error) in
            if (models?.count ?? 0) > 0
            {
                self.aplayPayData = models
            }
            else {
                
            }
        }
    }
    override func clickRightBtn() {
        alertAction.showType = .center
        alertAction.showView = ruleView
        alertAction.backView.isUserInteractionEnabled = false
        alertAction.showTheView()
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
extension WalletViewController
{
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == ClickDeposit {//点击提现
            aliPayView?.amountTextFiled.text = ""
            if (self.aplayPayData?.count ?? 0) == 0
            {
                AlertViewCoustom().showalertView(style: UIAlertControllerStyle.alert, title: alertWarmTitle, message: "你还未添加支付宝账号", cancelBtnTitle: "取消", touchIndex: { (index) in
                    if index == 1
                    {
                        self.navigationController?.pushViewController(ADDPayCountViewController(), animated: true)
                    }
                }, otherButtonTitles: "去添加")
            }
            else
            {
                if currentAliPayModel == nil
                {
                    currentAliPayModel = self.aplayPayData?.first
                }
                alertAction.showType = .bottom
                alertAction.showView = bottomView
                aliPayView?.model = self.currentAliPayModel
                alertAction.backView.isUserInteractionEnabled = true
                alertAction.showTheView()
            }
            
        }
       
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelAry.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WalletTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell", for: indexPath) as! WalletTableViewCell
        
        return cell
        
    }
    
    
}
