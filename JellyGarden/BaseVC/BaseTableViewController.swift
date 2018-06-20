//
//  BaseTableViewController.swift
//  LeShanBankSwift
//
//  Created by zzy on 2018/4/12.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    let tableView:UITableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue)   | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)
            | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue))).rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) |
            UInt8(UIViewAutoresizing.flexibleHeight.rawValue)    |
            UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue)))//自动布局 防止父viewsize变了之后tableview的size超出父view
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        MM_WARNING//此处的意义
        if #available(iOS 11.0, *)
        {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        self.tableView.backgroundColor = customBackViewColor
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension BaseTableViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}
