//
//  MainBodyView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let MainBodyViewScrollPage = "MainBodyViewScrollPage"

class MainBodyView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var typeAry:[SearchType] = []
    var tagLocalCity:String?{
        didSet{
            self.collectionView.reloadData()
        }
    }//设置当前的筛选地址
    
    var tagSex:sexType?
    {
        didSet{
            self.collectionView.reloadData()
        }
    }//设置当前的性别
    
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: self.frame.width, height: self.frame.height)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal//横向滑动
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        let view = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        view.register(UINib.init(nibName: "MainBodyCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MainBodyCollectionViewCell")
        view.delegate = self;
        view.isPagingEnabled = true
        
        view.bounces = false
        
        view.dataSource = self
        self.addSubview(view)
        return view
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.isHidden = false//解决由控制器的frame变化带来的frame.height偏高的问题
    }
    
    @objc func clickDeblockingBtn(){
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return typeAry.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBodyCollectionViewCell", for: indexPath) as? MainBodyCollectionViewCell
        cell?.tagLocalCity = self.tagLocalCity
        cell?.tagSex = self.tagSex
        cell?.userType = self.typeAry[indexPath.row]
        return cell!
        
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.zzy.router(name: MainBodyViewScrollPage, object: nil, info: self.getCurrentPage(scrollView: scrollView))
    }
    func getCurrentPage(scrollView:UIScrollView) -> Int {
        let x = scrollView.contentOffset.x
        
        var intege = Int(x / self.frame.width)
        let yushu:CGFloat = x.truncatingRemainder(dividingBy: self.frame.width)
        if yushu > self.frame.width / 2.0 {
            intege += 1
        }
        
        return intege
    }
    func scrollToindex(index:Int)
    {
        self.collectionView.setContentOffset(CGPoint.init(x: CGFloat(index) * self.frame.width, y: 00), animated: true)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
