//
//  WomenPersonInfoViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/15.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ManPersonInfoViewController: BaseTableViewController,ResponderRouter {
    var showType:LookUserInfotype? {
        if self.userInfoModel?.data?.permission == permissionAry[3] {
            return LookUserInfotype.stealth
        }
        else if self.userInfoModel?.data?.permission == permissionAry[2] {
            return LookUserInfotype.validation
        }
        else if self.userInfoModel?.data?.permission == permissionAry[1] {
            return LookUserInfotype.payphoto
        }
        else  {
            return LookUserInfotype.pubilic
        }
    }
    var broadcastAry:[lonelySpeechDetaileModel] = []
    
    var userInfoModel:UserModel? {
        didSet{
            if userInfoModel?.data?.likes?.contains(CurrentUserInfo?.data?.user_id ?? "") == true
            {
                self.collectionImageStr = "赞-实"
            }
        }
    }
    lazy var footerView:PermissionLookView = {
        let foot = PermissionLookView.createPermissionLookView()
        let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: self.tableView.frame.height - self.headerView.frame.height))
        backView.backgroundColor = UIColor.clear
        foot?.frame = backView.bounds
        backView.addSubview(foot!)
        self.tableView.tableFooterView = backView
        return foot!
        
    }()
    var collectionImageStr:String = ""
    {
        didSet{
            self.bottomView.collectionImage.image = imageName(name: collectionImageStr)
        }
    }
    lazy var bottomView:ManUserInfoTabbar = {
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: ScreenHeight - 55, width: ScreenWidth, height: 55))
        let bottom = ManUserInfoTabbar.createManUserInfoTabbar()
        bottom?.frame = view1.bounds
        view1.backgroundColor = UIColor.clear
        view1.addSubview(bottom!)
        self.view.addSubview(view1)
        return bottom!
    }()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    lazy var headerView:ManpersonInfoHeader = {
        var intege = getLines(ary: userInfoModel?.data?.custom_photos, veryCount: 4)
        let view1 = ManpersonInfoHeader.createManpersonInfoHeader()
        let backView = UIView()
        backView.backgroundColor = UIColor.clear
        backView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 330 + CGFloat(intege) * (BodyImageHeight + 8))
        if self.showType == .validation
        {
            backView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 260)
            view1?.bottomView.isHidden = true
        }
        view1?.frame = backView.bounds
        
        backView.addSubview(view1!)
        self.tableView.tableHeaderView = backView
        return view1!
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView.isHidden = false
        self.bottomView.isHidden = false
        self.headerView.userModel = self.userInfoModel?.data
        self.tableView.register(UINib.init(nibName: "ConfessionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfessionTableViewCell")
         tableView.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: ScreenHeight - self.bottomView.frame.height)
        if self.broadcastAry.count == 0 && showType == .pubilic
        {
            self.createfootView()
        }
        else if showType == .validation//访问权限
        {
            self.footerView.isHidden = false
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RootViewController?.hideTheTabbar()
        rightBtn.isHidden = false
        rightBtn.setTitle("...", for: UIControlState.normal)
        rightBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    override func clickRightBtn() {
        AlertViewCoustom().showalertView(style: UIAlertControllerStyle.actionSheet, title: nil, message: nil, cancelBtnTitle: "取消", touchIndex: { (index) in
            
            if index == 1//拉黑
            {
                
                
                TargetManager.share.userReportRequest(params: ["user_id": CurrentUserInfo?.data?.user_id ?? "","report_user_id": self.userInfoModel?.data?.user_id ?? "","report_type":0], complection: { (success) in
                    
                })
            }
            else if index == 2//举报
            {
                TargetManager.share.userReportRequest(params: ["user_id": CurrentUserInfo?.data?.user_id ?? "","report_user_id": self.userInfoModel?.data?.user_id ?? "","report_type":1], complection: { (success) in
                    
                })
            }
            
        }, otherButtonTitles: "拉黑", "举报")
    }
    func getBroastData()
    {
        TargetManager.share.requestUserAllBroadcast(userid: userInfoModel?.data?.user_id ?? "") { (models, error) in
            if error == nil {
                self.broadcastAry = models
            }
        }
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

    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == ClickUserInfoTabbar {
            guard let btnTag = info as? ClickUserInfoTabbarBtntype
                else{return}
            switch btnTag {
            case .collection://点击收藏
                let params = ["like_garden_user_id":self.userInfoModel?.data?.user_id ?? "", "user_id":CurrentUserInfo?.data?.user_id ?? ""]
                TargetManager.share.gardensUserLikes(params: params, complection: { (success) in
                    if success {
                        self.collectionImageStr = (self.collectionImageStr == "赞-实") ? "收藏" : "赞-实"
                    }
                })
                
                break
            case .chat://点击 私聊
                let vc = ChatRoomViewController()
                vc.targetId = userInfoModel?.data?.user_id
                self.navigationController?.pushViewController(vc, animated: true)
                
                break
            case .prase://点击评价
                AlertAction.share.showCommentStarView(imageUrl: userInfoModel?.data?.avatar, nikeStr: userInfoModel?.data?.nickname) { (poCount, playCount, tasteCount, cleanCount, agliCount, mothCount) in
                    
                    let param:[String:Any] = ["comment_user_id":self.userInfoModel?.data?.user_id ?? "","publisher_user_id":CurrentUserInfo?.data?.user_id ?? "","politeness":playCount,"funny":playCount,"generous":tasteCount,"tidy":cleanCount,"decisive":agliCount,"harassment":mothCount]
                    TargetManager.share.commentUser(params: param, complection: { (success) in

                    })
                    
                    
                }
                
                break
            case .money://点击定金
                
                break
                
            }
        }
        if name == ClickPermissionBtn
        {
            DebugLog(message: "点击了申请查看")
        }
        
        
    }
    override func viewDidLayoutSubviews() {
        
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
        if showType == .pubilic
        {
            return 1
        }
        return 0
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
        if self.showType == .pubilic
        {
           return 40
        }
        return 0
    }
    
    
    
}
