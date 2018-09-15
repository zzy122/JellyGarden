//
//  ReportViewController.swift
//  JellyGarden
//
//  Created by kfzs on 2018/9/14.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import TZImagePickerController
class ReportViewController: BaseMainViewController,UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate {
    var images:[String] = []
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var cheatBtn: UIButton!//欺骗
    @IBOutlet weak var molestBtn: UIButton!//骚扰
    @IBOutlet weak var doubtBtn: UIButton!//怀疑
 
    @IBOutlet weak var textBackView: UIView!
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
        self.imageBackView.addSubview(view)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "举报"
       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.isHidden = false
//         reloadMyView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.rightBtn.isHidden = false
        
        self.rightBtn.setTitle("保存", for: UIControlState.normal)
    }
    override func clickRightBtn() {
        
    }
    @IBAction func clickCheatBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func clickMolestBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func clickBoubtBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
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
extension ReportViewController
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
extension ReportViewController
{
    func reloadMyView() {
        var newImages = images
        newImages.append(" ")
        
        let height = getImageViewHeight(imageAry: newImages)
        
        self.collectionView.frame = CGRect.init(x: imageMargin, y: imageMargin, width: ScreenWidth - 2 * imageMargin, height: height)
        self.imageBackView.frame = CGRect.init(x: self.imageBackView.frame.origin.x, y: self.imageBackView.frame.origin.y, width: self.imageBackView.frame.width, height: self.collectionView.frame.maxY + 80)
        self.textBackView.frame.origin.y = self.collectionView.frame.maxY
        self.collectionView.reloadData()
        
    }
    
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
