//
//  VipCenterViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class VipCenterViewController: BaseViewController,ResponderRouter {
    lazy var scrollView:UIScrollView = {
       let scroll = UIScrollView()
        scroll.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        scroll.bounces = false
        scroll.backgroundColor = UIColor.clear
        scroll.addSubview(self.backView)
        self.view.addSubview(scroll)
        return scroll
    }()
    var pageModels:[VipPageModel]?
    var currentModel:VipPageModel?
    var autoPayBtn:UIButton = UIButton()
    
    let selectedPayView = PaySelectView.createPaySelectView()!
    
    lazy var backView:UIView = {
        let view1 = UIView()
//        view1.backgroundColor = k_CustomColor(red: 243, green: 245, blue: 249)
        view1.backgroundColor = UIColor.clear
        return view1
    }()
    override func viewWillLayoutSubviews() {
        self.scrollView.frame = CGRect.init(x: 0, y: -64, width: ScreenWidth, height: ScreenHeight + 64)
    }
    
    lazy var itemAry:[PackageView] = {
        let distance:CGFloat = 15.0
        let height:CGFloat = 80.0
        let width = (ScreenWidth - 5.0 * distance) / 4.0
        let ary = NSMutableArray()
        for i in 0 ..< 4
        {
            let item = PackageView.getPackageView()!
            item.tagFrame = CGRect.init(x: distance + CGFloat(i) * (width + distance), y: self.topView.frame.maxY - height / 2.0, width: width, height: height)
            item.tag = i
            if i == 0 {
                item.isSelected = true
            }
            ary.add(item)
            
        }
        return ary as! [PackageView]
    }()
    lazy var topView:UIImageView = {
        return UIImageView()
    }()
    
    var isHaveUserHeader:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会员中心"
        self.createView()
        self.getPageData()
        // Do any additional setup after loading the view.
    }
    func getPageData() {
        TargetManager.share.getVipPackages { (models, erorr) in
            guard let modeAry = models else
            {
                return
            }
            self.pageModels = modeAry
            self.currentModel = modeAry.first
            for i:Int in 0 ..< modeAry.count
            {
                let view1 = self.itemAry[i]
                view1.model = modeAry[i]
               
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isHaveUserHeader  {
            leftBtn.setImage(imageName(name: "navi_back"), for: UIControlState.normal)
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:kFont_system20]
    }
    func createView() {
        topView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 200)
        topView.backgroundColor = k_CustomColor(red: 18, green: 38, blue: 74)
        
        backView.insertSubview(topView, at: 0)
        let selectLable = creatLable(frame: CGRect.init(x: 20, y: 70, width: 200, height: 20), title: "选择套餐", font: kFont_SmallNormal, textColor: UIColor.white)
        selectLable.backgroundColor = UIColor.clear
        
        if isHaveUserHeader {//头像板块
//            let model = CurrentUserInfo
//            model?.data?.vip_level = 2
//            model?.data?.vip_expire_time = 172637612731
//            let user = model?.toJSON()
//            NSDictionary.init(dictionary: user ?? [:]).write(toFile: UserPlist, atomically: true)
            
            let headerBackView = UIView()
            headerBackView.backgroundColor = UIColor.clear
            headerBackView.frame = CGRect.init(x: 0, y: 74, width: ScreenWidth, height: 100)
            if let count = CurrentUserInfo?.data?.vip_expire_time,count > 0
            {
                if let vip = CurrentUserInfo?.data?.vip_level, vip > 0
                {
                   headerBackView.frame = CGRect.init(x: 0, y: 74, width: ScreenWidth, height: 130)
                }
            }
            let userHeader = UserInfoHeaderView.newUserHeader()!
            
            userHeader.frame = headerBackView.bounds
            selectLable.frame = CGRect.init(x: 20, y: headerBackView.frame.maxY + 30, width: 200, height: 20)
            headerBackView.addSubview(userHeader)
            topView.addSubview(headerBackView)
            topView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: selectLable.frame.maxY + 60)
        }
        topView.addSubview(selectLable)
        topView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: selectLable.frame.maxY + 60)
       
        
        
        //套餐板块
        for item in itemAry {
            backView.addSubview(item)
        }
        let VipLab = creatLable(frame: CGRect.init(x: 15, y: topView.frame.maxY + 70, width: 100, height: 20), title: "会员特权", font: kFont_SmallNormal, textColor: UIColor.gray)
        VipLab.backgroundColor = UIColor.clear
        backView.addSubview(VipLab)
        //会员特权板块
        let centerView = VipCenterView.init(frame: CGRect.init(x: 0, y: VipLab.frame.maxY, width: ScreenWidth, height: 200))
        centerView.backgroundColor = UIColor.white
        centerView.data = [["image":"看得更多","title":"看得更多","subtitle":"每天不限次查看女士"],["image":"看得更爽","title":"看得更爽","subtitle":"免费发布约会广播"],["image":"看得更久","title":"看得更久","subtitle":"查看阅后即焚的张片从2秒提升到6秒"],["image":"看得更省","title":"看得更省","subtitle":"每天十次免费机会查看付费相册或联系方式"]]
        backView.addSubview(centerView)
        
        let payLab = creatLable(frame: CGRect.init(x: 15, y: centerView.frame.maxY + 10, width: 200, height: 20), title: "支付方式", font: kFont_SmallNormal, textColor: UIColor.gray)
        payLab.backgroundColor = UIColor.clear
        backView.addSubview(payLab)
        
        selectedPayView.tagFrame = CGRect.init(x: 0, y: payLab.frame.maxY, width: ScreenWidth, height: 100)
        backView.addSubview(selectedPayView)
        
        
        autoPayBtn.frame = CGRect.init(x: (ScreenWidth - 160) / 2.0, y: selectedPayView.tagFrame!.maxY + 20, width: 160, height: 30)
        autoPayBtn .setImage(imageName(name: "选中-方"), for: UIControlState.selected)
        autoPayBtn.setImage(imageName(name: "未选中-方"), for: UIControlState.normal)
        autoPayBtn.setTitle("自动续费会员7折", for: UIControlState.normal)
        backView.addSubview(autoPayBtn)
        autoPayBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        autoPayBtn.addTarget(self, action: #selector(clickAutoPayBtn(sender:)), for: UIControlEvents.touchUpInside)
        if self.isHaveUserHeader {
            autoPayBtn.frame = CGRect.init(x: (ScreenWidth - 160) / 2.0, y: selectedPayView.tagFrame!.maxY + 20, width: 160, height: 0)
            autoPayBtn.setTitle("", for: UIControlState.normal)
        }
        let openBtn:UIButton = UIButton.init(frame: CGRect.init(x: 36, y: autoPayBtn.frame.maxY + 20, width: ScreenWidth - 72, height: BTNHEIGHT))
        openBtn.setTitle("立即开通", for: UIControlState.normal)
        backView.addSubview(openBtn)
        openBtn.backgroundColor = APPCustomBtnColor
        openBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        openBtn.layer.cornerRadius = BTNHEIGHT / 2.0
        
        openBtn.addTarget(self, action: #selector(clickOpenBtn(sender:)), for: UIControlEvents.touchUpInside)
        backView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: openBtn.frame.maxY + 20)
        scrollView.contentSize = CGSize.init(width: ScreenWidth, height: backView.frame.height)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font:kFont_system20]
    }
    @objc func clickOpenBtn(sender:UIButton)
    {
        var param:[String:Any] = ["user_id":CurrentUserInfo?.data?.user_id ?? "","package_id":currentModel?.package_id ?? ""]
        
        if selectedPayView.aliPayBtn.isSelected {
            param["channel"] = "alipay"
        }
        else
        {
            param["channel"] = "wx"
        }
        if autoPayBtn.isSelected {
            param["is_discount"] = true
        }
        else
        {
            param["is_discount"] = false
        }
        TargetManager.share.vipBuy(params: param) { (result, error) in
            
            if let dic = result as? [String:Any] {
                if let payDic = dic["data"] as? [String:Any]
                {
                    //发起支付
                    OtherApplication.share.pay(VC:self, charge: payDic, complection: { (result) in
                        
                        alertHud(title: "购买成功")
                        self.gotoMainVC()
                    })
                }
            }
        }
    }
    
    func gotoMainVC()
    {
        if isHaveUserHeader == false {
            var vcs = self.navigationController?.viewControllers
            
            vcs?.removeLast()
            vcs?.append(ManFillInformationViewController())
            self.navigationController?.setViewControllers(vcs!, animated: true)
        }
        else
        {
            updateUserInfo(complection: { (result) in
                if result {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
            
        }
        
//        self.navigationController?.pushViewController(ManFillInformationViewController(), animated: true)
//        updateUserInfo()
//
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        delegate.setRootViewController(vc: BaseTabBarViewController())
        
    }
    @objc func clickAutoPayBtn(sender:UIButton)
    {
      sender.isSelected = !sender.isSelected
    }
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == PackageViewClick {
            for item in self.itemAry
            {
                item.isSelected = false
            }
            guard let count = info as? Int else{
                return
            }
            self.currentModel = self.pageModels?[count]
            return
        }
        
        if let intercept = self.next as? ResponderRouter {
            intercept.interceptRoute(name: name, objc: nil, info: info)
            return
        }
        self.next?.zzy.router(name: name, object: objc, info: info)
        
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

