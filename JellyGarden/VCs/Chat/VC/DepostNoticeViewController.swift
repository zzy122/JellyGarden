//
//  DepostNoticeViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/9.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class DepostNoticeViewController: BaseMainTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价通知"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RootViewController?.hideTheTabbar()
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
