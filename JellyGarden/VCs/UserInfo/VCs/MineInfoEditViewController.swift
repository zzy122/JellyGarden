//
//  MineInfoEditViewController.swift
//  JellyGarden
//
//  Created by weipinzhiyuan on 2018/6/24.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import HandyJSON

class MineInfoEditViewController: BaseMainViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = hexString(hex: "f3f5f8")
            tableView.separatorColor = hexString(hex: "f3f5f8")
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            
            tags1.backgroundColor = UIColor.clear
            tags1.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 250)
            tags1.padding = 10
            tags1.isEnableAdd = false
            tags1.tagDelegate = self
            tags1.allowsMultipleSelection = true
            tags1.selectedStyle = TagsView.TagStyle(backgroundColor: hexString(hex: "6388C5"),
                                                    textColor: UIColor.white,
                                                    font: UIFont.systemFont(ofSize: 14))
            tags1.normalStyle = TagsView.TagStyle(backgroundColor: hexString(hex: "eeeeee"),
                                                  textColor: hexString(hex: "666666"),
                                                  font: UIFont.systemFont(ofSize: 14))

            tags1.titles = FillCondition.share.conditionTag
            tableView.tableFooterView = tags1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35) {
                self.reloadTag()
            }
        }
    }
    
    let tags1 = TagsView(.text) //OK
    
    let textView: UITextView = {
        let _textView = UITextView()
        let pleaceLab: UILabel = UILabel(frame: CGRect(x: 8, y: 3, width: 100, height: 20))
        pleaceLab.text = "个人介绍"
        pleaceLab.numberOfLines = 0
        pleaceLab.textColor = UIColor.gray;
        pleaceLab.sizeToFit()
        _textView.setValue(pleaceLab, forKey: "_placeholderLabel")
        return _textView
    }()
    
    var userInfo: UserModel! = CurrentUserInfo
    
    var newUserInfo: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "编辑资料"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBtn.isHidden = false
        rightBtn.setTitle("保存", for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func clickRightBtn() {
        /// 保存
    }
}

extension MineInfoEditViewController: TagsViewDelegate {
    
    func tagsView(didTouchTagAtIndex index: Int) {
        
    }
    
    func reloadTag() {
        for selfTag in userInfo.data?.tags ?? [] {
            for index in 0 ..< FillCondition.share.conditionTag.count {
                let tag = FillCondition.share.conditionTag[index]
                if tag == selfTag {
                    tags1.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.top)
                }
            }
        }
    }
}

