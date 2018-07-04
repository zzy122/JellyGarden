//
//  ADDPayCountViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/3.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class ADDPayCountViewController: BaseMainTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
extension ADDPayCountViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ADDPayCountViewController")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "ADDPayCountViewController")
            if indexPath.row == 0
            {}
            
        }
    }
    func createTextFiled() -> UITextField {
        let text = UITextField.init(frame: CGRect.init(x: ScreenWidth - 160, y: 10, width: 150, height: 30))
        text.borderStyle = .none
        text.font = kFont_Normal
        text.backgroundColor = UIColor.clear
    }
    
}

