//
//  FiltrateCondition.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/19.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
enum sexType {
    case woman;
    case man;
}
enum sortType {
    case near;
    case latest;
}
enum conditionType {
    case all;
    case free;
    case pay;
}
class FiltrateCondition: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var isselect:Bool = false
    private var backda:backParagram?
    
    typealias backParagram = ([String:Any]?) -> Void
    var textColor = k_CustomColor(red: 84, green: 132, blue: 202)
    
    var titleAry:[[String]] = [["男","女"],["离我最近","最新发布"],["全部","付费约会","免费约会"]]
    var sex:sexType? {
        didSet{
            switch sex {
            case .man?:
                self.param["sex"] = 0
                break
            case .woman?:
                self.param["sex"] = 1
                break
            default:
                self.param.removeValue(forKey: "sex")
                break
            }
        }
    }
    var sort:sortType?
    {
        didSet{
            switch sort {
            case .near?:
                self.param["sort"] = "near"
                break
            case .latest?:
                self.param["sort"] = "latest"
                break
            default:
                self.param.removeValue(forKey: "sort")
                break
            }
        }
    }
    var condition:conditionType?
    {
        didSet{
            switch condition {
            case .all?:
                self.param.removeValue(forKey: "condition")
                break
            case .free?:
                self.param["condition"] = "free"
                break
            case .pay?:
                self.param["condition"] = "pay"
                break
            default:
                self.param.removeValue(forKey: "condition")
                break
            }
        }
    }
    
    
    var param:[String:Any] = ["sort":"near"]
    
    lazy var collectonView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let margin:CGFloat = 15.0
        layout.itemSize = CGSize.init(width: 70, height: 30)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical//
        
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        let view = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 40), collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.register(UINib.init(nibName: "ConditionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ConditionCollectionViewCell")
        view.delegate = self;
        view.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        //        view.isScrollEnabled = false
        
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionElementKindSectionHeader")
        
        view.bounces = false
        view.dataSource = self
        
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: view.frame.maxY, width: self.frame.width, height: 40))
        btn.backgroundColor = UIColor.clear
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(textColor, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(clickSure), for: UIControlEvents.touchUpInside)
        self.addSubview(btn)
        
        self.addSubview(view)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.collectonView.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func clickSure(){
       self.backda?(self.param)
    }
    func backParam(backParam:@escaping backParagram) {
        self.backda = backParam
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension FiltrateCondition
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.titleAry.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let ary = self.titleAry[section]
        return ary.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectonView.dequeueReusableCell(withReuseIdentifier: "ConditionCollectionViewCell", for: indexPath) as! ConditionCollectionViewCell
        let ary = self.titleAry[indexPath.section]
         cell.conditionLable.textColor = textColor
        switch indexPath.section {
        case 0:
            if (indexPath.row == 0 && sex == .man) || (indexPath.row == 1 && sex == .woman) {
                cell.conditionLable.textColor = APPCustomRedColor
            }
            break
        case 1:
            if (indexPath.row == 0 && sort == .near) || (indexPath.row == 1 && sort == .latest)
            {
                cell.conditionLable.textColor = APPCustomRedColor
            }
            break
        case 2:
            if (indexPath.row == 0 && condition == .all) || (indexPath.row == 1 && condition == .pay) || (indexPath.row == 2 && condition == .free)
            {
                cell.conditionLable.textColor = APPCustomRedColor
            }
            break
        default:
            break
        }
       
        cell.conditionLable.text = ary[indexPath.row]
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let resumView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionElementKindSectionHeader", for: indexPath)
        var height:CGFloat = 40
        
        if indexPath.section == 0 {
            height = 30
        }
        let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: height))
        let lable = creatLable(frame: CGRect.init(x: 10, y: height - 30, width: 200, height: 30), title: "", font: kFont_SmallNormal, textColor: UIColor.gray)
        backView.addSubview(lable)
        lable.backgroundColor = UIColor.clear
        backView.backgroundColor = UIColor.white
        
        if kind == UICollectionElementKindSectionHeader {
            switch indexPath.section {
            case 0:
                lable.text = "性别"
                break
            case 1:
                lable.text = "排序"
                break
            case 2:
                lable.text = "排序"
                break
            default:
                break
                
            }
            for view in resumView.subviews
            {
                view.removeFromSuperview()
            }
            resumView.addSubview(backView)
            
        }
        return resumView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var height:CGFloat = 40
        
        if section == 0 {
            height = 30
        }
        return CGSize.init(width: collectionView.bounds.width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 && sex == .man {
                sex = nil
            }
            else if indexPath.row == 1 && sex == .woman{
                sex = nil
            }
            else
            {
                sex = (indexPath.row == 0) ? .man : .woman
            }
            break;
        case 1:
            if indexPath.row == 0 && sort == .near {
                sort = nil
                
            }
            else if indexPath.row == 1 && sort == .latest {
                sort = nil
                
            }
            else
            {
                sort = (indexPath.row == 0) ? .near : .latest
            }
            
            break;
        case 2:
            
            switch indexPath.row {
            case 0:
                if condition == .all {
                    condition = nil
                    return
                }
                condition = .all
                break
            case 1:
                if condition == .pay {
                    condition = nil
                    return
                }
                condition = .pay
                break
            case 2:
                if condition == .free {
                    condition = nil
                    return
                }
                condition = .free
                break
            default:
                break
            }
            
            break;
        
        default:
            break
        }
        
        collectionView.reloadData()
    }
    
}

