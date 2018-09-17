//
//  DepositDetailViewController.swift
//  JellyGarden
//
//  Created by kfzs on 2018/7/30.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import protocol TZImagePickerController.TZImagePickerControllerDelegate

class DepositDetailViewController: BaseMainTableViewController {
    lazy var alertAction:AlipayAction = {
        let action = AlipayAction.init(showType: .center, view: self.alertBackView, windowView: self.navigationController?.view)
        return action
    }()
    var model: DepositListModel?
    var alertContentStr:String?
    var alertView:DisAgreeRefundView?
    lazy var alertBackView:UIView = {
        let view1 = UIView.init(frame: CGRect.init(x: 15, y: 29, width: ScreenWidth - 30, height: 250 * SCALE))
        view1.backgroundColor = UIColor.white
        view1.clipsToBounds = true
        view1.layer.cornerRadius = 5.0
        self.alertView = DisAgreeRefundView.createDisAgreeRefundView()
        self.alertView?.clickBtnBlock = { (isClick,photos,contentStr) in
            self.alertAction.hiddenTheView()
            if isClick
            {
                self.uploadImage(sender: photos)
            }
        }
       
        self.alertView?.frame = view1.bounds
        view1.addSubview(self.alertView!)
        return view1
    }()
    var bottomBtn:UIButton = {
        let btn = UIButton.init()
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(clickBottomBtn(sender:)), for: UIControlEvents.touchUpInside)
        btn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
        btn.setTitle("联系对方", for: UIControlState.normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订金管理详情"
        tableView.register(UINib.init(nibName: "DepositManagerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DepositManagerTableViewCell")
        tableView.register(UINib.init(nibName: "NormalDepositManagerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NormalDepositManagerTableViewCell")
        tableView.register(UINib.init(nibName: "WomanDepositManagerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WomanDepositManagerTableViewCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func clickBottomBtn(sender:UIButton)
    {
        DebugLog(message: "点击了联系对方")
    }
    func showDissAgreeeView()
    {
        alertAction.showView = self.alertBackView
        alertAction.showType = .center
        alertAction.backView.isUserInteractionEnabled = false
        alertAction.showTheView()
    }


}
extension DepositDetailViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell:DepositManagerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DepositManagerTableViewCell", for: indexPath) as! DepositManagerTableViewCell
        if model?.status == DepositStatus().pay_NoSure//要求缩回
        {
            let cell:DepositManagerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DepositManagerTableViewCell", for: indexPath) as! DepositManagerTableViewCell
            cell.model = model
            cell.sureAppiontBtn.setTitle("要求索回", for: UIControlState.normal)
            return cell
        }
        else if model?.status == DepositStatus().askFor && CurrentUserInfo?.sex == 1
        {
             let cell:WomanDepositManagerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WomanDepositManagerTableViewCell", for: indexPath) as! WomanDepositManagerTableViewCell
            cell.model = model
            return cell
        }
        else
        {
            let cell:NormalDepositManagerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NormalDepositManagerTableViewCell", for: indexPath) as! NormalDepositManagerTableViewCell
            cell.model = model
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 80))
        view1.backgroundColor = UIColor.clear
        bottomBtn.frame = CGRect.init(x: 10, y: (view1.bounds.height - 40) / 2.0, width: ScreenWidth - 20, height: 40)
        view1.addSubview(bottomBtn)
        return view1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if model?.status == DepositStatus().pay_NoSure  || (model?.status == DepositStatus().askFor && CurrentUserInfo?.sex == 1)        {
            return 185
        }
        return 140
    }
    
}
extension DepositDetailViewController:ResponderRouter,TZImagePickerControllerDelegate
{
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if name == DepositManagerBottomBtn
        {
            DebugLog(message: "点击了要求索回按钮")
            TargetManager.share.requestSureDeposit(param: ["order_sn":model?.order_num ?? "" , "is_refund":1]) { (success) in
                if success
                {
                    self.model?.status = DepositStatus().askFor
                    self.tableView.reloadData()
                }
            }
            
        }
        if name == ClickDepositDissAgreeBtn//点击了不同意
        {
            self.showDissAgreeeView()
            
            
        }
        if name == ClickDepositAgreeBtn//点击了同意
        {
            TargetManager.share.requestSureDeposit(param: ["order_sn":model?.order_num ?? "" , "is_refund":2]) { (success) in
                if success
                {
                    self.model?.status = DepositStatus().hasAskFor
                    self.tableView.reloadData()
                }
            }
        }
        
        if name == ClickFirstPhoto
        {
           
        }
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
                TargetManager.share.requestSureDeposit(param: ["imgurl":urls?.last ?? "","desc":self.alertContentStr ?? "","order_sn":self.model?.order_num ?? "" , "is_refund":3]) { (success) in
                    if success
                    {
                        self.model?.status = DepositStatus().hasAskFor
                        self.tableView.reloadData()
                    }
                }                
            }
            else
            {
                DebugLog(message: "上传失败")
            }
        })
    }
}
