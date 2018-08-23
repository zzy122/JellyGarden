//
//  FillInformationFirstViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import AliyunOSSiOS
//import AliyunOSSSwiftSDK
class FillInformationFirstViewController: BaseViewController,ResponderRouter,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    lazy var scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = self.view.bounds
        scroll.backgroundColor = UIColor.clear
        scroll.bounces = false
        self.view.addSubview(scroll)
        return scroll
        
    }()
    var headerImage:UIImage? {
        didSet{
            self.bodyView.headerImageBtn.setBackgroundImage(headerImage, for: UIControlState.normal)
        }
    }
    var imagePath:String?
    
    
    var nextBtn:UIButton?
    lazy var stepView:StepView = {
        let view = StepView.createStepView(step: 1)
        view?.tagFram = CGRect.init(x: 50, y: 10, width: ScreenWidth - 100, height: 20)
        return view!
    }()
    lazy var bodyView:FillInfoView = {
        let view1 = FillInfoView.createFillInfoView(frame: CGRect.init(x: 0, y: self.stepView.tagFram!.maxY + 30, width: ScreenWidth, height: 400))
        return view1!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "完善资料"
        self.createMianView()
        
        // Do any additional setup after loading the view.
    }
    func createMianView() {
        self.stepView.isHidden = false
        
        self.scrollView.addSubview(stepView)
        self.scrollView.addSubview(self.bodyView)
        nextBtn = createCustomBtn(frame: CGRect.init(x: 30, y: (self.bodyView.tagFrame?.maxY)! + 60, width: ScreenWidth - 60, height: BTNHEIGHT), sel: #selector(clickNextBtn(sender:)), target: self, title: "下一步")
        self.scrollView.addSubview(nextBtn!)
        self.scrollView.contentSize = CGSize.init(width: ScreenWidth, height: nextBtn!.frame.maxY + 10)
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @objc func clickNextBtn(sender:UIButton)
    {
        guard let imageStr = (imagePath == nil ) ? bodyView.imageUrlStr : imagePath else {
            alertHud(title: "请选择头像")
            return
        }
        guard let nicheng = bodyView.subTitle.first,nicheng.count > 0 else {
            alertHud(title: "请输入昵称")
            return
        }
        guard let range = bodyView.oppintRange,range.count > 0  else {
            alertHud(title: "请选择约会范围")
            return
        }
        guard let age = bodyView.age,age.count > 0 else {
            alertHud(title: "请选择年龄")
            return
        }
        guard let identity = bodyView.identity,identity.count > 0 else {
            alertHud(title: "请选择身份")
            return
        }
        guard let bodyHeight = bodyView.bodyHeight,bodyHeight.count > 0 else {
            alertHud(title: "请输入身高")
            return
        }
        guard let bodyWeight = bodyView.bodyWeight,bodyWeight.count > 0 else {
            alertHud(title: "请输入体重")
            return
        }
        guard let bodyChest = bodyView.bodyChest,bodyChest.count > 0 else {
            alertHud(title: "请输入胸围")
            return
        }
        
       
//       let aryJson = getJSONStringFromObject(dictionary: range)
        //身高没有
        var manStr:String = "1"  //0男 1女
        
        if UserDefaults.standard.bool(forKey: RegisterSexMan)
        {
            manStr = "0"
        }
        
        
        let user_json = ["nickname":nicheng,"appointment_place":range,"age":(age as NSString).floatValue,"identity":identity,"weight":(bodyWeight as NSString).floatValue,"bust":(bodyChest as NSString).floatValue,"sex":manStr,"stature":(bodyHeight as NSString).floatValue,"avatar":imageStr] as [String : Any]
        let infoVC = FillInformationViewController()
        infoVC.fillInfo = user_json
        self.navigationController?.pushViewController(infoVC, animated: true)
        
    }
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == FillInfoViewClick {
            if let index = info as? Int {
                DebugLog(message: "\(index)")
            }
        }
        if name == ClickFillInfoViewHeader {
            //打开相册
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
                    DebugLog(message: "上传成功\(String(describing: urls?.last))")
                    self.imagePath = urls?.last
                    self.headerImage = image
                    
                }
                else
                {
                    DebugLog(message: "上传失败")
                }
            })
        }
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
