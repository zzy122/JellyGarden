//
//  BottomAlert.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class BottomAlert: UIView,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    typealias clickBtnHidden = ([String]?) -> Void
    var maxCount:Int = 1//最多可以有选中 默认为1
    var clickBtnBack:clickBtnHidden
    
    var currentDataAry:[PikerModel]?//下一级数据
    var backDataAry:[[PikerModel]] = []//上一级数据
    var _dataAry:[PikerModel]?
    var collectionDataAry:[String] = []
    var dataAry:[PikerModel]?  {
        set{
            _dataAry = newValue
            self.backDataAry.removeAll()
            self.currentDataAry = dataAry
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        get {
            return _dataAry
        }
    }
    
    
    lazy var tableView:UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.frame = self.tableContentView.bounds
        self.tableContentView.addSubview(table)
        return table
        
    }()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 20
        
        let scroll = UICollectionView.init(frame: self.bottomView.bounds, collectionViewLayout: layout)
        scroll.backgroundColor = UIColor.white
        scroll.register(UINib.init(nibName: "VipBodyViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "VipBodyViewCell")
        scroll.delegate = self
        scroll.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10 )
        scroll.dataSource = self
        self.bottomView.addSubview(scroll)
        scroll.isScrollEnabled = false
        return scroll
    }()
    
    lazy var tableContentView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame = CGRect.init(x: 0, y: self.topView.frame.maxY, width: self.frame.width, height: self.frame.height - self.topView.frame.height - self.bottomView.frame.height)
        self.addSubview(view)
        return view
    }()
    lazy var bottomView:UIView = {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: self.frame.height - 50, width: self.frame.width, height: 50)
        view.backgroundColor = UIColor.white
        
        self.addSubview(view)
        return view
    }()
    let leftBtn = UIButton()
    var titleLable:UILabel?
    lazy var topView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: 40)
        leftBtn.setTitle("取消", for: UIControlState.normal)
        leftBtn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
        leftBtn.titleLabel?.font = kFont_system13
        leftBtn.addTarget(self, action: #selector(clickLeftBtn), for: UIControlEvents.touchUpInside)
        leftBtn.backgroundColor = UIColor.clear
        leftBtn.frame = CGRect.init(x: 10, y: 5, width: 70, height: 30)
        
        let rightBtn = UIButton()
        rightBtn.setTitle("确认", for: UIControlState.normal)
        rightBtn.setTitleColor(APPCustomBtnColor, for: UIControlState.normal)
        rightBtn.titleLabel?.font = kFont_system13
        rightBtn.addTarget(self, action: #selector(clickRightBtn), for: UIControlEvents.touchUpInside)
        rightBtn.backgroundColor = UIColor.clear
        rightBtn.frame = CGRect.init(x: view.frame.width - 80, y: 5, width: 70, height: 30)
        
        titleLable = creatLable(frame: CGRect.init(x: leftBtn.frame.maxX, y: 5, width: view.frame.width - (leftBtn.frame.width + 10) * 2.0 , height: 30), title: nil, font: kFont_system16, textColor: UIColor.black)
        titleLable?.textAlignment = .center
        
        view.addSubview(leftBtn)
        view.addSubview(rightBtn)
        view.addSubview(titleLable!)
        self.addSubview(view)
        return view
    }()
    @objc func clickLeftBtn()
    {
        if backDataAry.count > 0 {
            self.currentDataAry = backDataAry.last
            backDataAry.removeLast()
            self.tableView.reloadData()
            if backDataAry.count == 0 {
                leftBtn.setTitle("取消", for: UIControlState.normal)
            }
            return
        }

       clickBtnBack(nil)
    }
    @objc func clickRightBtn()
    {
        clickBtnBack(self.collectionDataAry)
    }
    
    init(frame: CGRect,dataAry:[PikerModel]?,currentData:[String]?,backData:@escaping ([String]?) -> Void) {
        self.clickBtnBack = backData
        super.init(frame: frame)
        self.tableView.register(UINib.init(nibName: "PickerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PickerTableViewCell")
        self.collectionView.register(UINib.init(nibName: "BottomPickerCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BottomPickerCell")

        self.collectionDataAry = currentData ?? []
        self.dataAry = dataAry
        
        self.tableView.isHidden = false
        self.collectionView.isHidden = false
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataAry?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PickerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
        let str = currentDataAry?[indexPath.row].title
        cell.contentLab.text = str
        cell.contentLab?.textColor = UIColor.lightGray
        for exiStr in collectionDataAry {
            if str == exiStr{
                cell.contentLab?.textColor = APPCustomBtnColor
            }
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as? PickerTableViewCell
        let model:PikerModel = self.currentDataAry![indexPath.row]
        if let nextDataAry = model.subdData {
            backDataAry.append(currentDataAry!)
            leftBtn.setTitle("返回", for: UIControlState.normal)
            currentDataAry = nextDataAry
            tableView.reloadData()
            return
        }
        let str:String = self.currentDataAry![indexPath.row].title ?? ""
        
        for i in 0 ..< collectionDataAry.count  {
            let exiStr:String = collectionDataAry[i]
            if str == exiStr {//存在
                cell?.contentLab.textColor = UIColor.lightGray
                collectionDataAry.remove(at: i)
                collectionView.reloadData()
                return
            }
        }
        if maxCount == 1 {
            clickBtnBack([str])
            return
        }
        if collectionDataAry.count >= maxCount {
            clickBtnBack(collectionDataAry)
            return
        }
        collectionDataAry.append(str)
        self.collectionView.reloadData()
        cell?.contentLab.textColor = APPCustomBtnColor
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension BottomAlert
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataAry.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomPickerCell", for: indexPath) as? BottomPickerCell
        cell?.layer.cornerRadius = 5.0
        cell?.clipsToBounds = true
        cell?.layer.borderColor = APPCustomBtnColor.cgColor
        cell?.layer.borderWidth = 1.0
        cell?.contentLab.text = collectionDataAry[indexPath.row]
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionDataAry.remove(at: indexPath.row)
        collectionView.reloadData()
        tableView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let str = collectionDataAry[indexPath.row]
        let width = str.zzy.caculateWidth(font: kFont_SmallNormal) + 8
        return CGSize.init(width: width, height: 20)
    }

}
