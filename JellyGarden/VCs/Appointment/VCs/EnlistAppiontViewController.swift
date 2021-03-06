//
//  EnlistAppiontViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/17.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import Photos
import TZImagePickerController

class EnlistAppiontViewController: BaseMainViewController,UICollectionViewDelegate,UICollectionViewDataSource,ResponderRouter,TZImagePickerControllerDelegate,UITextViewDelegate {
    var images:[String] = []
    @IBOutlet weak var collectionTagLab: UILabel!
    @IBOutlet weak var dingjinBackView: UIView!
    @IBOutlet weak var dingjinFiled: APPTextfiled!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var scrollView: VoidKeyWordView!
    @IBOutlet weak var topBackView: UIView!
    @IBOutlet weak var appiontLab: UILabel!
    
    @IBOutlet weak var contentTextview: UITextView!
    @IBOutlet weak var appiontTime: UILabel!
    @IBOutlet weak var appiontDate: UILabel!
//    var urlPaths:[String]? = []
    
    var dateStr:String = ""
    var timeStr:String = ""
    var cityStr:String = LocalCityName {
        didSet{
            self.appiontLab.text = cityStr
        }
    }
    
    lazy var picker:ZZYdatepicker = {
        let pickerView = ZZYdatepicker()
        pickerView.back = {[weak pickerView](str) in
            DebugLog(message: "\(String(describing: str))")
            self.dateStr = str ?? ""
            self.appiontDate.text = str
            pickerView?.hidenPickerView()
        }
        return pickerView
        
    }()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize.init(width: cellWidth, height: cellWidth)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical//横向滑动
        layout.minimumLineSpacing = imageMargin
        layout.minimumInteritemSpacing = imageMargin
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(UINib.init(nibName: "AddImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AddImageCollectionViewCell")
        view.delegate = self;
        view.backgroundColor = UIColor.white
        view.isPagingEnabled = true
        view.bounces = false
        view.dataSource = self
        self.topBackView.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextview.delegate = self
        self.title = "发布报名约会广播"
        appiontLab.text = LocalCityName
        // Do any additional setup after loading the view.
    }
    @IBAction func clickSelectBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            dingjinFiled.resignFirstResponder()
            dingjinFiled.isUserInteractionEnabled = false
            dingjinFiled.text = ""
        }
        else
        {
            dingjinFiled.isUserInteractionEnabled = true
            dingjinFiled.text = ""
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RootViewController?.hideTheTabbar()
        self.rightBtn.isHidden = false
        self.rightBtn.setTitle("发布", for: UIControlState.normal)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentSize = CGSize.init(width: ScreenWidth, height: self.bottomView.frame.maxY + 50)
        self.reloadMyView()
    }
    @IBAction func clickTimeBtn(_ sender: UIButton) {
         contentTextview.resignFirstResponder()
        AlertAction.share.showbottomPicker(title: "约会时间", maxCount: 1, dataAry: appiontTimeAry, currentData: [self.appiontTime.text ?? ""]) { (result) in
            self.appiontTime.text = result.last
            self.timeStr = result.last ?? ""
        }
    }
    @IBAction func clickDateBtn(_ sender: UIButton) {
        contentTextview.resignFirstResponder()
        self.picker.showPickerView()
    }
    @IBAction func clickAppiontBtn(_ sender: UIButton) {
         contentTextview.resignFirstResponder()
        
        AlertAction.share.showbottomPicker(title: self.cityStr, maxCount: 1, dataAry: currentCitys, currentData: [self.cityStr]) { (result) in
            self.cityStr = result.last ?? self.cityStr
            
        }
       
    }
    @IBAction func clickIdentificationBtn(_ sender: UIButton) {
        let vc = IdentityAuthenticationViewController()
        RootNav().pushViewController(vc, animated: true)
    }
    override func clickRightBtn() {
        if cityStr.count == 0 {
            alertHud(title: "请输入约会城市")
            return
        }
        if dateStr.count == 0 {
            alertHud(title: "请输入约会日期")
            return
        }
        if timeStr.count == 0 {
            alertHud(title: "请输入约会时间")
            return
        }
        if contentTextview.text.count == 0 {
            alertHud(title: "请输入约会要求")
            return
        }
        
        let timeStamp = stringToTimeStamp(dateStr: dateStr,type: .day)
        let url = images.joined(separator: ",")
        let params:[String:Any] = ["poster_id":CurrentUserInfo?.user_id ?? "","time":timeStamp,"city":appiontLab.text ?? "","requirement":contentTextview.text,"attachment":url,"deposit": Int(dingjinFiled.text ?? "0") ?? 0,"need_signup":1]
        TargetManager.share.issueAppiont(params: params) { (success, error) in
            if success {
                DebugLog(message: "发布成功")
                self.clickLeftBtn()
            }

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreat ed.
    }
    func reloadMyView() {
        var newImages = images
        newImages.append(" ")
        
        let height = getImageViewHeight(imageAry: newImages)
        
        self.collectionView.frame = CGRect.init(x: imageMargin, y: collectionTagLab.frame.maxY + imageMargin, width: ScreenWidth - 2 * imageMargin, height: height)
        
        self.topBackView.frame = CGRect.init(x: self.topBackView.frame.origin.x, y: self.topBackView.frame.origin.y, width: self.topBackView.frame.width, height: self.collectionView.frame.maxY)
        self.dingjinBackView.frame.origin.y = self.topBackView.frame.maxY
        self.bottomView.frame.origin.y = self.dingjinBackView.frame.maxY + 80
        
        self.collectionView.reloadData()
        self.scrollView.contentSize = CGSize.init(width: ScreenWidth, height: self.bottomView.frame.maxY + 50)
        
        //        self.view.setNeedsLayout()
        
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
extension EnlistAppiontViewController
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCollectionViewCell", for: indexPath) as! AddImageCollectionViewCell
        if indexPath.row == images.count {
            cell.imageV.image = imageName(name: "添加照片-1")
            cell.deletBtn.isHidden = true
        }
        else
        {
            cell.imageStr = images[indexPath.row]
            
            cell.deletBtn.isHidden = false
        }
        cell.tag = indexPath.row
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == images.count {
            self.addPhotos()
        }
    }
    func addPhotos(){
        let vc = TZImagePickerController.init(maxImagesCount: 6, delegate: self)
        vc?.allowPickingVideo = false
        vc?.allowPickingImage = true
        vc?.allowTakePicture = true
        vc?.didFinishPickingPhotosHandle = {(photos, assets, isSelectOriginalPhoto) in
            self.uploadImage(sender: photos)
            
        }
        self.present(vc!, animated: true, completion: nil)
        //初始化并弹出相册页
       
    }
 
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
                guard let imageUrls = urls else{
                    return
                }
                for str in imageUrls{
                    self.images.append(str)
                }
                self.reloadMyView()
            }
            else
            {
                DebugLog(message: "上传失败")
            }
        })
    }
    
}
extension EnlistAppiontViewController
{
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            textView.backgroundColor = UIColor.white
        }
        else
        {
            textView.backgroundColor = UIColor.clear
        }
    }
}
extension EnlistAppiontViewController
{
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == ClickDeleteCell {//删除
            guard let model = info as? Int
                else {
                    return
            }
            images.remove(at: model)
            reloadMyView()
        }
    }
}
