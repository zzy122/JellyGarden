//
//  ManFillInformationViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/27.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HandyJSON
class ManFillInformationViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var bottomBtn: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var nickNameLab: UILabel!
    @IBOutlet weak var localLab: UILabel!
    @IBOutlet weak var ageLab: UILabel!
    @IBOutlet weak var professionalLab: UILabel!
    @IBOutlet weak var headerIMV: UIButton!
    var imagePath:String?
    var dataAry:[String] = []
    var currentData:[String] = [] {
        didSet{
            self.contentTextView.text = continueString(strAry: currentData,separetStr:"  ")
        }
    }
    var oppintRange:[String]? {
        didSet{
            self.localLab.text = continueString(strAry: oppintRange, separetStr: "  ")
        }
    }
    let ageList:[PikerModel] = {
        var dicAry:[[String:Any]] = []
        for i in 15 ..< 46 {
            let dic:[String:Any] = ["citysName":i]
            dicAry.append(dic)
        }
        return JSONDeserializer<PikerModel>.deserializeModelArrayFrom(array: dicAry) as! [PikerModel]
    }()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let scroll = UICollectionView.init(frame: self.itemBackView.bounds, collectionViewLayout: layout)
        
        scroll.backgroundColor = UIColor.clear
        scroll.register(UINib.init(nibName: "BottomPickerCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BottomPickerCell")
        scroll.delegate = self
        
        scroll.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10 )
        scroll.dataSource = self
        scroll.isScrollEnabled = false
        return scroll
    }()
    @IBOutlet weak var itemBackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "填写信息"
        contentTextView.layer.cornerRadius = 5.0
        contentTextView.clipsToBounds = true
        headerIMV.layer.cornerRadius = 40
        headerIMV.clipsToBounds = true
        contentTextView.delegate = self
        bottomBtn.layer.cornerRadius = 20
        bottomBtn.clipsToBounds = true
        self.dataAry = FillCondition.share.conditionTag
        self.collectionView.isHidden = false
        self.itemBackView.addSubview(self.collectionView)
        if let imageUrl = CurrentUserInfo?.avatar,imageUrl.count > 0 {
            self.headerIMV.imageView?.sd_DownLoadImage(url: imageUrl)
        }
        self.nickNameLab.text = CurrentUserInfo?.nickname
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        self.headerIMV.imageView?.sd_DownLoadImage(url: CurrentUserInfo?.avatar ?? "")
        nickNameLab.text = CurrentUserInfo?.nickname
        contentTextView.text = CurrentUserInfo?.self_introduction
        localLab.text = CurrentUserInfo?.appointment_place?.joined(separator: " ")
        ageLab.text = "\(CurrentUserInfo?.age ?? 18)"
        professionalLab.text = CurrentUserInfo?.identity
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickNickNameBtn(_ sender: UIButton) {
        contentTextView.resignFirstResponder()
        AlertAction.share.showAlertView(type: nil,title: "昵称", placeHodel: "请输入昵称", textStr:nil,detailTitle: nil, detailImage: nil, click: { (sure, result) in
            if sure {
                self.nickNameLab.text = result
            }
        })
    }
    @IBAction func clickLocalBtn(_ sender: UIButton) {
        contentTextView.resignFirstResponder()
        AlertAction.share.showbottomPicker(title: "约会范围", maxCount: 4, dataAry: currentCitys, currentData: self.oppintRange, backData: { (result) in
            self.oppintRange = result
            
        })
    }
    @IBAction func clickAgeBtn(_ sender: UIButton) {
        contentTextView.resignFirstResponder()
        var data:[String]? = []
        
        if let agestr = ageLab.text,agestr.count > 0 {
            data = [agestr]
        }
        
        AlertAction.share.showbottomPicker(title: "选择年龄", maxCount: 1, dataAry: ageList, currentData: data, backData: { (result) in
            
            self.ageLab.text = result.last
        })
    }
    @IBAction func clickProfessionalBtn(_ sender: UIButton) {
        contentTextView.resignFirstResponder()
        
        AlertAction.share.showAlertView(type: nil,title: "职业", placeHodel: "请输入职业", textStr:nil,detailTitle: nil, detailImage: nil, click: { (sure, result) in
            if sure {
                self.professionalLab.text = result
            }
        })
        
    }
    
    @IBAction func clickHeaderImv(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: {
                
            })
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image:UIImage!
        image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        picker.dismiss(animated: true) {
            
            let imageStr = "\(CurrentUserInfo?.phone ?? "no").png"
            HUD.flash(.labeledProgress(title: nil, subtitle: "请稍后..."))
            let model = AliyunUploadModel()
            model.image = image
            model.fileName = imageStr
            AliyunManager.share.uploadImagesToAliyun(imageModels: [model], complection: { (urls, succecCount, failCount, state) in
                if state == UploadImageState.success
                {
                    DispatchQueue.main.async {
                        DebugLog(message: "上传成功\(String(describing: urls?.last))")
                        self.imagePath = urls?.last
                        self.headerIMV.setImage(image, for: UIControlState.normal)
                    }
                }
                else
                {
                    DebugLog(message: "上传失败")
                }
            })
        }
    }
    @IBAction func gotoMainView(_ sender: UIButton) {
        
        guard let url = self.imagePath,url.count > 0 else {
            alertHud(title: "请选择头像")
            return
        }
        guard let nikeStr = self.nickNameLab.text,nikeStr.count > 0 else {
            alertHud(title: "请填写昵称")
            return
        }
        guard let cityStr = oppintRange,cityStr.count > 0 else {
            alertHud(title: "请选择约会范围")
            return
        }
        guard let ageStr = self.ageLab.text,ageStr.count > 0 else {
            alertHud(title: "请选择年龄")
            return
        }
        guard let professionStr = self.professionalLab.text,professionStr.count > 0 else {
            alertHud(title: "请选择职业")
            return
        }
        
//        var fillInfo:[String:Any] = ["nickname":nikeStr,"avatar":url,"appointment_place":cityStr,"age":(ageStr as NSString).floatValue,"identity":professionStr,"sex":"0","language":[],"bust":0,"contact_wechat":"","contact_qq":"","dress_style":[],"appointment_program":[],"emotion_status":"","stature":0,"weight":0,"appointment_condition":[],"self_introduction":"",]
        var fillInfo:[String:Any] = ["stature": 0, "dress_style": "", "nickname": nikeStr, "age": (ageStr as NSString).intValue, "identity": professionStr, "language": "", "appointment_place":cityStr.joined(separator: ","), "contact_qq": "",  "emotion_status": "", "appointment_condition": "", "avatar": url, "contact_wechat": "", "weight": 0, "appointment_program": "", "user_id": CurrentUserInfo?.user_id ?? "", "sex": 0, "bust": 0]
        fillInfo["tags"] = []
        if contentTextView.text.count > 0 {
            fillInfo["tags"] = currentData
            fillInfo["self_introduction"] = contentTextView.text
            
        }
        
//        let param:[String:Any] = ["user_json":getJSONStringFromObject(dictionary: fillInfo)]
        
        TargetManager.share.fillUserInfo(params: fillInfo) { (result, error) in
            if error == nil {
                updateUserInfo(complection: { (result) in
                    
                })
                
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.setRootViewController(vc: BaseTabBarViewController())
            }
        }
    }


}
extension ManFillInformationViewController
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataAry.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:BottomPickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomPickerCell", for: indexPath) as! BottomPickerCell
        cell.contentLab.text = dataAry[indexPath.row]
        cell.contentLab.textColor = UIColor.gray
        cell.layer.cornerRadius = 5.0
        cell.clipsToBounds = true
        cell.contentLab.backgroundColor = APPCustomGrayColor
        cell.contentLab.font = kFont_system14
        for str in currentData {
            if str == dataAry[indexPath.row]
            {
                cell.contentLab.textColor = UIColor.white
                cell.contentLab.backgroundColor = APPCustomBtnColor
            }
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BottomPickerCell
        let str = dataAry[indexPath.row]
        for i in 0 ..< currentData.count {
            let exiStr = currentData[i]
            if str == exiStr {
                cell.contentLab.textColor = UIColor.gray
                cell.contentLab.backgroundColor = APPCustomGrayColor
                currentData.remove(at: i)
                return
            }
        }
        cell.contentLab.textColor = UIColor.white
        cell.contentLab.backgroundColor = APPCustomBtnColor
        currentData.append(str)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let str = dataAry[indexPath.row]
        let width = str.zzy.caculateWidth(font: kFont_system14) + 8
        return CGSize.init(width: width, height: 30)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.currentData = textView.text.components(separatedBy: "  ")
    }
}
