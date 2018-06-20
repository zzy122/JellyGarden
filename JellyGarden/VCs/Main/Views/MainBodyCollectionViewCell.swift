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
class MainBodyCollectionViewCell: UICollectionViewCell,UITableViewDataSource,UITableViewDelegate {
    var userInfoModels:[MainListmodel] = []
    private var currentType:SearchType?
    var currentPage:Int = 0
    
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()

    var userType:SearchType? {
        didSet{
            if currentType == userType {
                return
            }
            self.userInfoModels.removeAll()
            self.currentType = userType
            self.currentPage = 0
            self.refreshFooter()
        }
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
//    override init(frame: CGRect) {//不起作用
//        super.init(frame: frame)
//        tableView.register(UINib.init(nibName: "MainUserListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MainUserListTableViewCell")
//    }
    override func draw(_ rect: CGRect) {
        DebugLog(message: "draw")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.register(UINib.init(nibName: "MainUserListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MainUserListTableViewCellidentifier")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // 底部刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(refreshFooter))
        self.tableView.mj_footer = footer
        
        
        DebugLog(message: "layoutSubviews")
    }
    
    @objc func refreshFooter()
    {
        DebugLog(message: "刷新")
        
        request(page: self.currentPage, type: self.currentType ?? .hot, page_size: 10, complection: { (mianModelList, error) in
            self.tableView.mj_footer.endRefreshing()
            guard let countModels = mianModelList else
            {
                return
            }
            if countModels.count == 0{
                self.tableView.mj_footer.state = MJRefreshState.noMoreData
                return
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

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
