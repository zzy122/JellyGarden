//
//  AppointViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import MJRefresh
import Photos
class AppointViewController: BaseMainTableViewController,ResponderRouter,TZImagePickerControllerDelegate {
    
    var cityStr:String = LocalCityName {
        didSet{
            LocalCityName = cityStr
            MM_WARNING//此处设置请求params  self.params 发起请求
//            self.params[]
            
            self.leftBtn.isHidden = false
            self.leftBtn.setTitle(cityStr, for: UIControlState.normal)
            self.leftBtn.titleLabel?.font = kFont_system15
            self.leftBtn.setTitleColor(UIColor.gray, for: UIControlState.normal)
            self.leftBtn.setImage(imageName(name: "箭头-下"), for: UIControlState.normal)
            
            self.leftBtn.sizeToFit()
        }
    }
    
    var reportTag:Int = 0
    
    let headerFresh = MJRefreshNormalHeader()
    var footerFresh = MJRefreshAutoNormalFooter()
    
    lazy var
    conditionView:FiltrateCondition = {
        let view1 = FiltrateCondition.init(frame: CGRect.init(x: 0, y: -250, width: ScreenWidth, height: 250))
        
        self.view.addSubview(view1)
        view1.backParam(backParam: {[weak self] (param) in
            var tagParam = param
            self?.page = 0
            tagParam!["page"] = 0
            tagParam!["page_size"] = 5
            self?.params = param
        })
        return view1
    }()
    
    var params:[String:Any]? {
        didSet{
            self.closeConditionView()
            self.getAppiontData(param: params!) { (result) in
                if result
                {
                    self.tableView.reloadData()
                }
                self.headerFresh.endRefreshing()
                self.footerFresh.endRefreshing()
            }
        }
    }
    
    var page:Int = 1
    {
        didSet{
            self.params?["page"] = page
        }
    }
    
    var appiontModels:[lonelySpeechDetaileModel]? = []
    
