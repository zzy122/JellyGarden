//
//  LookImageViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/8.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
enum LookImageType
{
    case effect;//模糊
    case clearness;//清晰
    case lookAfter;//看了后
}
class LookImageViewController: BaseViewController,ResponderRouter {

    var type = LookImageType.clearness {
        didSet {
            self.imageView.starLookEffect(type: type)
        }
    }
    var model:PhotoModel?
    {
        didSet{
            self.imageUrl = model?.url_list ?? ""
            var typeLook:LookImageType = .clearness
            switch model?.type {
            case 0?://普通
                break
            case 1?://阅后即焚
                typeLook = .effect
                break
            case 2?://红包
                break
            case 3?://已焚毁
                self.type = .lookAfter
                break
            default:
                break
            }
            self.type = typeLook
        }
    }
    var imageUrl:String = ""
    lazy var buttomView:ReckonTimeView = {
        
        let view1 = ReckonTimeView.init(frame:CGRect.init(x: 0, y: self.imageView.frame.maxY, width: ScreenWidth, height: ScreenHeight - self.imageView.frame.maxY), time: 4.0, runComplection: { (complete) in//查看完成
            self.runtimeComplection()
        })
        self.view.addSubview(view1)
        return view1
    }()
    
    lazy var imageView:LookImageBodyView = {
        let view1 = LookImageBodyView.createLookImageView()
        view1?.frame = CGRect.init(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 140)
        self.view.addSubview(view1!)
        return view1!
        
    }()
    func runtimeComplection()
    {
        self.type = LookImageType.lookAfter
        self.buttomView.isHidden = true
        
        此处待定参数
        TargetManager.share.readImageForUserid(params: ["user_id":CurrentUserInfo?.user_id ?? "",""], complection: <#T##(ReadImageModel?, Error?) -> Void#>)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.isHidden = false
        self.imageView.imageBack.sd_DownLoadImage(url: self.imageUrl, complection: { (image) in
            self.imageView.imageBack.image = image
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.leftBtn.setImage(imageName(name: "navi_back"), for: UIControlState.normal)
        self.imageView.isHidden = false
        self.view.backgroundColor = UIColor.black
        self.imageView.starLookEffect(type: type)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if finishLookComplete == name {
            self.buttomView.isHidden = false
            self.buttomView.starAnimatin()
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