extension MineInfoEditViewController: PhotoPickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getInfoModel() -> UserModel {
        if newUserInfo == nil {
            newUserInfo = UserModel()
        }
        return newUserInfo!
    }
    
    /// 相册
    func showAlbum() {
        let vc = QPPhotoPickerViewController(type: PageType.AllAlbum)
        vc.imageSelectDelegate = self
        vc.imageMaxSelectedNum = 1
        present(vc, animated: true, completion: nil)
    }
    
    /// 相机
    func showCamera() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.mediaTypes = [kUTTypeImage] as [String]
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        let yunmodel: AliyunUploadModel = AliyunUploadModel()
        yunmodel.image = image
        yunmodel.fileName = "\(getImageName()).png"
        AliyunUpload.share().uploadImage(toAliyun: [yunmodel], isAsync: true, completion: { (urls, failCount, successCount, state) in
            if state == UploadImageState.success {
                var infoModel = self.getInfoModel()
                infoModel.data?.avatar = urls?.last
                self.newUserInfo = infoModel
                self.userInfo.data?.avatar = urls?.last
                self.tableView.reloadData()
            }
        })
    }
    
    func onImageSelectFinished(images: [PHAsset]) {
        QPPhotoDataAndImage.getImagesAndDatas(photos: images) { (array) in
            let model:QPPhotoImageModel? = array?.last
            let yunmodel: AliyunUploadModel = AliyunUploadModel()
            yunmodel.image = model?.bigImage
            yunmodel.fileName = "\(getImageName()).png"
            AliyunUpload.share().uploadImage(toAliyun: [yunmodel], isAsync: true, completion: { (urls, failCount, successCount, state) in
                if state == UploadImageState.success {
                    var infoModel = self.getInfoModel()
                    infoModel.data?.avatar = urls?.last
                    self.newUserInfo = infoModel
                    self.userInfo.data?.avatar = urls?.last
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    /// 昵称
    func editNickName() {
        AlertAction.share.showAlertView(type: nil,
                                        title: "昵称",
                                        placeHodel: "请输入昵称",
                                        detailTitle: nil,
                                        detailImage: nil) { (sure, result) in
                                            if sure {
                                                var infoModel = self.getInfoModel()
                                                infoModel.data?.nickname = result
                                                self.newUserInfo = infoModel
                                                self.userInfo.data?.nickname = result
                                                self.tableView.reloadData()
                                            }
        }
    }
    
    /// 约会范围
    func appointFanwei() {
        AlertAction.share.showbottomPicker(title: "约会范围", maxCount: 4, dataAry: currentCitys, currentData: userInfo.data?.appointment_place) { (fanwei) in
            var infoModel = self.getInfoModel()
            infoModel.data?.appointment_place = fanwei
            self.userInfo.data?.appointment_place = fanwei
            self.tableView.reloadData()
        }
    }
    
    var ageList: [PikerModel] {
        var dicAry:[[String:Any]] = []
        for i in 15 ..< 46 {
            let dic:[String:Any] = ["citysName":i]
            dicAry.append(dic)
        }
        return [PikerModel].deserialize(from: dicAry) as! [PikerModel]
    }

    /// 年龄
    func appointAge() {
        var currentData:[String] = []
        
        let agestr = "\(userInfo.data?.age ?? 18)"
        if agestr.count > 0 {
            currentData = [agestr]
        }

        AlertAction.share.showbottomPicker(title: "选择年龄", maxCount: 1, dataAry: ageList, currentData: currentData) { (ages) in
            if let first = ages.first {
                var infoMdoel = self.getInfoModel()
                infoMdoel.data?.age = Int(first) ?? 18
                self.newUserInfo = infoMdoel
                self.userInfo.data?.age = Int(first) ?? 18
                self.tableView.reloadData()
            }
        }
    }
    
    /// 身高
    func shengao() {
        AlertAction.share.showAlertView(type: UIKeyboardType.numberPad,
                                        title: "身高",
                                        placeHodel: "请填写您的身高(CM)",
                                        detailTitle: nil,
                                        detailImage: nil) { (sure, result) in
            
                                            if sure, let stature = result, stature.count > 0 {
                                                var infoModel = self.getInfoModel()
                                                infoModel.data?.stature = Int(stature) ?? 180
                                                self.newUserInfo = infoModel
                                                self.userInfo.data?.stature = Int(stature) ?? 180
                                                self.tableView.reloadData()
                                            }
        }
    }
    
    /// 身份
    func shenfen() {
        AlertAction.share.showbottomPicker(title: "选择您的身份", maxCount: 1, dataAry: FillCondition.share.identityListModel, currentData: [userInfo.data?.identity ?? ""]) { (identify) in
            var infoModel = self.getInfoModel()
            infoModel.data?.identity = identify.first
            self.newUserInfo = infoModel
            self.userInfo.data?.identity = identify.first
            self.tableView.reloadData()
        }
    }
    
    /// 体重
    func weight() {
        AlertAction.share.showAlertView(type: UIKeyboardType.numberPad,
                                        title: "体重",
                                        placeHodel: "请填写您的体重(KG)",
                                        detailTitle: nil,
                                        detailImage: nil) { (sure, result) in
                                            guard sure, let result = result, result.count > 0 else { return }
                                            var infModel = self.getInfoModel()
                                            infModel.data?.weight = Int(result)
                                            self.newUserInfo = infModel
                                            self.userInfo.data?.weight = Int(result)
                                            self.tableView.reloadData()
        }
    }
    
    /// 胸围
    func bust() {
        AlertAction.share.showAlertView(type: UIKeyboardType.numberPad,
                                        title: "胸围",
                                        placeHodel: "请填写您的胸围",
                                        detailTitle: nil,
                                        detailImage: nil) { (sure, result) in
                                            guard sure, let result = result, result.count > 0 else { return }
                                            var infoModel = self.getInfoModel()
                                            infoModel.data?.bust = Int(result)
                                            self.newUserInfo = infoModel
                                            self.userInfo.data?.bust = Int(result)
                                            self.tableView.reloadData()
        }
    }
    
    /// 风格
    func style() {
        AlertAction.share.showbottomPicker(title: "请选择您的风格",
                                           maxCount: 4,
                                           dataAry: FillCondition.share.dressStyleListModel,
                                           currentData: userInfo.data?.dress_style) { (styles) in
                                            var infoModel = self.getInfoModel()
                                            infoModel.data?.dress_style = styles
                                            self.newUserInfo = infoModel
                                            self.userInfo.data?.dress_style = styles
                                            self.tableView.reloadData()
        }
    }
    
    /// 语言
    func language() {
        AlertAction.share.showbottomPicker(title: "选择您的语言",
                                           maxCount: 4,
                                           dataAry: FillCondition.share.languageListModel,
                                           currentData: userInfo.data?.language) { (languages) in
                                            var infoModel = self.getInfoModel()
                                            infoModel.data?.language = languages
                                            self.newUserInfo = infoModel
                                            self.userInfo.data?.language = languages
                                            self.tableView.reloadData()
        }
    }
    
    /// 感情
    func emotion() {
        AlertAction.share.showbottomPicker(title: "请选择您的情感状态",
                                           maxCount: 1,
                                           dataAry: FillCondition.share.emotionStatusList,
                                           currentData: [userInfo.data?.emotion_status ?? ""]) { (emotion) in
                                            var infoModel = self.getInfoModel()
                                            infoModel.data?.emotion_status = emotion.first
                                            self.newUserInfo = infoModel
                                            self.userInfo.data?.emotion_status = emotion.first
                                            self.tableView.reloadData()
        }
    }
    
    /// 节目
    func progoram() {
        AlertAction.share.showbottomPicker(title: "请选择您的约会节目",
                                           maxCount: 4,
                                           dataAry: FillCondition.share.appointmentProgramListModel,
                                           currentData: userInfo.data?.appointment_program) { (emotion) in
                                            var infoModel = self.getInfoModel()
                                            infoModel.data?.appointment_program = emotion
                                            self.newUserInfo = infoModel
                                            self.userInfo.data?.appointment_program = emotion
                                            self.tableView.reloadData()
        }
    }
    
    /// 条件
    func condition() {
        AlertAction.share.showbottomPicker(title: "请选择您的约会条件",
                                           maxCount: 4,
                                           dataAry: FillCondition.share.appointmentConditionListModel,
                                           currentData: userInfo.data?.appointment_condition) { (emotion) in
                                            var infoModel = self.getInfoModel()
                                            infoModel.data?.appointment_condition = emotion
                                            self.newUserInfo = infoModel
                                            self.userInfo.data?.appointment_condition = emotion
                                            self.tableView.reloadData()
        }
    }
    
    /// qq
    func qq() {
        AlertAction.share.showAlertView(type: UIKeyboardType.numberPad,
                                        title: "身高",
                                        placeHodel: "请填写您的身高(CM)",
                                        detailTitle: nil,
                                        detailImage: nil) { (sure, result) in
                                            
                                            if sure, let stature = result, stature.count > 0 {
                                                var infoModel = self.getInfoModel()
                                                infoModel.data?.stature = Int(stature) ?? 180
                                                self.newUserInfo = infoModel
                                                self.userInfo.data?.stature = Int(stature) ?? 180
                                                self.tableView.reloadData()
                                            }
        }
    }
    
    /// 微信
    func wechat() {}
}

extension MineInfoEditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 0 == indexPath.section && 0 == indexPath.row {
            return 60
        }
        else if 3 == indexPath.section {
            return 120
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 头像
        if 0 == indexPath.section && 0 == indexPath.row {
            AlertViewCoustom().showalertView(style: UIAlertControllerStyle.actionSheet, title: nil, message: nil, cancelBtnTitle: "取消", touchIndex: { (index) in
                if index == 1 {
                    self.showCamera()
                }
                else if index == 2 {
                    self.showAlbum()
                }
            }, otherButtonTitles: "拍照", "相册")
        }
        // 昵称
        else if 0 == indexPath.section && 1 == indexPath.row {
            editNickName()
        }
        // 约会范围
        else if 0 == indexPath.section && 2 == indexPath.row {
            appointFanwei()
        }
            // 年龄
        else if 0 == indexPath.section && 3 == indexPath.row {
            appointAge()
        }
            /// 身高
        else if 0 == indexPath.section && 4 == indexPath.row {
            shengao()
        }
            // 身份
        else if 0 == indexPath.section && 5 == indexPath.row {
            shenfen()
        }
            // 体重
        else if 0 == indexPath.section && 6 == indexPath.row {
            weight()
        }
            // 胸围
        else if 0 == indexPath.section && 7 == indexPath.row {
            bust()
        }
            // 打扮风格
        else if 1 == indexPath.section && 0 == indexPath.row {
            style()
        }
            /// 语言
        else if 1 == indexPath.section && 1 == indexPath.row {
            language()
        }
            // 感情
        else if 1 == indexPath.section && 2 == indexPath.row {
            emotion()
        }
            // 约会节目
        else if 1 == indexPath.section && 3 == indexPath.row {
            progoram()
        }
            // 约会条件
        else if 1 == indexPath.section && 4 == indexPath.row {
            condition()
        }
            // QQ
        else if 2 == indexPath.section && 0 == indexPath.row {
            qq()
        }
            // wechat
        else if 2 == indexPath.section && 1 == indexPath.row {
            wechat()
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if 3 == indexPath.section {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if 0 == section {
            return 0.000001
        }
        else if 1 == section {
            return 10
        }
        else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if 0 == section || 1 == section {
            return nil
        }
        
        let header: UIView = {
            let _header = UIView()
            _header.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 30)
            _header.backgroundColor = UIColor.clear
            
            let _label = UILabel()
            _label.textColor = hexString(hex: "999999")
            _label.font = UIFont.systemFont(ofSize: 12)
            _label.frame = CGRect(x: 15, y: 10, width: ScreenWidth - 30, height: 20)
            
            if 2 == section {
                _label.text = "联系方式（至少填写一种联系方式）"
            }
            else {
                _label.text = "个人介绍（选填）"
            }
            
            _header.addSubview(_label)
            return _header
        }()
        
        return header
    }
}

extension MineInfoEditViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 8
        case 1:
            return 5
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "UITableViewCell")
            cell?.textLabel?.textColor = hexString(hex: "333333")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.detailTextLabel?.textColor = hexString(hex: "999999")
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        }
        cell?.accessoryType = .none
        cell?.accessoryView = nil
        
        if 0 == indexPath.row && 0 == indexPath.section {
            cell?.textLabel?.text = "头像"
            cell?.detailTextLabel?.text = ""
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: userInfo.data?.avatar ?? ""))
            imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            cell?.accessoryView = imageView
        }
        else if 1 == indexPath.row && 0 == indexPath.section {
            cell?.textLabel?.text = "昵称"
            cell?.detailTextLabel?.text = userInfo.data?.nickname
        }
        else if 2 == indexPath.row && 0 == indexPath.section {
            cell?.textLabel?.text = "约会范围"
            cell?.detailTextLabel?.text = userInfo.data?.appointment_place?.joined(separator: " ")
        }
        else if 3 == indexPath.row && 0 == indexPath.section {
            cell?.textLabel?.text = "年龄"
            cell?.detailTextLabel?.text = "\(userInfo.data?.age ?? 18)岁"
        }
        else if 4 == indexPath.row && 0 == indexPath.section {
            cell?.textLabel?.text = "身份"
            cell?.detailTextLabel?.text = userInfo.data?.identity
        }
        else if 5 == indexPath.row && 0 == indexPath.section {
            cell?.textLabel?.text = "身高"
            cell?.detailTextLabel?.text = "\(userInfo.data?.stature ?? 165)CM"
        }
        else if 6 == indexPath.row && 0 == indexPath.section {
            cell?.textLabel?.text = "体重"
            cell?.detailTextLabel?.text = "\(userInfo.data?.weight ?? 40)KG"
        }
        else if 7 == indexPath.row && 0 == indexPath.section {
            cell?.textLabel?.text = "胸围"
            cell?.detailTextLabel?.text = "\(userInfo.data?.bust ?? 36)CM"
        }
        else if 0 == indexPath.row && 1 == indexPath.section {
            cell?.textLabel?.text = "打扮风格"
            cell?.detailTextLabel?.text = userInfo.data?.dress_style?.joined(separator: " ")
        }
        else if 1 == indexPath.row && 1 == indexPath.section {
            cell?.textLabel?.text = "语言"
            cell?.detailTextLabel?.text = userInfo.data?.language?.joined(separator: " ")
        }
        else if 2 == indexPath.row && 1 == indexPath.section {
            cell?.textLabel?.text = "感情"
            cell?.detailTextLabel?.text = userInfo.data?.emotion_status
        }
        else if 3 == indexPath.row && 1 == indexPath.section {
            cell?.textLabel?.text = "约会节目"
            cell?.detailTextLabel?.text = userInfo.data?.appointment_program?.joined(separator: " ")
        }
        else if 4 == indexPath.row && 1 == indexPath.section {
            cell?.textLabel?.text = "约会条件"
            cell?.detailTextLabel?.text = userInfo.data?.appointment_condition?.joined(separator: " ")
        }
        else if 0 == indexPath.row && 2 == indexPath.section {
            cell?.textLabel?.text = "QQ"
            cell?.detailTextLabel?.text = userInfo.data?.contact_qq
        }
        else if 1 == indexPath.row && 2 == indexPath.section {
            cell?.textLabel?.text = "微信"
            cell?.detailTextLabel?.text = userInfo.data?.contact_wechat
        }
        else if 3 == indexPath.section {
            var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell3")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "UITableViewCell3")
                cell?.contentView.addSubview(textView)
                textView.text = userInfo.data?.self_introduction
                textView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 120)
            }
            return cell!
        }
        return cell!
    }
}
