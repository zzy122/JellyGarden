//
//  MyLikesViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class MyLikesViewController: BaseMainTableViewController {
    
    lazy var nolikesView:UIView = {
        let viewback = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: self.view.frame.height))
        let view1 = NOCastView.createNOCastView()
        view1?.frame = viewback.bounds
        viewback.backgroundColor = UIColor.clear
        view1?.warmLab.text = "你还没有标记已喜欢的人"
        return viewback
        
    }()
    var userModels:[MainListmodel]? {
        didSet{
            guard userModels?.count != 0 else {
                self.tableView.tableFooterView = self.nolikesView
                return
            }
            self.tableView.tableFooterView = UIView()
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我喜欢的"
        self.edgesForExtendedLayout = UIRectEdge.bottom
        tableView.register(UINib.init(nibName: "MainUserListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MainUserListTableViewCellidentifier")
        self.getLikesData()
        // Do any additional setup after loading the view.
    }
    func getLikesData()
    {
        TargetManager.share.myLikesList(params: ["user_id":CurrentUserInfo?.user_id ?? ""]) { (models,error) in
            if error == nil
            {
                self.userModels = models
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
extension MyLikesViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModels?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainUserListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainUserListTableViewCellidentifier", for: indexPath) as! MainUserListTableViewCell
        cell.realityLab.layer.cornerRadius = 8.0
        
        cell.realityLab.clipsToBounds = true
        cell.userHeaderImage.layer.cornerRadius = 35
        cell.userHeaderImage.clipsToBounds = true
        
        cell.model = userModels?[indexPath.row]
        cell.heartImage.isHidden = true
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = userModels?[indexPath.row]
        if model?.sex == 1
        {
            
            let vc = PersonInfoViewController()
//            vc.showType = .validation//查看权限
            TargetManager.share.getDetailUserInfo(userid: model?.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
                guard let user = userinfo else{
                    return
                }
                vc.userInfoModel = user
                RootNav().pushViewController(vc, animated: true)
            })
        }
        else
        {
            let vc = ManPersonInfoViewController()
//            vc.showType = .validation
            TargetManager.share.getDetailUserInfo(userid: model?.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
                guard let user = userinfo else{
                    return
                }
                vc.userInfoModel = user
                RootNav().pushViewController(vc, animated: true)
            })
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
