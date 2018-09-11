//
//  SystemMessageViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/26.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
class SystemMessageViewController: BaseMainTableViewController {
    let titleAry = ["电台广播","收益提醒","果冻花园","联系方式","查看申请","评价通知","订金通知"]
    let imageStr = ["电台广播","收益提醒","果冻花园","联系方式","查看申请","评价通知","订金通知"]
    let dataDic:RelativeNotifyAry? = { 
        let dic = APPNotyfyDealwith.share.getAllNotifyDic()
        return dic
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "SystemMessageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SystemMessageTableViewCell")
        
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
        cell.messageCount.isHidden = true
        switch indexPath.row {
        case 0://广播
            cell.models = dataDic?.Radio_APP_BroadcastNotify
            break
        case 1://收益提醒
            cell.models = dataDic?.Reminding_APP_IncomeNotify
            break
        case 2://郭东花园
            cell.models = dataDic?.Official_APP_Notify
            break
        case 3://联系方式
            cell.models = dataDic?.Contact_APP_StyleNotify
            break
        case 4://查看申请
            cell.models = dataDic?.Check_APP_ApplyNotify
        
            break
        case 5://评价通知
            cell.models = dataDic?.Evaluate_APP_Notify
            break
        default://定金通知
            cell.models = dataDic?.Deposit_APP_Notify
            break
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            APPNotyfyDealwith.share.setReadedNotify(notiStr: Radio_APP_BroadcastNotify)
            RootViewController?.hideTheTabbar()
            RootNav().pushViewController(MessageBroastViewController(), animated: true)
            break
        case 1:
             APPNotyfyDealwith.share.setReadedNotify(notiStr: Reminding_APP_IncomeNotify)
            RootNav().pushViewController(EarningsRemindViewController(), animated: true)
            break
        case 2:
             APPNotyfyDealwith.share.setReadedNotify(notiStr: Official_APP_Notify)
            RootViewController?.hideTheTabbar()
            RootNav().pushViewController(APPNotifyViewController(), animated: true)

            break
        case 3:
             APPNotyfyDealwith.share.setReadedNotify(notiStr: Contact_APP_StyleNotify)
            RootViewController?.hideTheTabbar()
            RootNav().pushViewController(ContactTableViewController(), animated: true)
            break
        case 4:
             APPNotyfyDealwith.share.setReadedNotify(notiStr: Check_APP_ApplyNotify)
            RootNav().pushViewController(CheckApplyforViewController(), animated: true)
            break
        case 5:
             APPNotyfyDealwith.share.setReadedNotify(notiStr: Evaluate_APP_Notify)
            RootViewController?.hideTheTabbar()
            RootNav().pushViewController(CommentNotifyViewController(), animated: true)
            break
        case 6:
             APPNotyfyDealwith.share.setReadedNotify(notiStr: Deposit_APP_Notify)
            alertHud(title: "没看到设计图")
            break
        default:
            break
        }
    }
}
