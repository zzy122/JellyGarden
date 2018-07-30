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
    let dataDic:[String:Any]? = { 
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
    
        switch indexPath.row {
        case 0://广播
            let ary = APPNotyfyDealwith.share.getNotifyData(key: Radio_APP_BroadcastNotify)
            if let dicAry = ary, dicAry.count > 0
            {
                let model = JSONDeserializer<NotifyDataModel>.deserializeFrom(dict: dicAry.first)
                cell.messageDetail.text = "\(model?.nickname ?? "")在\(model?.city ?? "")发了一条广播"
            }
            break
        case 1://收益提醒
            break
        case 2://郭东花园
            break
        case 3://联系方式
            let ary = APPNotyfyDealwith.share.getNotifyData(key: Contact_APP_StyleNotify)
            if let dicAry = ary, dicAry.count > 0
            {
                let model = JSONDeserializer<NotifyDataModel>.deserializeFrom(dict: dicAry.first)
                cell.messageDetail.text = "\(model?.nickname! ?? "")查看了你的联系方式"
            }
            break
        case 4://查看申请
            let ary = APPNotyfyDealwith.share.getNotifyData(key: Check_APP_ApplyNotify)
            if let dicAry = ary, dicAry.count > 0
            {
                let model = JSONDeserializer<NotifyDataModel>.deserializeFrom(dict: dicAry.first)
                cell.messageDetail.text = "\(model?.nickname! ?? "")请求查看你的资料"
            }
        
            break
        case 5://评价通知
            break
        default://定金通知
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
            break
        default:
            break
        }
    }
}
