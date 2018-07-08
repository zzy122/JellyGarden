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
    var dataAry:[Any] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订金管理"
        self.edgesForExtendedLayout = UIRectEdge.bottom
        tableView.register(UINib.init(nibName: "DepositManagerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DepositManagerTableViewCell")
        tableView.register(UINib.init(nibName: "DepositRefundTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DepositRefundTableViewCell")
        // Do any additional setup after loading the view.
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
        let cell:DepositRefundTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DepositRefundTableViewCell", for: indexPath) as! DepositRefundTableViewCell
//        let cell:DepositManagerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DepositManagerTableViewCell", for: indexPath) as! DepositManagerTableViewCell
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dataAry.count > 0
        {
           return 15
        }
        return 0
        
    }
}
