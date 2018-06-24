//
//  UserInfoViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class UserInfoViewController: BaseMainViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let tableHeaderView: UIView = {
                let _headerView = UIView()
                _headerView.backgroundColor = UIColor.clear
                _headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 310)
                
                headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 310)
                _headerView.addSubview(headerView)
                return _headerView
            }()
            
            let tableFooterView: UIView = {
                let _view = UIView()
                _view.backgroundColor = UIColor.clear
                _view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 140)
                
                let _serviceButton = UIButton(type: UIButtonType.custom)
                _serviceButton.setTitle("联系客服", for: UIControlState.normal)
                _serviceButton.setTitleColor(hexString(hex: "6388C5"), for: UIControlState.normal)
                _serviceButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                _serviceButton.backgroundColor = UIColor.white
                _serviceButton.frame = CGRect(x: 0, y: 20, width: ScreenWidth, height: 44)
                _serviceButton.addTarget(self, action: #selector(touchService), for: UIControlEvents.touchUpInside)
                
                let _logoutButton = UIButton(type: UIButtonType.custom)
                _logoutButton.setTitle("退出登录", for: UIControlState.normal)
                _logoutButton.setTitleColor(hexString(hex: "ed639a"), for: UIControlState.normal)
                _logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                _logoutButton.backgroundColor = UIColor.white
                _logoutButton.frame = CGRect(x: 0, y: 74, width: ScreenWidth, height: 44)
                _logoutButton.addTarget(self, action: #selector(touchLogout), for: UIControlEvents.touchUpInside)
                
                _view.addSubview(_serviceButton)
                _view.addSubview(_logoutButton)
                return _view
            }()
            
            tableView.register(UINib(nibName: "MineRedPhoneCell", bundle: nil), forCellReuseIdentifier: "MineRedPhoneCell")
            tableView.tableHeaderView = tableHeaderView
            tableView.tableFooterView = tableFooterView
            tableView.separatorColor = UIColor.groupTableViewBackground
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

            if #available(iOS 11.0, *) {
                tableView.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
                self.automaticallyAdjustsScrollViewInsets = false 
            }
        }
    }
    
    let headerView: MineInfoHeaderView = UINib(nibName: "MineInfoHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! MineInfoHeaderView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .top
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

@objc
extension UserInfoViewController {
    
    @IBAction func touchSetting() {
        
    }
    
    @IBAction func touchShare() {
        
    }
    
    func touchRecover() {
        
    }
    
    func touchService() {
        
    }
    
    func touchLogout() {
        
    }
}

extension UserInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 0 == indexPath.section {
            return 220
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.groupTableViewBackground
        return header
    }
}

extension UserInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 6
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 0 == indexPath.section {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineRedPhoneCell") as! MineRedPhoneCell
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "UITableViewCell")
                cell?.textLabel?.textColor = hexString(hex: "333333")
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell?.detailTextLabel?.textColor = hexString(hex: "999999")
                cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            }
            
            cell?.accessoryType = .disclosureIndicator
            if 1 == indexPath.section && 0 == indexPath.row {
                cell?.textLabel?.text = "绑定手机"
                cell?.detailTextLabel?.text = "13730639424"
            }
            else if 1 == indexPath.section && 1 == indexPath.row {
                cell?.textLabel?.text = "查看权限"
                cell?.detailTextLabel?.text = "公开"
            }
            else if 1 == indexPath.section && 2 == indexPath.row {
                cell?.textLabel?.text = "个人介绍"
                cell?.detailTextLabel?.text = "女神、电影"
            }
            else if 1 == indexPath.section && 3 == indexPath.row {
                cell?.textLabel?.text = "约会条件"
                cell?.detailTextLabel?.text = "跟钱没关系"
            }
            else if 1 == indexPath.section && 4 == indexPath.row {
                cell?.textLabel?.text = "分享果冻花园"
                cell?.detailTextLabel?.text = ""
            }
            else if 1 == indexPath.section && 5 == indexPath.row {
                cell?.textLabel?.text = "用户使用协议"
                cell?.detailTextLabel?.text = ""
            }
            else if 2 == indexPath.section && 0 == indexPath.row {
                cell?.textLabel?.text = "黑名单"
                cell?.detailTextLabel?.text = ""
            }
            else if 2 == indexPath.section && 1 == indexPath.row {
                cell?.textLabel?.text = "历史访客"
                cell?.detailTextLabel?.text = "有98个人看过你"
            }
            else if 2 == indexPath.section && 2 == indexPath.row {
                cell?.textLabel?.text = "阅后即焚"
                cell?.detailTextLabel?.text = "已有2个人焚毁了你的照片"
                cell?.accessoryView = {
                    let _button = UIButton(type: UIButtonType.custom)
                    _button.setTitle("一键恢复", for: UIControlState.normal)
                    _button.setTitleColor(hexString(hex: "6388C5"), for: UIControlState.normal)
                    _button.layer.cornerRadius = 10
                    _button.layer.borderColor = hexString(hex: "6388C5").cgColor
                    _button.layer.borderWidth = 1 / UIScreen.main.scale
                    _button.addTarget(self, action: #selector(touchRecover), for: UIControlEvents.touchUpInside)
                    _button.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
                    _button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                    return _button
                }()
            }
            
            return cell!
        }
    }
}
