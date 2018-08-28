//
//  UserBroadcastListViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/28.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import MJRefresh
import Photos
class UserBroadcastListViewController: BaseMainTableViewController,TZImagePickerControllerDelegate,ResponderRouter {
    var userid:String = ""
    var reportTag:Int = 0
    var isSelfBroadcast:Bool = false
    
    lazy var clickPublishCast:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = APPCustomBtnColor
        btn.setTitle("发布约会", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(clickPublishBtn), for: UIControlEvents.touchUpInside)
        return btn
        
    }()
    private var noCastBackView = UIView()
    
    lazy var noCastView:NOCastView = {
        let view1 = NOCastView.createNOCastView()!
        self.noCastBackView.backgroundColor = UIColor.clear
        view1.frame = self.noCastBackView.bounds
        self.noCastBackView.addSubview(view1)
        self.view.addSubview(self.noCastBackView)
        return view1
    }()
    
    
    var appiontModels:[lonelySpeechDetaileModel] = []
    {
        didSet{
            if appiontModels.count == 0{
                self.noCastBackView.isHidden = false
            }
            else
            {
              self.noCastBackView.isHidden = true
            }
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if  isSelfBroadcast {
            self.clickPublishCast.frame = CGRect.init(x: 0, y: self.view.frame.height - 44, width: ScreenWidth, height: 44)
            
            let frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: self.view.frame.height - self.clickPublishCast.frame.height)
            self.tableView.frame = frame
            self.noCastBackView.frame = frame
            
            self.clickPublishCast.isHidden = false
        }
        else
        {
            self.tableView.frame = self.view.bounds
            self.noCastBackView.frame = self.view.bounds
            self.clickPublishCast.isHidden = true
        }
    }
    @objc func clickPublishBtn()
    {
        RootNav().pushViewController(NormalAppointmentViewController(), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isSelfBroadcast = (userid == CurrentUserInfo?.user_id)
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.title = self.isSelfBroadcast ? "我的广播" : "她的广播"
        if appiontModels.count == 0 {
            self.noCastView.warmLab.text = self.isSelfBroadcast ? "你还没有发布广播" : "他还没有发布广播";
            self.noCastView.isHidden = false
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.register(UINib.init(nibName: "ConfessionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfessionTableViewCell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
    }
    func getAppiontData(complection:@escaping (Bool) -> Void) {
        TargetManager.share.requestUserAllBroadcast(userid: userid) { (models, error) in
            guard error != nil else{
                self.appiontModels = models ?? []
                complection(true)
                return
            }
            complection(false)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().enable = false
        
        self.getAppiontData { (success) in//在这里是因为别人发布广播成功后返回这个界面刷新数据
            if success
            {
                if self.appiontModels.count > 0 {
                    self.noCastBackView.isHidden = true
                }
                else
                {
                    self.noCastBackView.isHidden = false
                }
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.appiontModels.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ConfessionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ConfessionTableViewCell", for: indexPath) as! ConfessionTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.tag = indexPath.section
        cell.isEnableDelete = true
        cell.setDatasource(model: appiontModels[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = appiontModels[indexPath.section]
        
        let height = caculateCellHeight(model: model)
        return height
        
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 20))
        view1.backgroundColor = UIColor.clear
        return view1
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
extension UserBroadcastListViewController
{
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        guard let index = info as? Int else{
            return
        }
        if name == ClickReportName {//点击产看报名
            guard appiontModels[index].poster?.user_id == CurrentUserInfo?.user_id else
            {
                alertHud(title: "只有本人才能查看报名哦")
                return
            }
            
            let vc = EnlistDetailViewController()
            vc.detaileModel = appiontModels[index]
            RootNav().pushViewController(vc, animated: true)
        }
        if ClickEnlistBtn == name {//我要报名
            guard userid != CurrentUserInfo?.user_id else
            {
                alertHud(title: "不能报名本人哦")
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
        if name == ClickLikeChangeBtn  {//点赞
            guard let index = info as? Int else{
                return
            }
            let model:lonelySpeechDetaileModel = appiontModels[index]
            let appointment_id = model.appointment_id
            if let like = model.is_like,like//取消赞
            {
                TargetManager.share.cancelLikeAppiont(appointment_id: appointment_id, complection: { (result, error) in
                    if result//请求数据刷新
                    {
                        model.is_like = false
                        
                        model.likes_count  =  model.likes_count! - 1
                        self.reloadMyTableView(index: index, model: model)
                    }
                })
            }
            else//点赞
            {
                TargetManager.share.likeAppiont(appointment_id: appointment_id!, complection: { (complection, error) in
                    if complection//请求数据刷新
                    {
                        model.likes_count  =  model.likes_count ?? 0 + 1
                        model.is_like = true
                        self.reloadMyTableView(index: index, model: model)
                    }
                })
            }
        }
        if name == ClickCommentBtn {//评论
            AlertAction.share.showCommentView(clickType: { (type, str) in
                guard let text = str else{
                    return
                }
                if type == .publish{
                    guard let index = info as? Int else{
                        return
                    }
                    let model:lonelySpeechDetaileModel = self.appiontModels[index]
                    let params = ["publisher_id":CurrentUserInfo?.user_id ?? "","content":text, "appointment_id": model.appointment_id!]
                    TargetManager.share.issueComment(appointment_id: model.appointment_id ?? "", params: params, complection: { (commentmodel, error) in
                        guard let comment = commentmodel else{
                            return
                        }
                        model.comments?.append(comment)
                        self.reloadMyTableView(index: index, model: model)
                    })
                    
                }
                
            })
        }
        if name == ClickDeleteBtn
        {
            guard let indexTag = info as? Int else{
                return
            }
            let model:lonelySpeechDetaileModel = appiontModels[index]
            let appointment_id = model.appointment_id
            AlertViewCoustom().showalertView(style: .alert, title: alertTitle, message: "确定删除这条约会吗", cancelBtnTitle: alertCancel, touchIndex: { (index) in
                if index == 1
                {
                    TargetManager.share.deleteUserBrocast(appointment_id: appointment_id ?? "", complection: { (result) in
                        if result {
                            self.appiontModels.remove(at: indexTag)
                            self.tableView.reloadData()
                        }
                    })
                }
            }, otherButtonTitles: alertConfirm)
        }
        
    }
    func reloadMyTableView(index:Int, model:lonelySpeechDetaileModel)
    {
        self.appiontModels.remove(at: index)
        self.appiontModels.insert(model, at: index)
        let indexPath = IndexPath.init(row: 0, section: index)
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
    }
    
}
extension UserBroadcastListViewController
{
    //添加照片的协议方法
   
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
                let model:lonelySpeechDetaileModel = self.appiontModels[self.reportTag]
                let params:[String:Any] = ["user_id":CurrentUserInfo?.user_id ?? "","attachment":urls?.last ?? "","has_pay_deposit":0, "appointment_id": model.appointment_id!]
                TargetManager.share.signUpAppiont(appointment_id: model.appointment_id ?? "", params: params, complection: { (success, error) in
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



    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

