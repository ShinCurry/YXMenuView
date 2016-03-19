//
//  YXSectionView.swift
//  YXMenuView
//
//  Created by ShinCurry on 16/3/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

public enum YXSectionViewImageType {
    case Triangle, Arrow
    case Custom
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
                button.setTitleColor(tintColor, forState: .Normal)
                imageView.tintColor = tintColor
                horizonSeparator.backgroundColor = tintColor
                UIView.animateWithDuration(0.4, animations: {
                    self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                })
            } else {
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                imageView.tintColor = UIColor.lightGrayColor()
                horizonSeparator.backgroundColor = UIColor.lightGrayColor()
                UIView.animateWithDuration(0.44, animations: {
                    self.imageView.transform = CGAffineTransformMakeRotation(0)
                })
            }
        }
    }
}

// MARK: - View
extension YXSectionView {
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(identifier: "com.windisco.YXMenuView")
        let nib = UINib(nibName: "YXSectionView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func initSubView() {
        view = loadViewFromNib()
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.frame = bounds
        addSubview(view)
    }
}
