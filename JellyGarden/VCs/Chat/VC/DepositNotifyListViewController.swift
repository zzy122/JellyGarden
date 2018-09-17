//
//  DepositNotifyListViewController.swift
//  JellyGarden
//
//  Created by kfzs on 2018/9/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class DepositNotifyListViewController: BaseTableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "电台广播"
        self.requestDepositNotify()
        tableView.register(UINib.init(nibName: "MessageBroastTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MessageBroastTableViewCell")
        // Do any additional setup after loading the view.
    }
    var models:[DepositNoticeModel]?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func requestDepositNotify()
    {
        TargetManager.share.requestDepositNoticeModels { (models, error) in
            self.models = models
            self.tableView.reloadData()
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
extension DepositNotifyListViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MessageBroastTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MessageBroastTableViewCell", for: indexPath) as! MessageBroastTableViewCell
        //        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        //        cell.nickName.text = "zzy"
        //        cell.desCriptionLab.text = "在北京发布了一条约会广播"
        cell.model2 = self.models?[indexPath.row]
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