    lazy var addAppiont:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: ScreenWidth - 80, y: self.view.frame.height - 80, width: 50, height: 50))
        btn.setImage(imageName(name: "添加"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(clickAdd), for: UIControlEvents.touchUpInside)
        btn.backgroundColor = UIColor.clear
        self.view.addSubview(btn)
        return btn
    }()
    
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addAppiont.frame = CGRect.init(x: ScreenWidth - 80, y: self.view.frame.height - 80, width: 50, height: 50)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "寂寞告白"
        self.cityStr = LocalCityName
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.register(UINib.init(nibName: "ConfessionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfessionTableViewCell")
        self.params = ["sort":"near","page": self.page,"page_size":5]
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        headerFresh.setRefreshingTarget(self, refreshingAction: #selector(self.refresh))
        footerFresh.setRefreshingTarget(self, refreshingAction: #selector(footerRefreshAction))
        //防止刷新cell的时候跳动
        self.tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        self.tableView.mj_header = headerFresh
        self.tableView.mj_footer = footerFresh
         self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }
    @objc func footerRefreshAction()
    {
       self.page = self.page + 1
//    self.getAppiontData(param: self.params!) { (result) in
//            if result
//            {
//                self.tableView.reloadData()
//            }
//            self.headerFresh.endRefreshing()
//            self.footerFresh.endRefreshing()
//        }
    }
    @objc func refresh()
    {
        
        self.appiontModels?.removeAll()
        self.page = 1
//        self.getAppiontData(param: self.params!) { (result) in
//            if result
//            {
//                self.tableView.reloadData()
//            }
//            self.headerFresh.endRefreshing()
//            self.footerFresh.endRefreshing()
//        }
    }
    func getAppiontData(param:[String:Any] ,complection:@escaping (Bool) -> Void) {
        var params = param
        params["user_id"] = CurrentUserInfo?.user_id ?? ""
        TargetManager.share.getLonelySpeechList(params: params) { (models, error) in
            guard error != nil else{

                guard models.count > 0 else
                {
                    alertHud(title: "没有更多数据了")
                    complection(true)
                    return
                }
                
                self.appiontModels = self.appiontModels! + models
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
        RootViewController?.showTheTabbar()
        self.rightBtn.isHidden = false
        self.rightBtn.setImage(imageName(name: "筛选"), for: UIControlState.normal)
        self.addAppiont.isHidden = false
        
        self.leftBtn.isHidden = false
        self.leftBtn.leftTitie = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true
    }

    override func clickRightBtn() {
        guard self.conditionView.isselect else {
            self.showConditionView()
            self.conditionView.isselect = true
            return
        }

    }
    
    override func clickLeftBtn() {
        self.closeConditionView()
        AlertAction.share.showbottomPicker(title: self.cityStr, maxCount: 1, dataAry: currentCitys, currentData: [self.cityStr]) { (result) in
            self.cityStr = result.last ?? self.cityStr
        }
    }
    
    func closeConditionView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.conditionView.frame = CGRect.init(x: 0, y: -250, width: ScreenWidth, height: 250)
        }) { (complect) in
            self.conditionView.isselect = false
        }
    }
    
    func showConditionView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.conditionView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 250)
        }) { (complect) in
            
        }
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.appiontModels?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ConfessionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ConfessionTableViewCell", for: indexPath) as! ConfessionTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.tag = indexPath.section

        cell.setDatasource(model: appiontModels![indexPath.section])
        return cell
    }
    @objc func clickAdd(){
        AlertViewCoustom().showalertView(style: .actionSheet, title: "广播", message: nil, cancelBtnTitle: "取消", touchIndex: { (index) in
            if index == 1
            {
              RootNav().pushViewController(NormalAppointmentViewController(), animated: true)
            }
            else if index == 2
            {
                RootNav().pushViewController(EnlistAppiontViewController(), animated: true)
            }
            DebugLog(message: "\(index)")
            
        }, otherButtonTitles: "普通约会广播", "报名约会广播")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = appiontModels?[indexPath.section]
        
        let height = caculateCellHeight(model: model!)
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
extension AppointViewController
{
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        guard let index = info as? Int else{
            return
        }
        if name == ClickReportName {//点击产看报名
            guard let model = appiontModels?[index],model.user_id == CurrentUserInfo?.user_id else
            {
                alertHud(title: "只有本人才能查看报名哦")
                return
            }
            RootViewController?.hideTheTabbar()
            let vc = EnlistDetailViewController()
            vc.detaileModel = model
            RootNav().pushViewController(vc, animated: true)
        }
        if ClickEnlistBtn == name {//我要报名
            guard let model = appiontModels?[index],model.user_id != CurrentUserInfo?.user_id else
            {
                alertHud(title: "不能报名本人哦")
                return
            }
            guard model.sex != CurrentUserInfo?.sex else
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
        if name == ClickLikeChangeBtn  {//点赞
            let model:lonelySpeechDetaileModel = appiontModels![index]
            let appointment_id = model.id
            if let like = model.is_like,like//取消赞
            {
                TargetManager.share.cancelLikeAppiont(appointment_id: appointment_id, complection: { (result, error) in
                    if result//请求数据刷新
                    {
                         model.likes_count  =  model.likes_count! - 1
                        model.is_like = false
                        self.reloadMyTableView(index: index, model: model)
                    }
                })
            }
            else//点赞
            {
                TargetManager.share.likeAppiont(appointment_id: appointment_id!, complection: { (complection, error) in
                    if complection//请求数据刷新
                    {
                        model.is_like = true
                         model.likes_count  =  (model.likes_count ?? 0) + 1
                        self.reloadMyTableView(index: index, model: model)
                    }
                })
            }
        }
        if name == ClickCommentBtn {//评论
             let model:lonelySpeechDetaileModel = self.appiontModels![index]
            if  model.sex == CurrentUserInfo?.sex && model.user_id != CurrentUserInfo?.user_id
            {
                alertHud(title: "不能评论同性别哦")
                return
            }
            
            AlertAction.share.showCommentView(clickType: { (type, str) in
                guard let text = str,text.count > 0 else {
                    return
                }
                if type == .publish{
                   
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
        if name == ClickUserInfoHeader//点击头像
        {
           self.checkUserinfoData(index: index)
        }
        if name == ClickDepositBtn
        {
//            let model:lonelySpeechDetaileModel = appiontModels![index]
//
//            AlertAction.share.showAlertView(type: UIKeyboardType.numberPad, title: "是否支付定金", placeHodel: "",textStr:"¥\(String(model.deposit!))", detailTitle: "自愿支付定金,支付金额暂存在平台上", detailImage: imageName(name: "提示")) { (success, backStr) in
//                if success//调用支付接口
//                {
//                    let extraStr = getJSONStringFromObject(dictionary: ["appointment_id":model.appointment_id ?? ""])
//                    let params:[String:Any] = ["type":0,"amount": model.deposit ?? 0,"user_id":CurrentUserInfo?.user_id ?? "","recipient":model.poster?.user_id ?? "","extra":extraStr]
//                    TargetManager.share.transfer(params: params, complection: { (successful, error) in
//                        if successful//支付成功
//                        {
//
//                        }
//                    })
//                }
//            }
        }
        if name == ClickCommentCell//点击评论
        {
            self.checkUserinfoData(index: index)
        }
        
    }
    func checkUserinfoData(index:Int)
    {
        let model:lonelySpeechDetaileModel = appiontModels![index]
        let userSex = CurrentUserInfo?.sex
        if userSex == 0,userSex == model.sex
        {
            alertHud(title: "男士不能查看男士列表哦~")
            return
        }
        if userSex == 1,userSex == model.sex
        {
            alertHud(title: "女士不能查看女士列表哦~")
            return
        }
        RootViewController?.hideTheTabbar()
        if model.sex == 1
        {
            
            let vc = PersonInfoViewController()
            TargetManager.share.getDetailUserInfo(userid: model.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
                guard let user = userinfo else{
                    return
                }
                //                    user.distance = model.distance
                vc.userInfoModel = user
                RootNav().pushViewController(vc, animated: true)
            })
        }
        else
        {
            let vc = ManPersonInfoViewController()
            TargetManager.share.getDetailUserInfo(userid: model.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
                guard let user = userinfo else{
                    return
                }
                //                    user.distance = model.distance
                vc.userInfoModel = user
                RootNav().pushViewController(vc, animated: true)
            })
        }
    }
    func reloadMyTableView(index:Int, model:lonelySpeechDetaileModel)
    {
        self.appiontModels?.remove(at: index)
        self.appiontModels?.insert(model, at: index)
        let indexPath = IndexPath.init(row: 0, section: index)
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
    }
   
    
}
extension AppointViewController
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
                let model:lonelySpeechDetaileModel = self.appiontModels![self.reportTag]
                let params:[String:Any] = ["user_id":CurrentUserInfo?.user_id ?? "","attachment":urls?.last ?? "","has_pay_deposit":0, "appointment_id": model.id!]
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
