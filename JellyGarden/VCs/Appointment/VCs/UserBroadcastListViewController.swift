//
//  UserBroadcastListViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/28.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import MJRefresh
import Photos
class UserBroadcastListViewController: BaseMainTableViewController,PhotoPickerControllerDelegate,ResponderRouter {
    var userid:String = ""
    
    var appiontOpration:AppiontDataManager = {
        let manager = AppiontDataManager.share
        manager.conmentPath = UserCommentListPath
        return manager
        
    }()
    
    
    // 底部刷新
    let headerFresh = MJRefreshNormalHeader()
    
    var appiontModels:[lonelySpeechDetaileModel]?
    {
        get{
            return appiontOpration.commentModels
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        appiontOpration.clearData()
        self.title = "她的广播"
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.register(UINib.init(nibName: "ConfessionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfessionTableViewCell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        headerFresh.setRefreshingTarget(self, refreshingAction: #selector(self.refresh))
        //防止刷新cell的时候跳动
        self.tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        self.tableView.mj_header = headerFresh
        self.getAppiontData() { (result) in
            if result
            {
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    @objc func refresh()
    {
        
            self.tableView.reloadData()
            self.headerFresh.endRefreshing()
    }
    func getAppiontData(complection:@escaping (Bool) -> Void) {
        TargetManager.share.requestUserAllBroadcast(userid: userid) { (models, error) in
            guard error != nil else{
                
                complection(true)
                return
            }
            complection(false)
        }

       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().enable = false
        RootViewController?.showTheTabbar()
    }
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true
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
        
        cell.setDatasource(model: appiontModels![indexPath.section])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = appiontModels![indexPath.section]
        
        let height = caculateCellHeight(model: model)
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
extension UserBroadcastListViewController
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
        if ClickEnlistBtn == name {//我要报名
            let vc = QPPhotoPickerViewController(type: PageType.AllAlbum)
            vc.imageSelectDelegate = self
            //最大照片数量
            vc.imageMaxSelectedNum = 1
            self.present(vc, animated: true, completion: nil)
        }
        if name == ClickLikeChangeBtn  {//点赞
            guard let index = info as? Int else{
                return
            }
            let model:lonelySpeechDetaileModel = appiontModels![index]
            let appointment_id = model.appointment_id
            if let like = model.is_like,like//取消赞
            {
                TargetManager.share.cancelLikeAppiont(appointment_id: appointment_id, complection: { (result, error) in
                    if result//请求数据刷新
                    {
                        self.appiontOpration.modifyLikes(index: index, type: .subtract)
                        self.reloadMyTableView(index: index)
                    }
                })
            }
            else//点赞
            {
                TargetManager.share.likeAppiont(appointment_id: appointment_id, complection: { (complection, error) in
                    if complection//请求数据刷新
                    {
                        self.appiontOpration.modifyLikes(index: index, type: .add)
                        self.reloadMyTableView(index: index)
                    }
                })
            }
        }
        if name == ClickCommentBtn {//评论
            AlertAction.share.showCommentView(clickType: { (type, str) in
                guard let text = str else{
                    return
                }
                if type == .publish{
                    guard let index = info as? Int else{
                        return
                    }
                    let model:lonelySpeechDetaileModel = self.appiontModels![index]
                    let date = getTimeStamp(date: Date())
                    let params = ["publisher_id":CurrentUserInfo?.data?.user_id ?? "","content":text]
                    TargetManager.share.issueComment(appointment_id:model.appointment_id ?? "" ,params: params, complection: { (reslt, error) in
                        if reslt {
                            self.appiontOpration.insertComment(content: text, create_at: date, index: index)
                            self.reloadMyTableView(index: index)
                        }
                    })
                    
                }
                
            })
        }
        
    }
    func reloadMyTableView(index:Int)
    {
        let indexPath = IndexPath.init(row: 0, section: index)
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
    }
    
}
extension UserBroadcastListViewController
{
    //添加照片的协议方法
    func onImageSelectFinished(images: [PHAsset]) {
        QPPhotoDataAndImage.getImagesAndDatas(photos: images) { (array) in
            self.uploadImage(sender: array)
        }
    }
    func uploadImage(sender:[QPPhotoImageModel]?)
    {
        guard let photos = sender ,photos.count > 0 else {
            return
        }
        var models:[AliyunUploadModel] = []
        for imageModel in photos
        {
            let model = AliyunUploadModel()
            model.image = imageModel.smallImage
            model.fileName = getImageName()
            models.append(model)
            
        }
        AliyunManager.share.uploadImagesToAliyun(imageModels: models, complection: { (urls, succecCount, failCount, state) in
            if state == UploadImageState.success
            {//报名
                
            }
            else
            {
                DebugLog(message: "上传失败")
            }
        })
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

