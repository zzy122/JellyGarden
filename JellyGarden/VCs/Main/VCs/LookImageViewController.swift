//
//  LookImageViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/8.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
enum LookImageType
{
    case effect;//模糊
    case clearness;//清晰
    case lookAfter;//看了后
}
class LookImageViewController: BaseViewController,ResponderRouter {

    var type = LookImageType.clearness{
        didSet {
            switch type {
            case .effect:
                
                break
            case .clearness:
                break
            case .lookAfter:
                break

            }
            self.imageView.starLookEffect(type: type)
        }
    }
    
    lazy var buttomView:ReckonTimeView = {
        
        let view1 = ReckonTimeView.init(frame:CGRect.init(x: 0, y: self.imageView.frame.maxY, width: ScreenWidth, height: ScreenHeight - self.imageView.frame.maxY), time: 4.0, runComplection: { (complete) in//查看完成
            self.runtimeComplection()
        })
        self.view.addSubview(view1)
        return view1
    }()
    lazy var imageView:LookImageBodyView = {
        let view1 = LookImageBodyView.createLookImageView()
        view1?.tagFrame = CGRect.init(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 140)
        self.view.addSubview(view1!)
        return view1!
        
    }()
    func runtimeComplection()
    {
        self.type = LookImageType.lookAfter
        self.buttomView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createView()
        // Do any additional setup after loading the view.
    }
    func createView() {
        self.type = LookImageType.effect
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.isHidden = false
        self.view.backgroundColor = UIColor.black
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func interceptRoute(name: String, objc: UIResponder?, info: Any?) {
        if finishLookComplete == name {
            self.buttomView.isHidden = false
            self.buttomView.starAnimatin()
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

}
