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
    }
    @IBAction func clickImage(_ sender: UIButton){
        imageVC.delegate = self
        self.present(self.imageVC, animated: true) {
            
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
            AliyunUpload.share().upLoadVedio(toAliyun: filePath, name: "\(CurrentUserInfo?.data?.user_id ?? "renzheng").mp4", complection: { (backStr, state) in
                if state == UploadImageState.success
                {
                    HUD.hide(animated: true)
                    try? FileManager.default.removeItem(atPath: filePath)
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
        let filePath = "\(path)/\(CurrentUserInfo?.data?.user_id ?? "renzheng").mp4"
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
