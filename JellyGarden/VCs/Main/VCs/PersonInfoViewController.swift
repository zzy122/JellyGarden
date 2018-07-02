//
//  PersonInfoViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class PersonInfoViewController: BaseTableViewController,ResponderRouter {
    var leftTitles:[String] = ["她的广播","个人介绍","约会节目","约会条件","微信","风格","语言","感情"]
    var rightTitles:[String] = ["","","","","","","",""]
    
    
    lazy var bottomView:UserInfoTabbar = {
        let bottom:UserInfoTabbar = UserInfoTabbar.createUserInfoTabbar()!
        bottom.tagFrame = CGRect.init(x: 0, y: ScreenHeight - 55, width: ScreenWidth, height: 55)
        
        self.view.addSubview(bottom)
        return bottom
    }()
    var collectionImageStr:String = ""
    {
        didSet{
           self.bottomView.collectionImage.image = imageName(name: collectionImageStr)
        }
    }
    
    var userInfoModel:UserModel? {
        didSet{
            var contact:String?
            if let str = userInfoModel?.data?.contact_wechat,str.count > 0 {
                contact = str
                self.leftTitles = ["她的广播","个人介绍","约会节目","约会条件","微信","风格","语言","感情"]
            }
            else
            {
                contact = userInfoModel?.data?.contact_qq
                self.leftTitles = ["她的广播","个人介绍","约会节目","约会条件","QQ","风格","语言","感情"]
            }
            
            self.rightTitles = ["",continueString(strAry: userInfoModel?.data?.tags,separetStr:"  "),continueString(strAry: userInfoModel?.data?.appointment_program,separetStr:"  "),continueString(strAry: userInfoModel?.data?.appointment_condition,separetStr:"  "),contact!,continueString(strAry: userInfoModel?.data?.dress_style,separetStr:"  "),continueString(strAry: userInfoModel?.data?.language,separetStr:"  "),userInfoModel?.data?.emotion_status ?? ""]
            if let troduces = userInfoModel?.data?.tags,troduces.count > 0 {
                self.rightTitles.append(continueString(strAry: troduces,separetStr:"  "))
            }
            self.tableView.reloadData()
            if userInfoModel?.data?.likes?.contains((CurrentUserInfo?.data?.user_id)!) == true
            {
               self.collectionImageStr = "赞-实"
            }
        }
    }
    override func viewDidLayoutSubviews() {

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    lazy var headerView:PersonalInfoHeader = {
        var intege = getLines(ary: self.userInfoModel?.data?.photos, veryCount: 4)
        let view1 = PersonalInfoHeader.createPersonalInfoHeader()
        let backView = UIView()
        backView.backgroundColor = UIColor.clear
        backView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 320 + CGFloat(intege) * (BodyImageHeight + 8))
        view1?.frame = backView.bounds
        backView.addSubview(view1!)
        view1?.userModel = self.userInfoModel?.data
        self.tableView.tableHeaderView = backView
        
        return view1!
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.isHidden = false
        
        self.bottomView.isHidden = false
        // Do any additional setup after loading the view.
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
                self.gotoChatVC()
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
    func gotoChatVC() {
        let vc = ChatRoomViewController.init(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: userInfoModel?.data?.user_id)
//        vc?.targetId = "5b2f539af0fae056967dc6fb"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RootViewController?.hideTheTabbar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func showContactAlert() {
        AlertAction.share.showContactAlert(title: "她的联系方式", contactTypeStr: leftTitles[4], contactText: rightTitles[4], introduceStr: rightTitles[1]) { (type) in
            switch type {
            case .close:
                break
            case .sure:
                self.gotoChatVC()
                break
            case .report:
                break
                
            }
        }
    }
    func showSubscriptionAlert() {//发送订金
        AlertAction.share.showAlertView(type: UIKeyboardType.numberPad, title: "订金金额", placeHodel: "请输入金额", detailTitle: "订金暂存在平台上,在用户中心课题查看", detailImage: imageName(name: "提示")) { (clicksure, text) in
            if clicksure {//点击确定
                
            }
        }
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
extension PersonInfoViewController
{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.leftTitles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let str = self.leftTitles[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "PersonInfoViewController")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "PersonInfoViewController")
            
        }
        if indexPath.row == 0
        {
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        cell?.textLabel?.text = str;
        cell?.detailTextLabel?.text = self.rightTitles[indexPath.row]
        return cell!
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 55))
        view1.backgroundColor = UIColor.clear
        return view1
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 20))
        view1.backgroundColor = UIColor.clear
        return view1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 55
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = UserBroadcastListViewController()
            vc.userid = userInfoModel?.data?.user_id ?? ""
            
            RootNav().pushViewController(vc, animated: true)
            
            break
        case 1:
            let vc = WCLRecordVideoVC()
            vc.recordVideoResult({ (path) in
                guard let vidioStr = path, vidioStr.count > 0 else{
                    return
                }
                DebugLog(message: "\(vidioStr)")
            })
            
            RootNav().present(vc, animated: true, completion: {
                
            })
            break
        case 2:
            break
        case 3:
            break
        case 4:
            showContactAlert()
            break
        case 5:
            break
        case 6:
            break
        default:
            break
        }
    }
}


