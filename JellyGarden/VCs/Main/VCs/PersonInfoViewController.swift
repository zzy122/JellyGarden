//
//  PersonInfoViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
enum LookUserInfotype {
    case pubilic;//公开
    case payphoto;//付费相册
    case validation;//设置查看权限
    case stealth;//隐身
}
var permissionAry:[String] = [ "公开","查看相册付费","查看前需要通过我的验证","隐身"]

class PersonInfoViewController: BaseTableViewController,ResponderRouter {
    var isWeichat:Bool = true
    var leftTitles:[String] = ["她的广播","个人介绍","约会节目","约会条件","微信","风格","语言","感情"]
    var rightTitles:[String] = ["","","","","","","",""]
    
    var showType:LookUserInfotype? {
        if self.userInfoModel?.user_id == CurrentUserInfo?.user_id
        {
            return LookUserInfotype.pubilic
        }
        if self.userInfoModel?.permission == permissionAry[3] {
            return LookUserInfotype.stealth
        }
        else if self.userInfoModel?.permission == permissionAry[2] {
            return LookUserInfotype.validation
        }
        else if self.userInfoModel?.permission == permissionAry[1] {
           return LookUserInfotype.payphoto
        }
        else  {
           return LookUserInfotype.pubilic
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
    
    lazy var bottomView:UserInfoTabbar = {
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: ScreenHeight - 55, width: ScreenWidth, height: 55))
        view1.backgroundColor = UIColor.clear
        let bottom:UserInfoTabbar = UserInfoTabbar.createUserInfoTabbar()!

        bottom.frame = view1.bounds
        view1.addSubview(bottom)
        self.view.addSubview(view1)
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
            if let str = userInfoModel?.contact_wechat,str.count > 0 {
                contact = str
                self.leftTitles = ["她的广播","个人介绍","约会节目","约会条件","微信","风格","语言","感情"]
            }
            else
            {
                contact = userInfoModel?.contact_qq
                self.leftTitles = ["她的广播","个人介绍","约会节目","约会条件","QQ","风格","语言","感情"]
                isWeichat = false
            }
            
            self.rightTitles = ["",continueString(strAry: userInfoModel?.tags,separetStr:"  "),continueString(strAry: userInfoModel?.appointment_program,separetStr:"  "),continueString(strAry: userInfoModel?.appointment_condition,separetStr:"  "),contact!,continueString(strAry: userInfoModel?.dress_style,separetStr:"  "),continueString(strAry: userInfoModel?.language,separetStr:"  "),userInfoModel?.emotion_status ?? ""]
            if let troduces = userInfoModel?.tags,troduces.count > 0 {
                self.rightTitles.append(continueString(strAry: troduces,separetStr:"  "))
            }
            self.tableView.reloadData()
            if userInfoModel?.likes?.contains((CurrentUserInfo?.user_id)!) == true
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
        var intege = getLines(ary: self.userInfoModel?.custom_photos, veryCount: 4)
        let view1 = PersonalInfoHeader.createPersonalInfoHeader()
        let backView = UIView()
        backView.backgroundColor = UIColor.clear
        backView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 330 + CGFloat(intege) * (BodyImageHeight + 8))
        if self.showType == .validation//查看权限 只有头像信息
        {
             backView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 260 )
            view1?.centerContentViewHeight.constant = 0
            view1?.centerContentView.isHidden = true
            view1?.ImageContentView.isHidden = true
        }
        
        view1?.frame = backView.bounds
        backView.addSubview(view1!)
        view1?.userModel = self.userInfoModel
        self.tableView.tableHeaderView = backView
        
        return view1!
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.isHidden = false
        
        self.bottomView.isHidden = false
        
        tableView.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: ScreenHeight - self.bottomView.frame.height)
        if self.showType == .validation
        {
            self.footerView.isHidden = false
        }
       
        
        
        // Do any additional setup after loading the view.
    }
    
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == ClickUserInfoTabbar {
            guard let btnTag = info as? ClickUserInfoTabbarBtntype
            else{return}
            switch btnTag {
            case .collection://点击收藏
                let params = ["like_userid":self.userInfoModel?.user_id ?? "", "user_id":CurrentUserInfo?.user_id ?? ""]
                TargetManager.share.gardensUserLikes(params: params, complection: { (success) in
                    if success {
                        self.collectionImageStr = (self.collectionImageStr == "赞-实") ? "收藏" : "赞-实"
                    }
                })
                break
            case .chat://点击 私聊
                TargetManager.share.requestPrivateChat(param: ["user_id":CurrentUserInfo?.user_id ?? "","chat_userid":self.userInfoModel?.user_id ?? ""]) { (success) in
                    if success
                    {
                         self.gotoChatVC()
                    }
                }
            case .prase://点击评价
                AlertAction.share.showCommentStarView(imageUrl: userInfoModel?.avatar, nikeStr: userInfoModel?.nickname) { (poCount, playCount, tasteCount, cleanCount, agliCount, mothCount) in
                    let str = "\(commentAry[0]):\(poCount);\(commentAry[1]):\(playCount);\(commentAry[2]):\(tasteCount);\(commentAry[3]):\(cleanCount);\(commentAry[4]):\(agliCount);\(commentAry[5]):\(mothCount);"
                    let param:[String:Any] = ["asses_userid":self.userInfoModel?.user_id ?? "","userid":CurrentUserInfo?.user_id ?? "","user_assoss":str]
                    TargetManager.share.commentUser(params: param, complection: { (success) in
                        
                    })
//                    DebugLog(message: "poCount:\(poCount)playCount:\(playCount)tasteCount:\(tasteCount)cleanCount:\(cleanCount)agliCount:\(agliCount)mothCount:\(mothCount)")
                }
                
                break
            case .money://点击定金
                
                break
                
            }
        }
        if name == ClickPermissionBtn
        {
            DebugLog(message: "点击了申请查看")
            
            TargetManager.share.applayToDetail(params: ["user_id":CurrentUserInfo?.user_id ?? "", "view_user_id":userInfoModel?.user_id ?? ""]) { (success) in
                if success
                {
                    
                }
            }
        }
    }
    func gotoChatVC() {
        
        
        
        let vc = ChatRoomViewController.init(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: userInfoModel?.user_id)
        vc?.targetId = userInfoModel?.user_id
        RCIM.shared().userInfoDataSource.getUserInfo(withUserId: userInfoModel?.user_id) { (info) in
            vc?.title = info?.name
            self.navigationController?.pushViewController(vc!, animated: true)
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
                TargetManager.share.userReportRequest(params: ["user_id": CurrentUserInfo?.user_id ?? "","report_user_id": self.userInfoModel?.user_id ?? "","report_type":0], complection: { (success) in
                    if (success)
                    {
                        alertHud(title: "已加入黑名单")
                    }
                })
            }
            else if index == 2//举报
            {
                TargetManager.share.userReportRequest(params: ["user_id": CurrentUserInfo?.user_id ?? "","report_user_id": self.userInfoModel?.user_id ?? "","report_type":1], complection: { (success) in
                    
                })
            }
            
        }, otherButtonTitles: "拉黑", "举报")
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
        AlertAction.share.showAlertView(type: UIKeyboardType.numberPad, title: "订金金额", placeHodel: "请输入金额",textStr:nil, detailTitle: "订金暂存在平台上,在用户中心课题查看", detailImage: imageName(name: "提示")) { (clicksure, text) in
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
        if self.showType != .validation{
           return 1
        }
        return 0
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
        cell?.accessoryType = UITableViewCellAccessoryType.none
        cell?.accessoryView = nil
        if indexPath.row == 0
        {
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
       
        cell?.textLabel?.text = str;
        cell?.detailTextLabel?.text = self.rightTitles[indexPath.row]
        if 4 == indexPath.row
        {
            let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 26))
            btn.setTitle("点击查看", for: UIControlState.normal)
            btn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
            btn.layer.cornerRadius = 13
            btn.titleLabel?.font = kFont_system12
            btn.layer.borderColor = APPCustomBtnColor.cgColor
            btn.layer.borderWidth = 1.0
            btn.addTarget(self, action: #selector(clickCheckContact(sender:)), for: UIControlEvents.touchUpInside)
            cell?.accessoryView = btn
            cell?.detailTextLabel?.text = nil
        }
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
            vc.userid = userInfoModel?.user_id ?? ""
            
            RootNav().pushViewController(vc, animated: true)
            
            break
        case 1:
            
            break
        case 2:
            break
        case 3:
            break
        case 4:
           
            break
        case 5:
            break
        case 6:
            break
        default:
            break
        }
    }
    @objc  func clickCheckContact(sender:UIButton)
    {
        CountAction().checkLimit(seekUserId: self.userInfoModel?.user_id, type: isWeichat ? LimitType.checkWeichat : LimitType.checkQQ) { (success) in
            self.showContactAlert()
        }
    }
   
}


