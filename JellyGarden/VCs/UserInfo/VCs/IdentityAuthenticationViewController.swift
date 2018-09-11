//
//  IdentityAuthenticationViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/2.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import Photos

class IdentityAuthenticationViewController: BaseViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var thirdViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdWarmView: UIView!
    @IBOutlet weak var detaileView: UIView!
    @IBOutlet weak var detailViewHeight: NSLayoutConstraint!
    var imagUrl:String = ""
    
    var identifyStatus:IdentityModel?
    {
        didSet{
            switch identifyStatus?.type {
            case 1://照片
                self.videoBtn.backgroundColor = APPCustomBtnColor
                self.videoBtn.setTitle("视频认证", for: UIControlState.normal)
                self.videoBtn.setImage(nil, for: UIControlState.normal)
                self.videoBtn.isUserInteractionEnabled = true
                switch identifyStatus?.status {
                case "nodata"://未认证
                    self.imageBtn.backgroundColor = APPCustomBtnColor
                    self.imageBtn.setTitle("上传认证自拍", for: UIControlState.normal)
                    self.imageBtn.setImage(nil, for: UIControlState.normal)
                    self.imageBtn.isUserInteractionEnabled = true
                    break
                case "success"://成功
                    self.imageBtn.backgroundColor = APPCustomRedColor
                    self.imageBtn.setTitle("已通过自拍认证", for: UIControlState.normal)
                    self.imageBtn.setImage(imageName(name: "勾"), for: UIControlState.normal)
                    self.imageBtn.isUserInteractionEnabled = false
                    break
                case "failed"://认证失败
                    self.imageBtn.backgroundColor = APPCustomBtnColor
                    self.imageBtn.setTitle("认证失败", for: UIControlState.normal)
                    self.imageBtn.setImage(nil, for: UIControlState.normal)
                    self.imageBtn.isUserInteractionEnabled = true
                    break
                case "checking"://认证中
                    self.imageBtn.backgroundColor = UIColor.gray
                    self.imageBtn.setTitle("已上传自拍认证", for: UIControlState.normal)
                    self.imageBtn.setImage(nil, for: UIControlState.normal)
                    self.imageBtn.isUserInteractionEnabled = false
                    break
                    
                default:
                    break
                }
                
                break
            case 2://视屏
                self.imageBtn.backgroundColor = APPCustomBtnColor
                self.imageBtn.setTitle("上传认证自拍", for: UIControlState.normal)
                self.imageBtn.setImage(nil, for: UIControlState.normal)
                self.imageBtn.isUserInteractionEnabled = true
                switch identifyStatus?.status {
                case "nodata"://未认证
                    self.videoBtn.backgroundColor = APPCustomBtnColor
                    self.videoBtn.setTitle("视频认证", for: UIControlState.normal)
                    self.videoBtn.setImage(nil, for: UIControlState.normal)
                    self.videoBtn.isUserInteractionEnabled = true
                    break
                case "success"://成功
                    self.videoBtn.backgroundColor = APPCustomRedColor
                    self.videoBtn.setTitle("已通过视频认证", for: UIControlState.normal)
                    self.videoBtn.setImage(imageName(name: "勾"), for: UIControlState.normal)
                    self.videoBtn.isUserInteractionEnabled = false
                    break
                case "failed"://认证失败
                    self.videoBtn.backgroundColor = APPCustomBtnColor
                    self.videoBtn.setTitle("认证失败", for: UIControlState.normal)
                    self.videoBtn.setImage(nil, for: UIControlState.normal)
                    self.videoBtn.isUserInteractionEnabled = true
                    break
                case "checking"://认证中
                    self.videoBtn.backgroundColor = UIColor.gray
                    self.videoBtn.setTitle("已上传视频认证", for: UIControlState.normal)
                    self.videoBtn.setImage(nil, for: UIControlState.normal)
                    self.videoBtn.isUserInteractionEnabled = false
                    break
                    
                default:
                    break
                }
                
                break
            case 3://其他
                break
            default:
                break
            }
        }
        
    }
    
    var vedioUrl:String = ""

    var imageVC:UIImagePickerController = {
        let imagevc = UIImagePickerController()
        imagevc.sourceType = .camera
        imagevc.allowsEditing = true
        return imagevc
    }()
    var aliyunModel:AliyunUploadModel?
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var imageView: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "认证身份"
        videoBtn.layer.cornerRadius = 20
        videoBtn.clipsToBounds = true
        imageBtn.layer.cornerRadius = 20
        imageBtn.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        
        let str = [["type":"text","content":"1、取一张纸,写上你的昵称和以下号码: ","corlor":"gray","size":15],["type":"text","content":"986544\n","color":"blue","size":15],["type":"text","content":"2、拿着这张纸与你的头像所示部位合照一张","corlor":"gray","size":15]]
        let config = ZZYFramParserConfig()
        config.lineSpace = 15
        config.width = ScreenWidth - 20
        
        let textData = ZZYFrameParser.parseContent(str, config: config)
        let view1 = ZZYDisplayView()
        view1.data = textData!
        view1.frame = CGRect.init(x: 0, y: 0, width: config.width, height: textData?.height ?? 0)
        detailViewHeight.constant = textData?.height ?? 0
        detaileView.addSubview(view1)
        view1.backgroundColor = UIColor.clear
        let str1 = [["type":"text","content":"请添加官方微信 ","corlor":"gray","size":15],["type":"text","content":"1823748","color":"blue","size":15],["type":"text","content":"进行认证","corlor":"gray","size":15]]
        let config1 = ZZYFramParserConfig()
        config1.lineSpace = 15
        config1.isCenter = true
        config1.width = ScreenWidth - 20
        let textData1 = ZZYFrameParser.parseContent(str1, config: config1)
        let view2 = ZZYDisplayView()
        view2.data = textData1!
        view2.frame = CGRect.init(x: 0, y: 0, width:  config1.width, height: textData1?.height ?? 0)
        detailViewHeight.constant = textData?.height ?? 0
        thirdViewHeight.constant = textData1?.height ?? 0
        thirdWarmView.addSubview(view2)
        view2.backgroundColor = UIColor.clear
        
        getMyStatus()
    }
    @IBAction func clickImage(_ sender: UIButton){
        imageVC.delegate = self
        self.present(self.imageVC, animated: true) {
            
        }

        
    }
    func getMyStatus() {
        
        TargetManager.share.checkIdentyResult { (model, error) in
            guard let model1 = model else
            {
                return
            }
            self.identifyStatus = model1
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scrollView.contentSize = CGSize.init(width: ScreenWidth, height: thirdWarmView.frame.maxY + 70)
    }
    @IBAction func clickVideoBtn(_ sender: UIButton) {
        
        let vc = WCLRecordVideoVC()
        vc.recordVideoResult({ (path) in
            guard let vidioStr = path, vidioStr.count > 0 else{
                return
            }
            let filePath = self.getPathStr()
            try? FileManager.default.moveItem(atPath: vidioStr, toPath: filePath)
            HUD.flash(.labeledProgress(title: nil, subtitle: "视频上传中..."))
            AliyunManager.share.uploadVedioToAliyun(vedioPath: filePath, vedioName: "\(CurrentUserInfo?.user_id ?? "renzheng").mp4", complection: { (backStr, state) in
                if state == UploadImageState.success
                {
                    HUD.hide(animated: true)
                    self.vedioUrl = backStr ?? ""
                    try? FileManager.default.removeItem(atPath: filePath)
                     let param = ["user_id":CurrentUserInfo?.user_id ?? "", "video_path":self.vedioUrl]
                    TargetManager.share.certificationVideoUser(params: param, complection: { (success) in
                         self.getMyStatus()
                    })
                    DebugLog(message: "上传成功\(backStr ?? "没有")")
                }
            })
            
            DebugLog(message: "\(vidioStr)")
        })
        
        RootNav().present(vc, animated: true, completion: {
            
        })
    }
    
    func getPathStr() ->String
    {
        
        let path = "\(documentPath)/videos"
        if !FileManager.default.fileExists(atPath: path)
        {
            do {
                 try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error
            {
               DebugLog(message: error.localizedDescription)
            }
           
        }
        let filePath = "\(path)/\(CurrentUserInfo?.user_id ?? "renzheng").mp4"
        if !FileManager.default.fileExists(atPath: path)
        {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
            
        }
        return filePath
        
    }
    @IBAction func clickImageBtn(_ sender: UIButton) {
         uploadImageModel()
        
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
extension IdentityAuthenticationViewController
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let type:String = (info[UIImagePickerControllerMediaType]as!String)
        //当选择的类型是图片
        if type=="public.image"
        {
            let img = info[UIImagePickerControllerOriginalImage]as?UIImage
            guard let imag = img else{
                return
            }
            let model = AliyunUploadModel()
            model.image = imag
            model.fileName = getImageName()
            self.aliyunModel = model
            self.imageView.setBackgroundImage(imag, for: UIControlState.normal)
            picker.dismiss(animated:true, completion:nil)
        }
    }
    func uploadImageModel()
    {
        guard let model = self.aliyunModel else{
            alertHud(title: "请拍照")
            return
        }
        AliyunManager.share.uploadImagesToAliyun(imageModels: [model], complection: { (urls, succecCount, failCount, state) in
            if state == UploadImageState.success
            {//认证
                self.imagUrl = urls?.last ?? ""
                let param = ["user_id":CurrentUserInfo?.user_id ?? "", "image_path":self.imagUrl]
                TargetManager.share.certificationImageUser(params: param, complection: { (succcess) in
                    self.getMyStatus()
                })
            }
            else
            {
                DebugLog(message: "上传失败")
            }
        })
    }
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController){
        self.imageVC.dismiss(animated:true, completion:nil)
    }
}
