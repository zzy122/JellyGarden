//
//  MainBodyCollectionViewCell.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickMainUserCell = "ClickMainUserCell"

import MJRefresh
enum SearchType {
    case hot;//热门
    case new;//最新
    case attestation;//认证
}
class MainBodyCollectionViewCell: UICollectionViewCell,UITableViewDataSource,UITableViewDelegate,ResponderRouter {
    var userInfoModels:[MainListmodel] = []
    private var currentType:SearchType?
    var currentPage:Int = 1
    
    // 底部刷新
    
    let footer = MJRefreshAutoNormalFooter()
    private var currentSex:sexType?//保存当前的性别删选
    var tagSex:sexType?//设置当前的性别
    
    private var currentLocalCity:String?//保存当前的筛选地址
    var tagLocalCity:String?//设置当前的筛选地址
    

    var userType:SearchType? {
        didSet{
            if (currentType == userType) && (currentSex == tagSex) && (currentLocalCity == tagLocalCity) {//性别 类型 地址一致才不用刷新
                return
            }
            self.userInfoModels.removeAll()
            self.currentType = userType
            self.currentPage = 1
            self.refreshFooter()
            self.currentLocalCity = self.tagLocalCity
            self.currentSex = self.tagSex
            
        }
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!

    override func draw(_ rect: CGRect) {
        DebugLog(message: "draw")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.register(UINib.init(nibName: "MainUserListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MainUserListTableViewCellidentifier")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        // 底部刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(refreshFooter))
        self.tableView.mj_footer = footer
        
        
        DebugLog(message: "layoutSubviews")
    }
    
    @objc func refreshFooter()
    {
        DebugLog(message: "刷新")
        
        request(page: self.currentPage, type: self.currentType ?? .hot, page_size: 10,sex:tagSex!,locaCity:tagLocalCity!, complection: { (mianModelList, error) in
            self.tableView.mj_footer.endRefreshing()
            guard let countModels = mianModelList else
            {
                return
            }
            if countModels.count == 0{
                self.tableView.mj_footer.state = MJRefreshState.noMoreData
                alertHud(title: "没有更多数据了~")
            }
            self.currentPage += 1
            for i in 0 ..< countModels.count {
                self.userInfoModels.append(mianModelList![i])
            }
            self.tableView.reloadData()
        })
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = userInfoModels[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainUserListTableViewCellidentifier", for: indexPath) as? MainUserListTableViewCell
        cell?.realityLab.layer.cornerRadius = 8.0
        
        cell?.realityLab.clipsToBounds = true
        cell?.userHeaderImage.layer.cornerRadius = 35
        cell?.userHeaderImage.clipsToBounds = true
        cell?.model = model
        cell?.tag = indexPath.row
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = userInfoModels[indexPath.row]
        self.zzy.router(name: ClickMainUserCell, object: nil, info: model)
    }
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        
        
        if name == ClickLikeHeart
        {
            guard let indexTag = info as? Int else
            {
                return
            }
            
            let userInfo = userInfoModels[indexTag]
            let params = ["like_garden_user_id":userInfo.user_id ?? "", "user_id":CurrentUserInfo?.user_id ?? ""]
            TargetManager.share.gardensUserLikes(params: params, complection: { (success) in
                if success {
                    userInfo.is_like = (userInfo.is_like == true) ? false : true
                    self.userInfoModels.remove(at: indexTag)
                    self.userInfoModels.insert(userInfo, at: indexTag)
                    self.tableView.reloadData()
                }
            })
            
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
