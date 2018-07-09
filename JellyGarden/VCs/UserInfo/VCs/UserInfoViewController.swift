//
//  UserInfoViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import Photos
class UserInfoViewController: BaseMainViewController {


    var currentOppiontConditions:[String] = {
        return CurrentUserInfo?.data?.appointment_condition ?? []
        
    }()//选择的约会条件
    
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
            vc.userid = CurrentUserInfo?.data?.user_id ?? ""
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
        case ClickSettingRedpacket:
            
            break
        case ClickFirstPhoto:
            let vc = QPPhotoPickerViewController(type: PageType.AllAlbum)
            vc.imageSelectDelegate = self
            //最大照片数量
            vc.imageMaxSelectedNum = 4
            self.present(vc, animated: true, completion: nil)
            
            
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
            case 1://查看权限
                AlertViewCoustom().showalertView(style: .actionSheet, title: "查看权限", message: nil, cancelBtnTitle: "取消", touchIndex: { (ind) in
                    
                    
                    guard ind != 0 else{
                        return
                    }
                    self.updatePermission(index: ind)
                    
                    
                }, otherButtonTitles: permissionAry[0], permissionAry[1],permissionAry[2],permissionAry[3])
                
                break
            case 2://个人介绍
               RootViewController?.hideTheTabbar()
                RootNav().pushViewController(EditPersonalIntroduceViewController(), animated: true)
                break
            case 3://约会条件
                AlertAction.share.showbottomPicker(title: title, maxCount: 4, dataAry: FillCondition.share.appointmentConditionListModel, currentData: currentOppiontConditions, backData: { (result) in
                   self.conditionAction(result: result)
                    
                })
                break
            case 4://分享
                break
            case 5://用户协议
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
        let parms = ["permission":str]
        TargetManager.share.updatePermission(params: parms) { (success) in
            if success{
                let model = CurrentUserInfo
                model?.data?.permission = str
                NSDictionary.init(dictionary: model?.toJSON() ?? [:]).write(toFile: UserPlist, atomically: true)
                self.tableView.reloadData()
            }
        }
    }
    func conditionAction(result:[String]) {//更新约会条件
        let model = CurrentUserInfo
        model?.data?.appointment_condition = result
        fillInfoRequest(jsonDic: model?.data?.toJSON() ?? [:], complection: { (result) in
            if result
            {
                NSDictionary.init(dictionary: (model?.toJSON())!).write(toFile: UserPlist, atomically: true)
                self.tableView.reloadData()
            }
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 0 == indexPath.section {
            guard var photoStrs = CurrentUserInfo?.data?.photos,photoStrs.count > 0
            else{
                
                return 220
            }
            photoStrs.append(" ")
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
            return 6
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
            
            cell?.accessoryType = .disclosureIndicator
            if 1 == indexPath.section && 0 == indexPath.row {
                cell?.textLabel?.text = "绑定手机"
                cell?.detailTextLabel?.text = CurrentUserInfo?.data?.phone
            }
            else if 1 == indexPath.section && 1 == indexPath.row {
                cell?.textLabel?.text = "查看权限"
                cell?.detailTextLabel?.text = CurrentUserInfo?.data?.permission
            }
            else if 1 == indexPath.section && 2 == indexPath.row {
                cell?.textLabel?.text = "个人介绍"
                cell?.detailTextLabel?.text = CurrentUserInfo?.data?.self_introduction
            }
            else if 1 == indexPath.section && 3 == indexPath.row {
                cell?.textLabel?.text = "约会条件"
                cell?.detailTextLabel?.text = CurrentUserInfo?.data?.appointment_condition?.joined(separator: " ")
                
            }
            else if 1 == indexPath.section && 4 == indexPath.row {
                cell?.textLabel?.text = "分享果冻花园"
                cell?.detailTextLabel?.text = ""
            }
            else if 1 == indexPath.section && 5 == indexPath.row {
                cell?.textLabel?.text = "用户使用协议"
                cell?.detailTextLabel?.text = ""
            }
            else if 2 == indexPath.section && 0 == indexPath.row {
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
extension UserInfoViewController:PhotoPickerControllerDelegate
{
    func onImageSelectFinished(images: [PHAsset]) {
        QPPhotoDataAndImage.getImagesAndDatas(photos: images) { (array) in
            self.uploadImage(sender: array)
        }
    }
    func uploadImage(sender:[QPPhotoImageModel]?)
    {
        guard let photos = sender ,photos.count > 0 else {
            return
        }
        var models:[AliyunUploadModel] = []
        for imageModel in photos
        {
            let model = AliyunUploadModel()
            model.image = imageModel.bigImage
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
        TargetManager.share.addUserPhotos(params: ["url_list":urlStrs.joined(separator: ",")]) { (success) in
            if success{
                let userModel = CurrentUserInfo
                for urlstr in urlStrs
                {
                    userModel?.data?.photos?.append(urlstr)
                }
                NSDictionary.init(dictionary: userModel?.toJSON() ?? [:]).write(toFile: UserPlist, atomically: true)
                self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
            }
        }
    }
    
}
