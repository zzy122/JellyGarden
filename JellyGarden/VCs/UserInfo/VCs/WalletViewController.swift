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
    lazy var headerView:WalletHeaderView = {
        let view1 = WalletHeaderView.createWalletHeaderView()
        let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 250))
        
        backView.backgroundColor = UIColor.clear
        backView.addSubview(view1!)
        self.tableView.tableHeaderView = backView
        view1?.frame = backView.bounds
        view1?.moneyLab.text = "0.00"
        view1?.depositLab.text = "0.00"
        return view1!
    }()
    let backView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        view.backgroundColor = UIColor.black
        view.alpha = 0.0
        
        return view
    }()
    lazy var ruleView:UIView = {
        let view1 = DepositRuleView.createRuleView()
        let backView = UIView.init(frame: CGRect.init(x: 25, y: (ScreenHeight - 160) / 2.0, width: ScreenWidth - 50, height: 160))
        view1.clickClose {
            self.hiddenTheView(view: backView)
        }
        backView.backgroundColor = UIColor.clear
        backView.addSubview(view1)
        return backView
        
    }()
    func showBackView()  {
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backView.alpha = 0.3
        UIView.commitAnimations()
    }
    func hiddenTheView(view:UIView?) {
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        self.backView.alpha = 0.0
        UIView.commitAnimations()
        view?.isHidden = false
        view?.removeFromSuperview()
        
    }
    func showTheView(View:UIView?) {
        
        self.showBackView()
        let animation:CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.duration = 0.30;
        animation.isRemovedOnCompletion = true;
        animation.fillMode = kCAFillModeForwards;
        let valus = NSMutableArray()
        valus.add(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        valus.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)))
        valus.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = valus as? [Any]
        View?.layer.add(animation, forKey: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱包"
        self.headerView.isHidden = false
        tableView.register(UINib.init(nibName: "WalletTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WalletTableViewCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBtn.setTitle("提现规则", for: UIControlState.normal)
        rightBtn.isHidden = false
        rightBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        
    }
    override func clickRightBtn() {
        UIApplication.shared.keyWindow?.addSubview(backView)
        UIApplication.shared.keyWindow?.addSubview(ruleView)
        
        self.showTheView(View: self.ruleView)
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
