//
//  MainViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import HTHorizontalSelectionList

var UserLocation:CLLocation = CLLocation.init(latitude: 39.388927371772, longitude: 116.1234221765776)

var LocalCityName:String = "北京" {
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
            self.leftBtn.titleLabel?.font = kFont_system15
            self.leftBtn.setTitleColor(UIColor.gray, for: UIControlState.normal)
            self.leftBtn.setImage(imageName(name: "箭头-下"), for: UIControlState.normal)
            self.bodyView.tagLocalCity = cityStr
            self.leftBtn.sizeToFit()
        }
    }
    
    lazy var cll = LocationCitys.init { (cityName, location) in
        self.cityStr = cityName!
        LocalCityName = cityName!
        UserLocation = location!
        let param:[String:Any] = ["city": self.cityStr,
                                  "lat": UserLocation.coordinate.latitude,
                                  "lon": UserLocation.coordinate.longitude,
                                  "user_id":CurrentUserInfo?.user_id ?? ""]
        TargetManager.share.uploadMyLocation(params: param, complection: nil)
    }
    
    lazy var scrollItemView: HTHorizontalSelectionList = {
        let list = HTHorizontalSelectionList()
        list.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 45)
        list.delegate = self
        list.dataSource = self
        list.bottomTrimHidden = true
        list.selectionIndicatorColor = APPCustomBtnColor
        list.setTitleFont(UIFont.systemFont(ofSize: 14), for: UIControlState.normal)
        list.setTitleColor(UIColor.black, for: UIControlState.normal)
        list.setTitleColor(APPCustomBtnColor, for: UIControlState.selected)
        list.selectionIndicatorHeight = 2
        list.centerButtons = true
        return list
    }()
    
    lazy var bodyView: MainBodyView = {
        let body = MainBodyView.init(frame: CGRect.init(x: 0,
                                                        y: self.scrollItemView.frame.maxY,
                                                        width: ScreenWidth,
                                                        height: self.view.frame.height - self.scrollItemView.frame.maxY))
        body.tagLocalCity = LocalCityName
        body.tagSex = CurrentUserInfo?.sex == 0 ? .woman : .man //sexType.init(rawValue: CurrentUserInfo?.sex ?? 1)!

        return body
    }()
    
    lazy var searchBarBtn:UIButton = {
       
        let view1 = UIView()
        view1.backgroundColor = UIColor.clear
        view1.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth - 160, height: 50)
        let width = 170 * SCALE
        let Btn = UIButton.init(frame: CGRect.init(x: (view1.bounds.width - width) / 2.0,
                                                   y: (view1.bounds.size.height - 40 ) / 2.0,
                                                   width: width,
                                                   height: 35))
        Btn.layer.cornerRadius = 20.0
        Btn.backgroundColor = APPCustomGrayColor
        Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        Btn.titleLabel?.font = kFont_Normal
        Btn.setImage(imageName(name: "搜索"), for: UIControlState.normal)
        Btn.setTitleColor(UIColor.gray, for: UIControlState.normal)

        Btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: -10)
        Btn.setTitle("搜索", for: UIControlState.normal)
        Btn.addTarget(self, action: #selector(clickSearch), for: UIControlEvents.touchUpInside)
        view1.addSubview(Btn)
        self.navigationItem.titleView = view1
        return Btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.setNavigationViewCustom()
        self.bodyView.limitRefresh()
        RootViewController?.showTheTabbar()
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.bodyView.limiteIsRefresh = false
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.bodyView.limiteIsRefresh = false
//    }
    
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
        scrollItemView.reloadData()
        scrollItemView.setSelectedButtonIndex(0, animated: false)
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
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.navigationController?.hidesBottomBarWhenPushed = true 
        // Do any additional setup after loading the view.
    }
    
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == MainBodyViewScrollPage {
            guard let index = info as? Int
            else {
                return
            }
            self.scrollItemView.setSelectedButtonIndex(index, animated: true)
            return
        }
        
        if name == ClickMainUserCell {
            let model:MainListmodel = info as! MainListmodel
            //男士无法查看男士
            let userSex = CurrentUserInfo?.sex
            if userSex == 0,userSex == model.sex {
                alertHud(title: "男士不能查看男士列表哦~")
                return
            }
            if userSex == 1,userSex == model.sex {
                alertHud(title: "女士不能查看女士列表哦~")
                return
            }
            RootViewController?.hideTheTabbar()
            if model.sex == 1 {
                let vc = PersonInfoViewController()
//                vc.showType = .validation//查看权限
                TargetManager.share.getDetailUserInfo(userid: model.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
                    guard let user = userinfo else{
                        return
                    }
                    user.distance = model.distance
                    vc.userInfoModel = user
                    RootNav().pushViewController(vc, animated: true)
                })
            }
            else
            {
                let vc = ManPersonInfoViewController()
//                vc.showType = .validation
                TargetManager.share.getDetailUserInfo(userid: model.user_id ?? "",isUpdateUser:false, complection: { (userinfo, error) in
                    guard let user = userinfo else{
                        return
                    }
                    user.distance = model.distance
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
}

extension MainViewController: HTHorizontalSelectionListDelegate {
    
    func selectionList(_ selectionList: HTHorizontalSelectionList, didSelectButtonWith index: Int) {
        bodyView.scrollToindex(index: index)
    }
}

extension MainViewController: HTHorizontalSelectionListDataSource {
    
    func numberOfItems(in selectionList: HTHorizontalSelectionList) -> Int {
        if bodyView.tagSex == .man {
            return 2
        }
        return 3
    }
    
    func selectionList(_ selectionList: HTHorizontalSelectionList, titleForItemWith index: Int) -> String? {
        
        if bodyView.tagSex == .man && 0 == index {
            return "热门"
        }
        else if bodyView.tagSex == .man && 1 == index {
            return "会员"
        }
        else if bodyView.tagSex == .woman && 0 == index {
            return "热门"
        }
        else if bodyView.tagSex == .woman && 1 == index {
            return "新来"
        }
        else {
            return "认证"
        }
    }
}
