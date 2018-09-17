//
//  DepositManagerViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class DepositManagerViewController: BaseMainTableViewController {
    lazy var nolikesView:UIView = {
        let viewback = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: self.view.frame.height))
        let view1 = NoDepositRecord.createNoDepositRecord()
        view1.frame = viewback.bounds
        viewback.backgroundColor = UIColor.clear
        return viewback
    }()
    var dataAry:[DepositListModel] = []
    {
        didSet{
            if dataAry.count > 0
            {
                self.tableView.tableFooterView = self.nolikesView
                return
            }
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.requestModels()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订金管理"
        self.edgesForExtendedLayout = UIRectEdge.bottom
        tableView.register(UINib.init(nibName: "DepositManagerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DepositManagerTableViewCell")
        tableView.register(UINib.init(nibName: "NormalDepositManagerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NormalDepositManagerTableViewCell")
//        tableView.register(UINib.init(nibName: "WomanDepositManagerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WomanDepositManagerTableViewCell")
        // Do any additional setup after loading the view.
    }
    func requestModels()
    {
        TargetManager.share.requestDepositList { (models, error) in
            if let model1 = models
            {
                 self.dataAry = model1
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
extension DepositManagerViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataAry.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataAry[indexPath.row]
        
        if model.status == DepositStatus().pay_NoSure
        {
            let cell1:DepositManagerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DepositManagerTableViewCell", for: indexPath) as! DepositManagerTableViewCell
            cell1.model = model
            return cell1
        }
        else
        {
            let cell1:NormalDepositManagerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NormalDepositManagerTableViewCell", for: indexPath) as! NormalDepositManagerTableViewCell
            cell1.model = model
            return cell1
        }
        
        
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dataAry.count > 0
        {
           return 15
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataAry[indexPath.row]
        
        if model.status == DepositStatus().pay_NoSure
        {
            return 185
        }
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(DepositDetailViewController(), animated: true)
    }
}
extension DepositManagerViewController:ResponderRouter
{
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == DepositManagerBottomBtn
        {
            guard let model:DepositListModel = info as? DepositListModel else
            {
                return
            }
            TargetManager.share.requestSureDeposit(param: ["order_sn":model.order_num ?? "" , "is_refund":0]) { (success) in
                if success
                {
                    self.requestModels()
                }
            }
            
//            DebugLog(message: "点击了按钮")
        }
    }
}
