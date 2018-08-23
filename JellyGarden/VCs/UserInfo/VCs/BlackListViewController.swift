//
//  BlackListViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/8.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class BlackListViewController: BaseMainTableViewController,ResponderRouter {
    var blackModels:[BlackModel]? {
        didSet{
            if blackModels?.count == 0
            {
                alertHud(title: "你还没有拉黑其他人")
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "黑名单"
        self.tableView.register(UINib.init(nibName: "BlacklistTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BlacklistTableViewCell")
        self.getListData()
        // Do any additional setup after loading the view.
    }
    func getListData()
    {
        let param:[String:Any] = ["user_id":CurrentUserInfo?.user_id ?? "","report_type":0]
        TargetManager.share.userReportList(params: param) { (models, error) in
            if error == nil{
                self.blackModels = models
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
extension BlackListViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return blackModels?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BlacklistTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BlacklistTableViewCell", for: indexPath) as! BlacklistTableViewCell
        cell.model = blackModels?[indexPath.section]
        cell.tag = indexPath.section
        return cell
    }
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == ClickCancelBlack {
            guard let index = info as? Int else
            {
                return
            }
            TargetManager.share.cancelUserReportRequest(report_user_id: blackModels?[index].user_id ?? "", complection: { (success) in
                if success {
                    self.blackModels?.remove(at: index)
                }
            })
            
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vie1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 15))
        vie1.backgroundColor = UIColor.clear
        return vie1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
