//
//  SystemMessageViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/26.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class SystemMessageViewController: BaseMainTableViewController {
    let titleAry = ["电台广播","收益提醒","果冻花园","联系方式","查看申请","评价通知","订金通知"]
    let imageStr = ["电台广播","收益提醒","果冻花园","联系方式","查看申请","评价通知","订金通知"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "SystemMessageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SystemMessageTableViewCell")
        
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//        self.tableView.separatorColor = UIColor.groupTableViewBackground
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = UIColor.white
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
extension SystemMessageViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleAry.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SystemMessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SystemMessageTableViewCell", for: indexPath) as! SystemMessageTableViewCell
        cell.messageImage.image = imageName(name: self.imageStr[indexPath.row])
        cell.messageTitle.text = titleAry[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            RootViewController?.hideTheTabbar()
            RootNav().pushViewController(MessageBroastViewController(), animated: true)
            break
        case 1:
            RootNav().pushViewController(EarningsRemindViewController(), animated: true)
            break
        case 2:
            RootViewController?.hideTheTabbar()
            RootNav().pushViewController(APPNotifyViewController(), animated: true)

            break
        case 3:
            RootViewController?.hideTheTabbar()
            RootNav().pushViewController(ContactTableViewController(), animated: true)
            break
        case 4:
            
            RootNav().pushViewController(CheckApplyforViewController(), animated: true)
            break
        case 5:
            RootViewController?.hideTheTabbar()
            RootNav().pushViewController(CommentNotifyViewController(), animated: true)
            break
        case 6:
            alertHud(title: "没看到设计图")
//            RootViewController?.hideTheTabbar()
//            RootNav().pushViewController(CommentNoticeViewController(), animated: true)
            break
        default:
            break
        }
    }
}
