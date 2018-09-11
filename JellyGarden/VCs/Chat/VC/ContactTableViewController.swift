//
//  ContactTableViewController.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
class ContactTableViewController: BaseMainTableViewController {
//    let models:[NotifyDataModel]? =
//    {
//        let ary = APPNotyfyDealwith.share.getNotifyData(key: Contact_APP_StyleNotify)
//        return (JSONDeserializer<NotifyDataModel>.deserializeModelArrayFrom(array: ary) as? [NotifyDataModel])
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "联系方式"
        self.tableView.register(UINib.init(nibName: "ContactTableViewCell"
            , bundle: Bundle.main), forCellReuseIdentifier: "ContactTableViewCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
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
extension ContactTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
//        let model = self.models![indexPath.row]
//        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
extension ContactTableViewController:ResponderRouter
{
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        switch name {
        case ClickComent_NotifyBtn:
//            let model:NotifyDataModel = info as! NotifyDataModel
//            if model.sex == 1
//            {
//                
//                let vc = PersonInfoViewController()
//                TargetManager.share.getDetailUserInfo(userid: model.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
//                    guard let user = userinfo else{
//                        return
//                    }
//                    user.distance = model.distance
//                    vc.userInfoModel = user
//                    RootNav().pushViewController(vc, animated: true)
//                })
//            }
//            else
//            {
//                let vc = ManPersonInfoViewController()
//                TargetManager.share.getDetailUserInfo(userid: model.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
//                    guard let user = userinfo else{
//                        return
//                    }
//                    user.distance = model.distance
//                    vc.userInfoModel = user
//                    RootNav().pushViewController(vc, animated: true)
//                })
//            }
            break
        default:
            break
        }
    }
}
