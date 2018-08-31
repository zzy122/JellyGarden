//
//  LookImageSettingViewController.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/11.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class LookImageSettingViewController: BaseMainViewController {

    @IBOutlet weak var imageStatusBtn: UIButton!
    var imageDataSource:[PhotoModel]
    {
        return CurrentUserInfo?.custom_photos ?? []
    }
    var tagIndex:Int = 0
    {
        didSet {

        }
    }
    private var curruntImage:PhotoModel?
    {
        return imageDataSource[tagIndex]
    }
    
    
    @IBOutlet weak var delectBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.bounces = false
        self.collectionView.isPagingEnabled = true
        self.delectBtn.layer.cornerRadius = 5.0
        self.delectBtn.clipsToBounds = true
        self.collectionView.register(UINib.init(nibName: "BodyImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BodyImageCollectionViewCell")
        self.resetStuts(tags: tagIndex)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.contentOffset = CGPoint.init(x: CGFloat(tagIndex) * collectionView.bounds.width, y: 0)
    }
    func resetStuts(tags:Int)
    {
        self.tagIndex = tags
        self.titleLable.text = "\(String.init(self.tagIndex + 1))/\(String.init(self.imageDataSource.count))"
        self.imageStatusBtn.isSelected = (curruntImage?.type == 1)
        
    }
    @IBAction func clickDeleteBtn(_ sender: UIButton) {//删除
        
        TargetManager.share.deletePhoto(imageUrl: curruntImage?.url ?? "") { (success) in
            if success {
                let model = CurrentUserInfo
                model?.custom_photos?.remove(at: self.tagIndex)
                if self.tagIndex > 0
                {
                    self.tagIndex = self.tagIndex - 1
                }
                NSDictionary.init(dictionary: (model?.toJSON())!).write(toFile: UserPlist, atomically: true)
                self.collectionView.reloadData()
                self.resetStuts(tags: self.tagIndex)
            }
        }
        
    }
   
    @IBOutlet weak var titleLable: UILabel!
    @IBAction func clickBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func clickImageStatusBtn(_ sender: UIButton) {
        
            let status = (sender.isSelected ? 0 : 1)
            let params:[String:Any] = ["user_id":CurrentUserInfo?.user_id ?? "","url_list":curruntImage?.url ?? "","type":status]
        TargetManager.share.updateUserPhotos(params: params) { (success) in
            if success {
                let model = self.curruntImage
                model?.type = status
                let user = CurrentUserInfo
                user?.custom_photos?.remove(at: self.tagIndex)
                user?.custom_photos?.insert(model!, at: self.tagIndex)
                NSDictionary.init(dictionary: (user?.toJSON())!).write(toFile: UserPlist, atomically: true)
                sender.isSelected = !sender.isSelected
            
            }
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
extension LookImageSettingViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:BodyImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BodyImageCollectionViewCell", for: indexPath) as! BodyImageCollectionViewCell
        let model = imageDataSource[indexPath.row]
        cell.type = LookImageType.clearness
        cell.imageV.sd_DownLoadImage(url: model.url ?? "")
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let ox = scrollView.contentOffset.x
        let integ:Int = Int(ox / scrollView.bounds.width)
       self.resetStuts(tags: integ)
    }
    
    
    
}
