//
//  Extension.swift
//  YXMenuView
//
//  Created by ShinCurry on 16/4/5.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

extension UIView {
    func loadViewFromNib(named name: String) -> UIView {
        let bundle = NSBundle(identifier: "com.windisco.YXMenuView")
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
}
    