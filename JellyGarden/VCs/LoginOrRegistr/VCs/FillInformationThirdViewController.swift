//
//  FillInformationThirdViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/6.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class FillInformationThirdViewController: BaseViewController,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var dataAry:[String] = []
    var fillInfo:[String:Any] = [:]
    
    var currentData:[String] = [] {
        didSet{
            self.textView.text = continueString(strAry: currentData,separetStr:"  ")
        }
    }
    
    let textView = UITextView()
    let borderEdg:CGFloat = 10
    lazy var scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        scroll.bounces = false
        scroll.backgroundColor = UIColor.clear
        self.view.addSubview(scroll)
        return scroll
    }()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let scroll = UICollectionView.init(frame: self.collectionBackView.bounds, collectionViewLayout: layout)
        scroll.backgroundColor = UIColor.clear
        scroll.register(UINib.init(nibName: "BottomPickerCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BottomPickerCell")
        scroll.delegate = self
        
        scroll.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10 )
        scroll.dataSource = self
        scroll.isScrollEnabled = false
        return scroll
    }()
    lazy var collectionBackView: UIView = {
        let view1 = UIView()
        view1.backgroundColor = UIColor.clear
        view1.frame = CGRect.init(x: 0, y: self.textView.frame.maxY + 20, width: ScreenWidth, height: 300)
//        view1.addSubview(self.collectionView)
        return view1
    }()
    lazy var stepView:StepView = {
        let view = StepView.createStepView(step: 1)
        view?.tagFram = CGRect.init(x: 50, y: 10, width: ScreenWidth - 100, height: 20)
        return view!
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.addSubview(self.stepView)
        let lable = creatLable(frame: CGRect.init(x: borderEdg, y: stepView.tagFram!.maxY + 40, width: 150, height: 20), title: "个人介绍(选填)", font: kFont_SmallNormal, textColor: UIColor.gray)
        lable.backgroundColor = UIColor.clear
        self.title = "完善资料"
        scrollView.addSubview(lable)
        textView.frame = CGRect.init(x: borderEdg, y: lable.frame.maxY + 8, width: ScreenWidth - 2 * borderEdg, height: 100)
        textView.delegate = self
        textView.backgroundColor = UIColor.white
        textView.layer.cornerRadius = 8.0
        textView.font = kFont_system14
        textView.textColor = UIColor.black
        scrollView.addSubview(textView)
        self.dataAry = FillCondition.share.conditionTag
        self.collectionBackView.addSubview(self.collectionView)
        scrollView.addSubview(self.collectionBackView)
        
        
        let warmStr = XIeyiWarmView.createXIeyiWarmView()
        warmStr?.tagFrame = CGRect.init(x: 0, y: self.collectionBackView.frame.maxY + 20, width: ScreenWidth, height: 40)
        scrollView.addSubview(warmStr!)
        let nextBtn = createCustomBtn(frame: CGRect.init(x: 30, y: (warmStr?.tagFrame?.maxY)! + 20, width: ScreenWidth - 60, height: BTNHEIGHT), sel: #selector(clickBtn), target: self, title: "进入果冻花园")
        scrollView.addSubview(nextBtn)
        scrollView.contentSize = CGSize.init(width: ScreenWidth, height: nextBtn.frame.maxY + 10)
        
        // Do any additional setup after loading the view.
    }
    @objc func clickBtn()
    {
        
        fillInfo["tags"] = ""
        if textView.text.count > 0 {
            fillInfo["tags"] = currentData
            fillInfo["self_introduction"] = textView.text
            
        }
        fillInfoRequest(jsonDic: fillInfo) { (result) in
            if result {
                updateUserInfo()
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.setRootViewController(vc: BaseTabBarViewController())
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataAry.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:BottomPickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomPickerCell", for: indexPath) as! BottomPickerCell
        cell.contentLab.text = dataAry[indexPath.row]
        cell.contentLab.textColor = UIColor.gray
        cell.layer.cornerRadius = 5.0
        cell.clipsToBounds = true
        cell.contentLab.backgroundColor = APPCustomGrayColor
        cell.contentLab.font = kFont_system14
        for str in currentData {
            if str == dataAry[indexPath.row]
            {
                cell.contentLab.textColor = UIColor.white
                cell.contentLab.backgroundColor = APPCustomBtnColor
            }
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BottomPickerCell
        let str = dataAry[indexPath.row]
        for i in 0 ..< currentData.count {
            let exiStr = currentData[i]
            if str == exiStr {
                
                cell.contentLab.textColor = UIColor.gray
                cell.contentLab.backgroundColor = APPCustomGrayColor
                currentData.remove(at: i)
                return
            }
        }
        cell.contentLab.textColor = UIColor.white
        cell.contentLab.backgroundColor = APPCustomBtnColor
        currentData.append(str)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let str = dataAry[indexPath.row]
        let width = str.zzy.caculateWidth(font: kFont_system14) + 8
        return CGSize.init(width: width, height: 30)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.currentData = textView.text.components(separatedBy: "  ")
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
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
