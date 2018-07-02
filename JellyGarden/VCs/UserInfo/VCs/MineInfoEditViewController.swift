//
//  MineInfoEditViewController.swift
//  JellyGarden
//
//  Created by weipinzhiyuan on 2018/6/24.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class MineInfoEditViewController: BaseMainViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorColor = UIColor.groupTableViewBackground
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            
            let tags1 = TagsView(.text) //OK
            tags1.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 120)
            tags1.padding = 10
            tags1.titles = ["女汉子", "女神", "女神经", "苗条", "学霸", "购物狂", "绿茶", "贤惠", "酒神", "厨艺好", "文艺", "好身材", "欧美范儿", "纹身", "AJ控", "运动", "马甲线", "电影", "看书", "旅游", "吃货", "走肾不开心"]
            tags1.isEnableAdd = false
            tags1.tagDelegate = self

            tableView.tableFooterView = tags1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存",
                                                            style: UIBarButtonItemStyle.plain,
                                                            target: self,
                                                            action: #selector(touchSave))
        
        title = "编辑资料"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

@objc
extension MineInfoEditViewController {
    
    func touchSave() {
        
    }
}

extension MineInfoEditViewController: TagsViewDelegate {
    
    func tagsView(didTouchTagAtIndex index: Int) {
        
    }
}

extension MineInfoEditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 0 == indexPath.section && 0 == indexPath.row {
            return 60
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 == section ? 0.000001 : 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if 0 == section || 1 == section {
            return nil
        }
        
        let header: UIView = {
            let _header = UIView()
            _header.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 20)
            _header.backgroundColor = UIColor.clear
            
            let _label = UILabel()
            _label.textColor = hexString(hex: "999999")
            _label.font = UIFont.systemFont(ofSize: 12)
            _label.frame = CGRect(x: 15, y: 0, width: 0, height: 0)
            
            if 2 == section {
                _label.text = "联系方式（至少填写一种联系方式）"
            }
            else {
                _label.text = "个人介绍（选填）"
            }
            
            _header.addSubview(_label)
            return _header
        }()
        
        return header
    }
}

extension MineInfoEditViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 8
        case 1:
            return 5
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "UITableViewCell")
            cell?.textLabel?.textColor = hexString(hex: "333333")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.detailTextLabel?.textColor = hexString(hex: "999999")
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        }
        cell?.accessoryType = .none
        cell?.accessoryView = nil
        
        if 0 == indexPath.row {
            cell?.textLabel?.text = "头像"
            cell?.detailTextLabel?.text = ""
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            cell?.accessoryView = imageView
        }
        else if 1 == indexPath.row {
            cell?.textLabel?.text = "昵称"
            cell?.detailTextLabel?.text = "KK"
        }
        else if 2 == indexPath.row {
            cell?.textLabel?.text = "约会范围"
            cell?.detailTextLabel?.text = "北京市"
        }
        else if 3 == indexPath.row {
            cell?.textLabel?.text = "年龄"
            cell?.detailTextLabel?.text = "18岁"
        }
        else if 4 == indexPath.row {
            cell?.textLabel?.text = "身份"
            cell?.detailTextLabel?.text = "模特"
        }
        else if 5 == indexPath.row {
            cell?.textLabel?.text = "身高"
            cell?.detailTextLabel?.text = "173CM"
        }
        return cell!
    }
}
