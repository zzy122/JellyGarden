//
//  UserInfoViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import Photos
import TZImagePickerController

class UserInfoViewController: BaseMainViewController,TZImagePickerControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let tableHeaderView: UIView = {
                let _headerView = UIView()
                _headerView.backgroundColor = UIColor.clear
                _headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 310)
                
                headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 310)
                _headerView.addSubview(headerView)
                
                return _headerView
            }()
            
            let tableFooterView: UIView = {
                let _view = UIView()
                _view.backgroundColor = UIColor.clear
                _view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 140)
                
                let _serviceButton = UIButton(type: UIButtonType.custom)
                _serviceButton.setTitle("联系客服", for: UIControlState.normal)
                _serviceButton.setTitleColor(hexString(hex: "6388C5"), for: UIControlState.normal)
                _serviceButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                _serviceButton.backgroundColor = UIColor.white
                _serviceButton.frame = CGRect(x: 0, y: 20, width: ScreenWidth, height: 44)
                _serviceButton.addTarget(self, action: #selector(touchService), for: UIControlEvents.touchUpInside)
                
                let _logoutButton = UIButton(type: UIButtonType.custom)
                _logoutButton.setTitle("退出登录", for: UIControlState.normal)
                _logoutButton.setTitleColor(hexString(hex: "ed639a"), for: UIControlState.normal)
                _logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                _logoutButton.backgroundColor = UIColor.white
                _logoutButton.frame = CGRect(x: 0, y: 74, width: ScreenWidth, height: 44)
                _logoutButton.addTarget(self, action: #selector(touchLogout), for: UIControlEvents.touchUpInside)
                
                _view.addSubview(_serviceButton)
                _view.addSubview(_logoutButton)
                return _view
            }()
            
            tableView.register(UINib(nibName: "MineRedPhoneCell", bundle: nil), forCellReuseIdentifier: "MineRedPhoneCell")
            tableView.tableHeaderView = tableHeaderView
            tableView.tableFooterView = tableFooterView
            tableView.separatorColor = UIColor.groupTableViewBackground
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

            if #available(iOS 11.0, *) {
                tableView.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
                self.automaticallyAdjustsScrollViewInsets = false 
            }
        }
    }
    
    let headerView: MineInfoHeaderView = UINib(nibName: "MineInfoHeaderView", bundle: nil)
        .instantiate(withOwner: nil, options: nil).first as! MineInfoHeaderView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.hidesBottomBarWhenPushed = true
        
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .top
        
        headerView.userInfo = CurrentUserInfo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        RootViewController?.showTheTabbar()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

@objc
extension UserInfoViewController {
    
    @IBAction func touchSetting() {
        RootViewController?.hideTheTabbar()
       RootNav().pushViewController(SettingViewController(), animated: true)
    }
    
    @IBAction func touchShare() {
        UMengAcion.uMengShare()
    }
    
    func touchRecover() {
        
    }
    
    func touchService() {
        RootViewController?.hideTheTabbar()
        let vc = RCDCustomerServiceViewController.init(conversationType: RCConversationType.ConversationType_CUSTOMERSERVICE, targetId: "service")
        vc?.targetId = "service"
        let info = RCCustomerServiceInfo.init()
        info.nickName = RCIM.shared().currentUserInfo.name
        info.portraitUrl = RCIM.shared().currentUserInfo.portraitUri
        info.referrer = "20001"
        vc?.csInfo = info
        vc?.title = "客服"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func touchLogout() {
        let finish = FinishViewController()
//        finish.isNeedAutoLogin = false
        clearUserInfo()
        let nav = UINavigationController.init(rootViewController: finish)
        
        RootViewController?.present(nav, animated: true, completion: {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.setRootViewController(vc: nav)
                judgeGesterPassword()
        })
    }
}

extension UserInfoViewController: ResponderRouter {

    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        RootViewController?.hideTheTabbar()
        switch name {
            
        case Mine_Info_Like: // 喜欢
            RootNav().pushViewController(MyLikesViewController(), animated: true)
            break
        case Mine_Info_Wallet: // 钱包
            RootNav().pushViewController(WalletViewController(), animated: true)
            break
        case Mine_Info_Guangbo: // 广播
            let vc = UserBroadcastListViewController()
            vc.userid = CurrentUserInfo?.user_id ?? ""
            RootNav().pushViewController(vc, animated: true)
            break
        case Mine_Info_Renzhen: // 认真
            let vc = IdentityAuthenticationViewController()
            RootNav().pushViewController(vc, animated: true)
            break
        case Mine_Info_Dingjing: // 定金
            let vc = DepositManagerViewController()
            RootNav().pushViewController(vc, animated: true)
            break
        case Mine_Info_HeaderInfo: // 个人信息
            let vc = MineInfoEditViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            break
        case ClickSettingRedpacket://设置红包照片
            
            
            break
        case ClickFirstPhoto:
            
            let vc = TZImagePickerController.init(maxImagesCount: 4, delegate: self)
            vc?.allowPickingVideo = false
            vc?.allowPickingImage = true
            vc?.allowTakePicture = true
            vc?.didFinishPickingPhotosHandle = {(photos, assets, isSelectOriginalPhoto) in
                self.uploadImage(sender: photos)
            }
            self.present(vc!, animated: true, completion: nil)
            break
        case Click_Mine_Photo://点击了照片 此处做处理
            
            guard let intTag = info as? Int else{
                return
            }
            RootViewController?.hideTheTabbar()
            let vc = LookImageSettingViewController()
            vc.tagIndex = intTag
            RootNav().present(vc, animated: true, completion: nil)
            
            break
        default:
            break
        }
        
        
    }
}

