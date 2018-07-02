//
//  MainViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
var UserLocation:CLLocation = CLLocation.init(latitude: 39.388927371772, longitude: 116.1234221765776)
var LocalCityName:String = "北京"
{
    didSet{
        UserLocation = locationEncode(cityName: LocalCityName) ?? CLLocation.init(latitude: 39.388927371772, longitude: 116.1234221765776)
    }
}
class MainViewController: BaseMainViewController,UISearchBarDelegate,ResponderRouter {
    
    var cityStr:String = LocalCityName {
        didSet{
            LocalCityName = cityStr
            
            self.leftBtn.isHidden = false
            self.leftBtn.setTitle(cityStr, for: UIControlState.normal)
            self.leftBtn.setTitleColor(UIColor.gray, for: UIControlState.normal)
            self.leftBtn.setImage(imageName(name: "选中"), for: UIControlState.normal)
            self.bodyView.tagLocalCity = cityStr
            self.leftBtn.sizeToFit()
        }
    }
    
    lazy var cll = LocationCitys.init { (cityName, location) in
        self.cityStr = cityName!
        LocalCityName = cityName!
        UserLocation = location!
        let param:[String:Any] = ["city":self.cityStr,"lat":UserLocation.coordinate.latitude,"lon":UserLocation.coordinate.longitude]
        TargetManager.share.uploadMyLocation(params: param, complection: { (result, error) in
            
        })
        
        DebugLog(message: "\(String(describing: cityName))\(String(describing: location?.coordinate.latitude))")
    }
    
    lazy var scrollItemView:ITemScrollView = {
        let itemScroll = ITemScrollView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 45), dataAry: ["热门","新来","认证"], back: { (index) in
            self.bodyView.scrollToindex(index: index)
        })
        return itemScroll
        
    }()
    lazy var bodyView:MainBodyView = {
        let body = MainBodyView.init(frame: CGRect.init(x: 0, y: self.scrollItemView.frame.maxY, width: ScreenWidth, height: self.view.frame.height - self.scrollItemView.frame.maxY))
        body.typeAry = [SearchType.hot,SearchType.new,SearchType.attestation]
        body.tagLocalCity = LocalCityName
        body.tagSex = (CurrentUserInfo?.data?.sex == 0) ? .woman : .man
        return body
    }()
    lazy var searchBarBtn:UIButton = {
       
        
        let Btn = UIButton.init(frame: CGRect.init(x: 60, y: 10, width: ScreenWidth - 120, height: 40))
        Btn.layer.cornerRadius = 20.0
        Btn.backgroundColor = APPCustomGrayColor
        Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        Btn.titleLabel?.font = kFont_Normal
        Btn.setImage(imageName(name: "搜索"), for: UIControlState.normal)
        Btn.setTitleColor(UIColor.gray, for: UIControlState.normal)

        Btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: -10)
        Btn.setTitle("搜索", for: UIControlState.normal)
        Btn.addTarget(self, action: #selector(clickSearch), for: UIControlEvents.touchUpInside)
        
        self.navigationItem.titleView = Btn
        return Btn
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self .setNavigationViewCustom()
        RootViewController?.showTheTabbar()
    }
    func setNavigationViewCustom() {
      
        self.leftBtn.isHidden = false
        
        self.leftBtn.leftTitie = true
        self.rightBtn.isHidden = false
        self.rightBtn.setImage(imageName(name: "切换"), for: UIControlState.normal)
        
    }
    override func clickLeftBtn() { 
        AlertAction.share.showbottomPicker(title: self.cityStr, maxCount: 1, dataAry: currentCitys, currentData: [self.cityStr]) { (result) in
            self.cityStr = result.last ?? self.cityStr

        }
        
    }
    override func clickRightBtn() {
        self.bodyView.tagSex = (bodyView.tagSex == .woman) ? .man : .woman
    }
    @objc func clickSearch(){
        self.navigationController?.pushViewController(SearchUserViewController(), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBarBtn.isHidden = false
        cll.startLocation()
        self.view.addSubview(self.scrollItemView)
        self.view.addSubview(self.bodyView)
        
        
        // Do any additional setup after loading the view.
    }
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == MainBodyViewScrollPage {
            guard let inte = info as? Int
            else
            {
                return
            }
            self.scrollItemView.setItemtarget(index: inte)
            
        }
        if name == ClickMainUserCell {
            let model:MainListmodel = info as! MainListmodel
            //男士无法查看男士
            let userSex = CurrentUserInfo?.data?.sex
            if userSex == 0,userSex == model.sex
            {
                alertHud(title: "男士不能查看男士列表哦~")
                return
            }
            if userSex == 1,userSex == model.sex
            {
                alertHud(title: "女士不能查看女士列表哦~")
                return
            }
            RootViewController?.hideTheTabbar()
            if model.sex == 1
            {
                
                let vc = PersonInfoViewController()
                
                TargetManager.share.getDetailUserInfo(userid: model.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
                    guard let user = userinfo else{
                        return
                    }
                    vc.userInfoModel = user
                    RootNav().pushViewController(vc, animated: true)
                })
            }
            else
            {
                let vc = ManPersonInfoViewController()
                
                TargetManager.share.getDetailUserInfo(userid: model.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
                    guard let user = userinfo else{
                        return
                    }
                    vc.userInfoModel = user
                    RootNav().pushViewController(vc, animated: true)
                })
            }
           
        }
    }

    override func viewDidLayoutSubviews() {
        self.bodyView.frame = CGRect.init(x: 0, y: self.scrollItemView.frame.maxY, width: ScreenWidth, height: self.view.frame.height - self.scrollItemView.frame.maxY)
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
