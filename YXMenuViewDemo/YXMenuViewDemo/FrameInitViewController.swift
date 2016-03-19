//
//  FrameInitViewController.swift
//  YXMenuViewDemo
//
//  Created by ShinCurry on 16/3/17.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import YXMenuView

class FrameInitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let y = navigationController!.navigationBar.frame.origin.y + navigationController!.navigationBar.frame.size.height
        menuView = YXMenuView(frame: CGRectMake(0, y, view.frame.size.width, 44))
        view.addSubview(menuView)
        
        menuView.imageType = .Arrow
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var menuView: YXMenuView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
