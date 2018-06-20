//
//  VipCenterView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class VipCenterView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize.init(width: (ScreenWidth - 3 * 20.0) / 2.0, height: 90)
       let scroll = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        scroll.backgroundColor = UIColor.white
        scroll.register(UINib.init(nibName: "VipBodyViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "VipBodyViewCell")
        scroll.delegate = self
        scroll.contentInset = UIEdgeInsets.init(top: 10 * SCALE, left: 10 * SCALE, bottom: 10 * SCALE, right: 10 * SCALE)
        scroll.dataSource = self
        scroll.isScrollEnabled = false
        self.addSubview(scroll)
        return scroll
    }()
    var data:[[String:Any]]? {
        didSet{
           self.collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.collectionView.isHidden = false
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dic = self.data![indexPath.row]
        let cell:VipBodyViewCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "VipBodyViewCell", for: indexPath) as! VipBodyViewCell
        cell.titleLabl.text = dic["title"] as? String
        cell.IM.image = imageName(name: dic["image"] as! String)
        cell.subTitleLab.text = dic["subtitle"] as? String
        return cell
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
