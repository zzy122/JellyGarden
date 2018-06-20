//
//  WomenPersonInfoViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/15.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ManPersonInfoViewController: BaseTableViewController {
    
    var broadcastAry:[Any] = []
    
    
    let images:[String] = []
    lazy var headerView:ManpersonInfoHeader = {
        var intege = getLines(ary: images, veryCount: 4)
        let view1 = ManpersonInfoHeader.createManpersonInfoHeader()
        view1?.tagFrame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 320 + CGFloat(intege) * (BodyImageHeight + 8))
        return view1!
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView.isHidden = false
        self.tableView.tableHeaderView = self.headerView
        self.tableView.register(UINib.init(nibName: "ConfessionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfessionTableViewCell")
        
        guard self.broadcastAry.count == 0 else {
            return
        }
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
        footer.backgroundColor = UIColor.white
        let lable = creatLable(frame: CGRect.init(x: 0, y: (footer.frame.height - 20) / 2.0, width: footer.frame.width, height: 20), title: "他还没有发布广播", font: kFont_system18, textColor: UIColor.gray)
        lable.textAlignment = NSTextAlignment.center
        lable.backgroundColor = UIColor.clear
        footer.addSubview(lable)
        self.tableView.tableFooterView = footer
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        self.tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
extension ManPersonInfoViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.broadcastAry.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfessionTableViewCell", for: indexPath) as! ConfessionTableViewCell
        cell.setDatasource(type: .mainList,model: lonelySpeechDetaileModel())
            return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return caculateCellHeight(type: .mainList,model: lonelySpeechDetaileModel())
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 50))
        section.backgroundColor = UIColor.clear
        let lable = creatLable(frame: CGRect.init(x: 10, y: 30, width: 100, height: 20), title: "他的广播", font: kFont_system14, textColor: UIColor.lightGray)
        lable.backgroundColor = UIColor.clear
        section.addSubview(lable)
        return section
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    
}
