//
//  GFStarView.swift
//  GEFilmSchedule
//
//  Created by m y on 2017/12/3.
//  Copyright © 2017年 m y. All rights reserved.
//

import UIKit

class StarButton: UIButton
{
    var star: Int = 0
}

class GFStarView: UIView
{
    typealias backCount = (Int) -> Void
    var starButton: [StarButton] = []
    
    var isOnlyShow: Bool = false
    
    var selectedStarImage: UIImage = UIImage(named: "满星")!
    
    var normalStarImage: UIImage = UIImage(named: "星")!
    var clickBack:backCount?
    
    
    var totalStar: Int = 5
    {
        didSet
        {
            for button in starButton
            {
                button.removeFromSuperview()
            }
            
            starButton.removeAll()
            
            for index in 0 ..< totalStar
            {
                let sb = StarButton(type: .custom)
                sb.setImage(selectedStarImage, for: .selected)
                sb.setImage(normalStarImage, for: .normal)
                sb.addTarget(self, action: #selector(touchStarButton(sender:)), for: .touchUpInside)
                sb.star = index
                
                self.addSubview(sb)
                starButton.append(sb)
            }
        }
    }
    
    var star: Int = 0
    
    func reloadData()
    {
        for button in starButton
        {
            button.isSelected = button.star < star
        }
    }
    
    override func layoutSubviews()
    {
        let width = bounds.size.width / CGFloat(totalStar)
        let height = bounds.size.height
        for index in 0 ..< starButton.count
        {
            let button = starButton[index]
            button.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
        }
    }

    @objc func touchStarButton(sender: StarButton)
    {
        if isOnlyShow { return }
        star = sender.star + 1
        clickBack?(star)
        reloadData()
    }
}
