//
//  WomenPersonInfoViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/15.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ManPersonInfoViewController: BaseTableViewController,ResponderRouter {
    
    var broadcastAry:[Any] = []
    var userInfoModel:UserModel? {
        didSet{

        }
    }
    lazy var bottomView:ManUserInfoTabbar = {
        let bottom = ManUserInfoTabbar.createManUserInfoTabbar()
        bottom?.tagFrame = CGRect.init(x: 0, y: ScreenHeight - 55, width: ScreenWidth, height: 55)
        self.view.addSubview(bottom!)
        return bottom!
    }()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    let images:[String] = []
    lazy var headerView:ManpersonInfoHeader = {
        var intege = getLines(ary: images, veryCount: 4)
        let view1 = ManpersonInfoHeader.createManpersonInfoHeader()
        let backView = UIView()
        backView.backgroundColor = UIColor.clear
        backView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 260 + CGFloat(intege) * (BodyImageHeight + 8))
        view1?.frame = backView.bounds
        backView.addSubview(view1!)
        self.tableView.tableHeaderView = backView
        return view1!
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView.isHidden = false
        self.headerView.userModel = self.userInfoModel?.data
        self.tableView.register(UINib.init(nibName: "ConfessionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfessionTableViewCell")
       
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        tableView.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: self.view.frame.height - bottomView.frame.height)
        self.tableView.tableHeaderView = self.headerView
        
        self.tableView.sectionHeaderHeight = 40
        if self.broadcastAry.count == 0
        {
            self.createfootView()
        }
        else
        {
            
        }
        self.tableView.reloadData()
    }
    
    func createfootView()
    {
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
        footer.backgroundColor = UIColor.white
        let lable = creatLable(frame: CGRect.init(x: 0, y: (footer.frame.height - 20) / 2.0, width: footer.frame.width, height: 20), title: "他还没有发布广播", font: kFont_system18, textColor: UIColor.gray)
        lable.textAlignment = NSTextAlignment.center
        lable.backgroundColor = UIColor.clear
        footer.addSubview(lable)
        self.tableView.tableFooterView = footer
    }
//    override func viewDidLayoutSubviews() {
//
//
//    }
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == ClickUserInfoTabbar {
            guard let btnTag = info as? ClickUserInfoTabbarBtntype
                else{return}
            switch btnTag {
            case .collection://点击收藏
                
                break
            case .chat://点击 私聊
                let vc = ChatRoomViewController()
                vc.targetId = userInfoModel?.data?.user_id
                self.navigationController?.pushViewController(vc, animated: true)
                
                break
            case .prase://点击评价
                AlertAction.share.showCommentStarView(imageUrl: userInfoModel?.data?.avatar, nikeStr: userInfoModel?.data?.nickname) { (poCount, playCount, tasteCount, cleanCount, agliCount, mothCount) in
                    DebugLog(message: "poCount:\(poCount)playCount:\(playCount)tasteCount:\(tasteCount)cleanCount:\(cleanCount)agliCount:\(agliCount)mothCount:\(mothCount)")
                }
                
                break
            case .money://点击定金
                
                break
                
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
extension ManPersonInfoViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.broadcastAry.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfessionTableViewCell", for: indexPath) as! ConfessionTableViewCell
        cell.setDatasource(model: lonelySpeechDetaileModel())
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return caculateCellHeight(model: lonelySpeechDetaileModel())
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 40))
        section.backgroundColor = UIColor.clear
        let lable = creatLable(frame: CGRect.init(x: 10, y: 20, width: 100, height: 20), title: "他的广播", font: kFont_system14, textColor: UIColor.lightGray)
        lable.backgroundColor = UIColor.clear
        section.addSubview(lable)
        return section
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    
}
