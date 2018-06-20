//
//  SearchUserViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class SearchUserViewController: BaseMainTableViewController,UISearchBarDelegate {
    lazy var searchBar:UISearchBar =
        {
            let barBackView = UIView()
            barBackView.backgroundColor = APPCustomGrayColor
            barBackView.layer.cornerRadius = 20
            barBackView.clipsToBounds = true
            barBackView.frame = CGRect.init(x: 60, y: 10, width: ScreenWidth - 120, height: 40)
            let bar = UISearchBar.init(frame: barBackView.bounds)
            
            //默认提示文字
            bar.placeholder = "搜索内容";
            bar.backgroundColor = UIColor.clear
            //背景图片
//            bar.backgroundImage = imageName(name: "");
            //代理
            bar.delegate = self;
            //显示右侧取消按钮
            bar.showsCancelButton = false;
            //光标颜色
            //        bar.tintColor = UIColorFromRGB(0x595959);
            //拿到searchBar的输入框
            let searchTextField = bar.value(forKey: "_searchField") as? UITextField;
            //字体大小
            searchTextField?.font = kFont_Normal;
            //输入框背景颜色
            searchTextField?.backgroundColor = APPCustomGrayColor;
            
            //设置按钮上文字的颜色
            searchTextField?.layer.cornerRadius = 14.0;
            searchTextField?.layer.borderColor = UIColor.clear.cgColor;
            searchTextField?.layer.borderWidth = 1;
            searchTextField?.layer.masksToBounds = true;
            barBackView.addSubview(bar)
            self.navigationItem.titleView = barBackView
            return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "MainUserListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MainUserListTableViewCell")
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainUserListTableViewCell", for: indexPath) as? MainUserListTableViewCell
        cell?.lookLab.isHidden = true
        cell?.siteLab.text = "sjhfajdffdjasf"
        cell?.realityLab.layer.cornerRadius = 8.0
        cell?.realityLab.clipsToBounds = true
        cell?.userHeaderImage.layer.cornerRadius = 35
        cell?.userHeaderImage.clipsToBounds = true
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //请求数据
        
        searchBar.endEditing(true)
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
