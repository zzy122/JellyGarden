//
//  AppointViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class AppointViewController: BaseMainTableViewController,ResponderRouter {
    var commentViews:[ZZYDisplayView] = []
    lazy var conditionView:FiltrateCondition = {
        let view1 = FiltrateCondition.init(frame: CGRect.init(x: 0, y: -250, width: ScreenWidth, height: 250))
        
        self.view.addSubview(view1)
        view1.backParam(backParam: {[weak self] (param) in
            self?.params = param
        })
        return view1
    }()
    var params:[String:Any]? {
        didSet{
            self.closeConditionView()
            self.getAppiontData(param: params!) { (result) in
                if result
                {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    var appiontModels:[lonelySpeechDetaileModel]?
    
    
    
    lazy var addAppiont:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: ScreenWidth - 80, y: self.view.frame.height - 80, width: 50, height: 50))
        btn.setImage(imageName(name: "添加"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(clickAdd), for: UIControlEvents.touchUpInside)
        btn.backgroundColor = UIColor.clear
        self.view.addSubview(btn)
        return btn
    }()
    var cityName:String = LocalCityName{
        didSet{
            self.leftBtn.isHidden = false
            self.leftBtn.setTitle(cityName, for: UIControlState.normal)
            self.leftBtn.setTitleColor(UIColor.gray, for: UIControlState.normal)
            self.leftBtn.setImage(imageName(name: "选中"), for: UIControlState.normal)
            self.leftBtn.sizeToFit()
        }
    }
    override func clickLeftBtn() {
        AlertAction.share.showbottomPicker(title: self.cityName, maxCount: 1, dataAry: nil, currentData: [self.cityName]) { (result) in
            self.cityName = result.last ?? self.cityName
            
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addAppiont.frame = CGRect.init(x: ScreenWidth - 80, y: self.view.frame.height - 80, width: 50, height: 50)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "寂寞告白"
        self.cityName = LocalCityName
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.register(UINib.init(nibName: "ConfessionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfessionTableViewCell")
        self.params = ["sort":"near"]
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        // Do any additional setup after loading the view.
    }
    func getAppiontData(param:[String:Any] ,complection:@escaping (Bool) -> Void) {
        var params = param
        params["user_id"] = CurrentUserInfo?.data?.user_id ?? ""
        TargetManager.share.getLonelySpeechList(params: params) { (models, error) in
            guard error != nil else{
               self.appiontModels = models
                complection(true)
                return
            }
            complection(false)
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        RootViewController?.showTheTabbar()
        self.rightBtn.isHidden = false
        self.rightBtn.setImage(imageName(name: "筛选"), for: UIControlState.normal)
        self.addAppiont.isHidden = false
    }
    override func clickRightBtn() {
        guard self.conditionView.isselect else {
            self.showConditionView()
            self.conditionView.isselect = true
            return
        }
//        self.conditionView.isselect = false
//        self.closeConditionView()
    }
    func closeConditionView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.conditionView.frame = CGRect.init(x: 0, y: -250, width: ScreenWidth, height: 250)
        }) { (complect) in
            self.conditionView.isselect = false
        }
    }
    func showConditionView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.conditionView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 250)
        }) { (complect) in
            
        }
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.appiontModels?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ConfessionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ConfessionTableViewCell", for: indexPath) as! ConfessionTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.tag = indexPath.section
        
        cell.setDatasource(type: .mainList,model: appiontModels![indexPath.section])
        return cell
    }
    @objc func clickAdd(){
        AlertViewCoustom().showalertView(style: .actionSheet, title: "广播", message: nil, cancelBtnTitle: "取消", touchIndex: { (index) in
            if index == 1
            {
              RootNav().pushViewController(NormalAppointmentViewController(), animated: true)
            }
            else if index == 2
            {
                RootNav().pushViewController(EnlistAppiontViewController(), animated: true)
            }
            DebugLog(message: "\(index)")
            
        }, otherButtonTitles: "普通约会广播", "报名约会广播")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = appiontModels![indexPath.section]
        
        let height = caculateCellHeight(type: .mainList,model: model)
        DebugLog(message: "cell\(indexPath.section)的高度\(height)")
        return height

        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 20))
        view1.backgroundColor = UIColor.clear
        return view1
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
extension AppointViewController
{
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == ClickReportName {//点击产看报名
            guard let index = info as? Int else{
                return
            }
            let vc = EnlistDetailViewController()
            vc.detaileModel = appiontModels?[index]
            RootNav().pushViewController(vc, animated: true)
        }
        if name == ClickLikeBtn  {//点赞
            guard let index = info as? Int else{
                return
            }
            let indexPath = IndexPath.init(row: 0, section: index)
            let appointment_id = self.appiontModels![index].poster?.user_id
            TargetManager.share.likeAppiont(appointment_id: appointment_id, complection: { (complection, error) in
                if complection//请求数据刷新
                {
                   self.reloadMyTableView(index: indexPath)
                }
            })
        }
        if name == ClickCancelLikeBtn {//取消点赞
            guard let index = info as? Int else{
                return
            }
            let indexPath = IndexPath.init(row: 0, section: index)
            let appointment_id = self.appiontModels![index].poster?.user_id
            TargetManager.share.cancelLikeAppiont(appointment_id: appointment_id, complection: { (result, error) in
                if result//请求数据刷新
                {
                    self.reloadMyTableView(index: indexPath)
                }
            })
        }
        
    }
    func reloadMyTableView(index:IndexPath)
    {
        self.getAppiontData(param: self.params!, complection: { (result) in
            if result
            {
                self.tableView.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)
            }
        })
    }
    
}
