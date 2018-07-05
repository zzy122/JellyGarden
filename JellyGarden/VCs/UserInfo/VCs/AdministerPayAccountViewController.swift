//
//  AdministerPayAccountViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class AdministerPayAccountViewController: BaseMainTableViewController {
    var indexTag:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "管理支付宝账号"
        tableView.register(UINib.init(nibName: "PayAccountTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PayAccountTableViewCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.edgesForExtendedLayout = UIRectEdge.bottom
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBtn.isHidden = false
        rightBtn.setTitle("添加", for: UIControlState.normal)
        rightBtn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
    }
    override func clickRightBtn() {
        RootNav().pushViewController(ADDPayCountViewController(), animated: true)
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
extension AdministerPayAccountViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PayAccountTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PayAccountTableViewCell", for: indexPath) as! PayAccountTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.imageTag.image = imageName(name: "未选中")
        cell.contentbackView.layer.cornerRadius = 5
        cell.contentbackView.clipsToBounds = true
        if indexPath.row == indexTag
        {
            cell.imageTag.image = imageName(name: "选中")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexTag = indexPath.row
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