extension UserInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            
            break
        case 1:
            switch indexPath.row {
            case 0://绑定手机
                RootViewController?.hideTheTabbar()
                RootNav().pushViewController(DebangPhoneViewController(), animated: true)
                break
            case ((CurrentUserInfo?.sex == 1) ? 10:1)://会员
                RootViewController?.hideTheTabbar()
                let vc = VipCenterViewController()
                vc.isHaveUserHeader = true
                self.navigationController?.pushViewController(vc, animated: true)
               
                break
            case ((CurrentUserInfo?.sex == 1) ? 1:2)://查看权限
                AlertViewCoustom().showalertView(style: .actionSheet, title: "查看权限", message: nil, cancelBtnTitle: "取消", touchIndex: { (ind) in
                    
                    
                    guard ind != 0 else{
                        return
                    }
                    self.updatePermission(index: ind)
                    
                    
                }, otherButtonTitles: permissionAry[0], permissionAry[1],permissionAry[2],permissionAry[3])
                
                break
            case ((CurrentUserInfo?.sex == 1) ? 2:3)://个人介绍
               RootViewController?.hideTheTabbar()
                RootNav().pushViewController(EditPersonalIntroduceViewController(), animated: true)
                break
            case ((CurrentUserInfo?.sex == 1) ? 3:4)://约会条件
                AlertAction.share.showbottomPicker(title: title, maxCount: 4, dataAry: FillCondition.share.appointmentConditionListModel, currentData: CurrentUserInfo?.appointment_condition, backData: { (result) in
                   self.conditionAction(result: result)
                    
                })
                break
            case ((CurrentUserInfo?.sex == 1) ? 4:5)://分享
                UMengAcion.uMengShare()
                break
            case ((CurrentUserInfo?.sex == 1) ? 5:6)://用户协议
                break
            default:
                break
            }
            break
        case 2:
            switch indexPath.row {
            case 0://黑名单
               RootViewController?.hideTheTabbar()
                RootNav().pushViewController(BlackListViewController(), animated: true)
                break
            case 1://历时访客
                break
            case 2://阅后即焚
                break
            default:
                break
            }
            break
        default:
            break
        }
        
    }
    func updatePermission(index:Int)
    {
        let str = permissionAry[index - 1]
        let parms = ["permission":str,"user_id":CurrentUserInfo?.user_id ?? ""]
        
        TargetManager.share.updatePermission(params: parms) { (success) in
            if success{
                let model = CurrentUserInfo
                model?.permission = str
                NSDictionary.init(dictionary: model?.toJSON() ?? [:]).write(toFile: UserPlist, atomically: true)
                self.tableView.reloadData()
            }
        }
    }
    func conditionAction(result:[String]) {//更新约会条件
        let model = CurrentUserInfo
        model?.appointment_condition = result
        fillInfoRequest(jsonDic: model?.toJSON() ?? [:], complection: { (result) in
            if result
            {
                NSDictionary.init(dictionary: (model?.toJSON())!).write(toFile: UserPlist, atomically: true)
                self.tableView.reloadData()
            }
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 0 == indexPath.section {
            guard var photoStrs = CurrentUserInfo?.custom_photos,photoStrs.count > 0
            else{
                
                return 220
            }
            photoStrs.append(PhotoModel())
            let itemWidth:CGFloat = (ScreenWidth - 3 * 10) / 4
            let intege = getLines(ary: photoStrs, veryCount: 4)
            let height = CGFloat(intege) * (itemWidth + 10)
            return height
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.groupTableViewBackground
        return header
    }
}

extension UserInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return ((CurrentUserInfo?.sex == 0) ? 7 : 6)
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 0 == indexPath.section {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineRedPhoneCell") as! MineRedPhoneCell
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "UITableViewCell")
                cell?.textLabel?.textColor = hexString(hex: "333333")
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell?.detailTextLabel?.textColor = hexString(hex: "999999")
                cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            }
            cell?.accessoryView = nil
            cell?.accessoryType = .disclosureIndicator
            if CurrentUserInfo?.sex == 0
            {
                if 1 == indexPath.section && 0 == indexPath.row {
                    cell?.textLabel?.text = "绑定手机"
                    cell?.detailTextLabel?.text = CurrentUserInfo?.phone
                }
                else if 1 == indexPath.section && 1 == indexPath.row {
                    cell?.textLabel?.text = "会员"
                    cell?.detailTextLabel?.text = ""
                }
                else if 1 == indexPath.section && 2 == indexPath.row {
                    cell?.textLabel?.text = "查看权限"
                    cell?.detailTextLabel?.text = CurrentUserInfo?.permission
                }
                else if 1 == indexPath.section && 3 == indexPath.row {
                    cell?.textLabel?.text = "个人介绍"
                    cell?.detailTextLabel?.text = CurrentUserInfo?.self_introduction
                }
                else if 1 == indexPath.section && 4 == indexPath.row {
                    cell?.textLabel?.text = "约会条件"
                    cell?.detailTextLabel?.text = CurrentUserInfo?.appointment_condition?.joined(separator: " ")
                    
                }
                else if 1 == indexPath.section && 5 == indexPath.row {
                    cell?.textLabel?.text = "分享果冻花园"
                    cell?.detailTextLabel?.text = ""
                }
                else if 1 == indexPath.section && 6 == indexPath.row {
                    cell?.textLabel?.text = "用户使用协议"
                    cell?.detailTextLabel?.text = ""
                }
            }
            else
            {
                if 1 == indexPath.section && 0 == indexPath.row {
                    cell?.textLabel?.text = "绑定手机"
                    cell?.detailTextLabel?.text = CurrentUserInfo?.phone
                }
            
                else if 1 == indexPath.section && 1 == indexPath.row {
                    cell?.textLabel?.text = "查看权限"
                    cell?.detailTextLabel?.text = CurrentUserInfo?.permission
                }
                else if 1 == indexPath.section && 2 == indexPath.row {
                    cell?.textLabel?.text = "个人介绍"
                    cell?.detailTextLabel?.text = CurrentUserInfo?.self_introduction
                }
                else if 1 == indexPath.section && 3 == indexPath.row {
                    cell?.textLabel?.text = "约会条件"
                    cell?.detailTextLabel?.text = CurrentUserInfo?.appointment_condition?.joined(separator: " ")
                    
                }
                else if 1 == indexPath.section && 4 == indexPath.row {
                    cell?.textLabel?.text = "分享果冻花园"
                    cell?.detailTextLabel?.text = ""
                }
                else if 1 == indexPath.section && 5 == indexPath.row {
                    cell?.textLabel?.text = "用户使用协议"
                    cell?.detailTextLabel?.text = ""
                }
            }
            
            if 2 == indexPath.section && 0 == indexPath.row {
                cell?.textLabel?.text = "黑名单"
                cell?.detailTextLabel?.text = ""
            }
            else if 2 == indexPath.section && 1 == indexPath.row {
                cell?.textLabel?.text = "历史访客"
                cell?.detailTextLabel?.text = "有98个人看过你"
            }
            else if 2 == indexPath.section && 2 == indexPath.row {
                cell?.textLabel?.text = "阅后即焚"
                cell?.detailTextLabel?.text = "已有2个人焚毁了你的照片"
                cell?.accessoryView = {
                    let _button = UIButton(type: UIButtonType.custom)
                    _button.setTitle("一键恢复", for: UIControlState.normal)
                    _button.setTitleColor(hexString(hex: "6388C5"), for: UIControlState.normal)
                    _button.layer.cornerRadius = 10
                    _button.layer.borderColor = hexString(hex: "6388C5").cgColor
                    _button.layer.borderWidth = 1 / UIScreen.main.scale
                    _button.addTarget(self, action: #selector(touchRecover), for: UIControlEvents.touchUpInside)
                    _button.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
                    _button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                    return _button
                }()
            }
            
            return cell!
        }
    }
}
extension UserInfoViewController
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
            {
                self.uploadUserPhotoUrlToServer(urlStrs: urls ?? [])
            }
            else
            {
                DebugLog(message: "上传失败")
            }
        })
    }
    func uploadUserPhotoUrlToServer(urlStrs:[String]){

        for i in 0 ..< urlStrs.count
        {
            let urlstr = urlStrs[i]
            let params:[String:Any] = ["user_id":CurrentUserInfo?.user_id ?? "","url_list":urlstr,"type":0]
            TargetManager.share.addUserPhotos(params: params, complection: { (success) in
                DebugLog(message: "上传成功")
                if i == urlStrs.count - 1
                {
                    self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
                }
            })
            
        }
       
//        DispatchGroup().notify(queue: DispatchQueue.main) {
//            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
//        }
        
        
    }
    
}
