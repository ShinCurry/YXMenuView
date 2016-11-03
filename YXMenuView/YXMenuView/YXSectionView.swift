//
//  YXSectionView.swift
//  YXMenuView
//
//  Created by ShinCurry on 16/3/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

public enum YXSectionViewImageType {
    case triangle, arrow
    case custom
}

class YXSectionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubView()
    }
    
    var view: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var horizonSeparator: UIView!
    
    var highlighted = false {
        didSet {
            if highlighted {
                button.setTitleColor(tintColor, for: UIControlState())
                imageView.tintColor = tintColor
                horizonSeparator.backgroundColor = tintColor
                UIView.animate(withDuration: 0.4, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                })
            } else {
                button.setTitleColor(UIColor.black, for: UIControlState())
                imageView.tintColor = UIColor.lightGray
                horizonSeparator.backgroundColor = UIColor.lightGray
                UIView.animate(withDuration: 0.44, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: 0)
                })
            }
        }
    }
}

// MARK: - View
extension YXSectionView {
    func initSubView() {
        view = loadViewFromNib(named: "YXSectionView")
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = bounds
        addSubview(view)
    }
}
