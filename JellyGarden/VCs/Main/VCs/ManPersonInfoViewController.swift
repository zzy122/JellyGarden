//
//  WomenPersonInfoViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/15.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import TZImagePickerController

class ManPersonInfoViewController: BaseTableViewController,ResponderRouter {
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
    var reportTag:Int = 0
    var broadcastAry:[lonelySpeechDetaileModel] = []
    {
        didSet{
            self.tableView.reloadData()
            if broadcastAry.count == 0 && showType == .pubilic
            {
                self.createfootView()
            }
            else if broadcastAry.count !=  0 && showType == .pubilic
            {
                self.tableView.tableFooterView = UIView()
            }
            else if showType == .validation//访问权限
            {
                self.footerView.isHidden = false
            }
        }
    }
    
    var userInfoModel:UserModel? {
        didSet{
            if userInfoModel?.is_like == true
            {
               self.collectionImageStr = "赞-实"
            }
//            if userInfoModel?.likes?.contains(CurrentUserInfo?.user_id ?? "") == true
//            {
//
//            }
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
        var intege = getLines(ary: userInfoModel?.custom_photos, veryCount: 4)
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
        self.headerView.userModel = self.userInfoModel
        self.tableView.register(UINib.init(nibName: "ConfessionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfessionTableViewCell")
         tableView.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: ScreenHeight - self.bottomView.frame.height)
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedRowHeight = 0
        self.getBroastData()
        
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
    func getBroastData()
    {
        TargetManager.share.requestUserAllBroadcast(userid: userInfoModel?.user_id ?? "") { (models, error) in
            if error == nil {
                self.broadcastAry = models?.appointment ?? []
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
                let params = ["like_userid":self.userInfoModel?.user_id ?? "", "user_id":CurrentUserInfo?.user_id ?? ""]
                TargetManager.share.gardensUserLikes(params: params, complection: { (success) in
                    if success {
                        self.collectionImageStr = (self.collectionImageStr == "赞-实") ? "收藏" : "赞-实"
                    }
                })
                
                break
            case .chat://点击 私聊
//                let vc = ChatRoomViewController()
                let vc = ChatRoomViewController.init(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: userInfoModel?.user_id)
                vc?.targetId = userInfoModel?.user_id
                RCIM.shared().userInfoDataSource.getUserInfo(withUserId: userInfoModel?.user_id) { (info) in
                    vc?.title = info?.name
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
//                let info = RCIM.shared().getUserInfoCache(userInfoModel?.user_id)
                
                
                break
            case .prase://点击评价
                AlertAction.share.showCommentStarView(imageUrl: userInfoModel?.avatar, nikeStr: userInfoModel?.nickname) { (poCount, playCount, tasteCount, cleanCount, agliCount, mothCount) in
                    
                    let param:[String:Any] = ["asses_userid":self.userInfoModel?.user_id ?? "","userid":CurrentUserInfo?.user_id ?? "","type1":playCount,"type2":playCount,"type3":tasteCount,"type4":cleanCount,"type5":agliCount,"type6":mothCount]
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
            TargetManager.share.applayToDetail(params: ["user_id":CurrentUserInfo?.user_id ?? "", "view_user_id":userInfoModel?.user_id ?? ""]) { (success) in
                if success
                {
                    
                }
            }
        }
        if name == ClickLikeChangeBtn  {//点赞
            guard let index = info as? Int else{
                return
            }
            
            let model:lonelySpeechDetaileModel = broadcastAry[index]
            let appointment_id = model.id
            /// 取消赞
            
            TargetManager.share.likeAppiont(appointment_id: appointment_id!, complection: { (complection, error) in
                if complection { //请求数据刷新
                    model.is_like = !(model.is_like ?? false)
                    if model.is_like == true
                    {
                        model.likes_count  =  (model.likes_count ?? 0) + 1
                    }
                    else
                    {
                        model.likes_count  =  (model.likes_count ?? 0) - 1
                    }
                    
                    self.reloadMyTableView(index: index, model: model)
                }
            })
        }
        if name == ClickCommentBtn {//评论
            guard let index = info as? Int else{
                return
            }
            AlertAction.share.showCommentView(clickType: { (type, str) in
                guard let text = str else{
                    return
                }
                if type == .publish{
                    
                    let model:lonelySpeechDetaileModel = self.broadcastAry[index]
                    let params = ["publisher_id":CurrentUserInfo?.user_id ?? "","content":text, "appointment_id": model.id!]
                    TargetManager.share.issueComment(appointment_id: model.id ?? "", params: params, complection: { (commentmodel, error) in
                        guard let comment = commentmodel else{
                            return
                        }
                        model.comments?.append(comment)
                        self.reloadMyTableView(index: index, model: model)
                    })
                    
                }
                
            })
        }
        if ClickEnlistBtn == name {//我要报名
            guard let index = info as? Int else{
                return
            }
            guard broadcastAry[index].user_id != CurrentUserInfo?.user_id else
            {
                alertHud(title: "不能报名本人哦")
                return
            }
            guard broadcastAry[index].sex != CurrentUserInfo?.sex else
            {
                alertHud(title: "不能报名同性别哦")
                return
            }
            
            let vc = TZImagePickerController.init(maxImagesCount: 1, delegate: self)
            vc?.allowPickingVideo = false
            vc?.allowPickingImage = true
            vc?.allowTakePicture = true
            vc?.didFinishPickingPhotosHandle = {(photos, assets, isSelectOriginalPhoto) in
                self.uploadImage(sender: photos)
                
            }
            self.present(vc!, animated: true, completion: nil)
            self.reportTag = index
        }
        
        
    }
    func reloadMyTableView(index:Int, model:lonelySpeechDetaileModel)
    {
        self.broadcastAry.remove(at: index)
        self.broadcastAry.insert(model, at: index)
        let indexPath = IndexPath.init(row: 0, section: index)
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
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
            return self.broadcastAry.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfessionTableViewCell", for: indexPath) as! ConfessionTableViewCell
        cell.setDatasource(model: self.broadcastAry[indexPath.section])
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return caculateCellHeight(model: self.broadcastAry[indexPath.section])
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0
        {
            let section = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 40))
            section.backgroundColor = UIColor.clear
            let lable = creatLable(frame: CGRect.init(x: 10, y: 20, width: 100, height: 20), title: "他的广播", font: kFont_system14, textColor: UIColor.lightGray)
            lable.backgroundColor = UIColor.clear
            section.addSubview(lable)
            return section
        }
        else
        {
            let section = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 20))
            section.backgroundColor = UIColor.clear
           
            return section
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.showType == .pubilic && section == 0
        {
           return 40
        }
        return 20
    }
    
    
    
}
extension ManPersonInfoViewController:TZImagePickerControllerDelegate
{
    func uploadImage(sender:[Image]?)
    {
        guard let photos = sender ,photos.count > 0 else {
            return
        }
        var models:[AliyunUploadModel] = []
        for imageModel in photos
        {
            let model = AliyunUploadModel()
            model.image = imageModel
            model.fileName = getImageName()
            models.append(model)
            
        }
        AliyunManager.share.uploadImagesToAliyun(imageModels: models, complection: { (urls, succecCount, failCount, state) in
            if state == UploadImageState.success
            {//报名
                let model:lonelySpeechDetaileModel = self.broadcastAry[self.reportTag]
                let params:[String:Any] = ["user_id":CurrentUserInfo?.user_id ?? "","attachment":urls?.last ?? "", "appointment_id": model.id!]
                TargetManager.share.signUpAppiont(appointment_id: model.id ?? "", params: params, complection: { (success, error) in
                    if success
                    {
                        model.sign_up_count  = (model.sign_up_count ?? 0) + 1
                        self.reloadMyTableView(index: self.reportTag, model: model)
                    }
                })
            }
            else
            {
                DebugLog(message: "上传失败")
            }
        })
    }
}
