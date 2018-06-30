//
//  NormalAppointmentViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/16.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import Photos
let imageMargin:CGFloat = 10.0
let cellWidth = (ScreenWidth - 3 * imageMargin - 20) / 5.0
let appiontTimeAry:[PikerModel]? = {
    
    return getPikerModels(data: ["上午","中午","下午","晚上","通宵","一整天"])
}()
func getImageViewHeight(imageAry:[Any]) -> CGFloat {
    
    let intege:Int = getLines(ary: imageAry, veryCount: 4)
    return CGFloat(intege) * (cellWidth + imageMargin)
}
class NormalAppointmentViewController: BaseMainViewController,UICollectionViewDelegate,UICollectionViewDataSource,PhotoPickerControllerDelegate,ResponderRouter,UITextViewDelegate,UICollectionViewDelegateFlowLayout {
    var urlPaths:[String]? = []
    
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
    var images:[String] = []
    var dateStr:String = ""
    var timeStr:String = ""
    var cityStr:String = LocalCityName
    {
        didSet{
            self.appiontCity.text = cityStr
        }
    }
    
    @IBOutlet weak var centerrView: UIView!
    @IBOutlet weak var collectionTagLab: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var identificationBtn: UIButton!
    @IBOutlet weak var scrollView: VoidKeyWordView!
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var dingJinFiled: APPTextfiled!
    @IBOutlet weak var appiontTime: UILabel!
    @IBOutlet weak var appiontDate: UILabel!
    @IBOutlet weak var appiontCity: UILabel!//约会城市
    @IBOutlet weak var contentStr: UITextView!
    
    
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
        self.topContentView.addSubview(view)
        return view
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentStr.delegate = self
        self.title = "发布普通约会广播"
        self.appiontCity.text = LocalCityName
        self.edgesForExtendedLayout = UIRectEdge.bottom
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    @IBAction func clickAppiontDateBtn(_ sender: UIButton) {
        contentStr.resignFirstResponder()
        self.picker.showPickerView()
    }
    
    @IBAction func clickAppiontTimeBtn(_ sender: UIButton) {
        contentStr.resignFirstResponder()
        AlertAction.share.showbottomPicker(title: "选择时间", maxCount: 1, dataAry: appiontTimeAry, currentData: [appiontTime.text ?? ""]) { (result) in
            self.timeStr = result.last ?? ""
            self.appiontTime.text = result.last
        }
    }
    @IBAction func clickAppiontCityBtn(_ sender: UIButton) {
         contentStr.resignFirstResponder()
        AlertAction.share.showbottomPicker(title: self.cityStr, maxCount: 1, dataAry: currentCitys, currentData: [self.cityStr]) { (result) in
            self.cityStr = result.last ?? self.cityStr
            
        }
    }
    @IBAction func clickIdentificationBtn(_ sender: UIButton) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RootViewController?.hideTheTabbar()
        self.rightBtn.isHidden = false
        self.rightBtn.setTitle("发布", for: UIControlState.normal)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentSize = CGSize.init(width: ScreenWidth, height: self.identificationBtn.frame.maxY)
        self.reloadMyView()
    }
//    override func loadView() {
//
//    }
    func reloadMyView() {
        var newImages = images
        newImages.append(" ")

        let height = getImageViewHeight(imageAry: newImages)
        
        self.collectionView.frame = CGRect.init(x: imageMargin, y: collectionTagLab.frame.maxY + imageMargin, width: ScreenWidth - 2 * imageMargin, height: height)
        
        self.topContentView.frame = CGRect.init(x: self.topContentView.frame.origin.x, y: self.topContentView.frame.origin.y, width: self.topContentView.frame.width, height: self.collectionView.frame.maxY)
      
        self.centerrView.frame.origin.y = self.topContentView.frame.maxY + 10
        self.bottomView.frame.origin.y = self.centerrView.frame.maxY + 80
        
        self.collectionView.reloadData()
        self.scrollView.contentSize = CGSize.init(width: ScreenWidth, height: self.bottomView.frame.maxY)
        
    }
    override func clickRightBtn() {
        if contentStr.text.count == 0 {
            alertHud(title: "请输入约会要求")
            return
        }
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
        let timeStamp = stringToTimeStamp(dateStr: dateStr)
        let url = continueString(strAry: urlPaths,separetStr:",")
        let params:[String:Any] = ["poster_id":CurrentUserInfo?.data?.user_id ?? "","time":timeStamp,"city":appiontCity.text ?? "","requirement":contentStr.text,"attachment":url,"deposit": Int(dingJinFiled.text ?? "0") ?? 0,"need_signup":false]
        
        TargetManager.share.issueAppiont(params: params) { (success, error) in
            if success {
                DebugLog(message: "发布成功")
                self.clickLeftBtn()
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
extension NormalAppointmentViewController
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
        //初始化并弹出相册页
        let vc = QPPhotoPickerViewController(type: PageType.AllAlbum)
        vc.imageSelectDelegate = self
        //最大照片数量
        vc.imageMaxSelectedNum = 6
        vc.alreadySelectedImageNum = images.count
        self.present(vc, animated: true, completion: nil)
    }
    //添加照片的协议方法
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
            model.image = imageModel.smallImage
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
extension NormalAppointmentViewController
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
extension NormalAppointmentViewController
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

extension NormalAppointmentViewController
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize.init(width: cellWidth, height: cellWidth)
    }
}
