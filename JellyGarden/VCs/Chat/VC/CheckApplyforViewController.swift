//
//  CheckApplyforViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/9.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
class CheckApplyforViewController: BaseMainTableViewController {
    var models:[SeeApplyModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "查看申请"
        self.tableView.register(UINib.init(nibName: "ApplayCheckTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ApplayCheckTableViewCell")
        self.requesCheckApplyModel()
        // Do any additional setup after loading the view.
    }
    func requesCheckApplyModel()
    {
        TargetManager.share.requestSeeApply { (models, error) in
            self.models = models
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RootViewController?.hideTheTabbar()
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
extension CheckApplyforViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ApplayCheckTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ApplayCheckTableViewCell", for: indexPath) as! ApplayCheckTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
//        cell.model = self.models?[indexPath.section]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 20))
        view.backgroundColor = UIColor.clear
        return view
    }
    
}
