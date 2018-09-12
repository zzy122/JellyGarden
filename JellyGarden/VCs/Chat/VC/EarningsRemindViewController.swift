//
//  EarningsRemindViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/9.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class EarningsRemindViewController: BaseMainTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收益提醒"
        self.requesEarningsRemindModel()
        tableView.register(UINib.init(nibName: "MessageBroastTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MessageBroastTableViewCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RootViewController?.hideTheTabbar()
    }
    var models:[RemindNoticeModel]?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func requesEarningsRemindModel()
    {
        TargetManager.share.requestRemindNotice { (models, error) in
            self.models = models
            self.tableView.reloadData()
        }
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
extension EarningsRemindViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MessageBroastTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MessageBroastTableViewCell", for: indexPath) as! MessageBroastTableViewCell
        cell.model1 = models?[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        RootViewController?.selectedIndex = 1
        self.navigationController?.popViewController(animated: false)
    }
}
