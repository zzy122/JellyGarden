//
//  MainBodyView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let MainBodyViewScrollPage = "MainBodyViewScrollPage"

class MainBodyView: UIView,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    var typeAry: [SearchType] = [.hot, .new, .attestation]
    

    
    var tagLocalCity:String? {
        didSet{
            self.collectionView.reloadData()
        }
    }//设置当前的筛选地址
    
    var tagSex: sexType = .woman {
        didSet{

            typeAry = (tagSex == .woman) ? [.hot, .new, .attestation]: [.hot, .vip]
            
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .init(rawValue: 0), animated: false)
        }
    }//设置当前的性别
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
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
        self.collectionView.frame = self.bounds
        self.collectionView.isHidden = false//解决由控制器的frame变化带来的frame.height偏高的问题
    }
    func limitRefresh()
    {
        let cell:MainBodyCollectionViewCell = self.collectionView.visibleCells.first as! MainBodyCollectionViewCell
        cell.currentPage = 1
        cell.userInfoModels.removeAll()
        cell.refreshFooter()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.frame.width, height: self.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.zzy.router(name: MainBodyViewScrollPage, object: nil, info: self.getCurrentPage(scrollView: scrollView))
    }
    
    func getCurrentPage(scrollView: UIScrollView) -> Int {
        return Int(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5)
    }
    
    func scrollToindex(index: Int) {
        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .init(rawValue: 0), animated: true)
    }
}
