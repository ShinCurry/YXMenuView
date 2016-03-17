//
//  ViewController.swift
//  YXMenuViewDemo
//
//  Created by ShinCurry on 16/3/16.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import YXMenuView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        menuView.delegate = self
//        menuView.dataSource = self
        menuView.tintColor = UIColor.redColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var menuView: YXMenuView!
    
    
    var titleForSections = ["区域", "时间", "类型"]
    var titleForRows = [
        ["重庆", "北京", "上海"],
        ["上午", "中午", "下午", "晚上"],
        ["派送", "调研", "家教", "导游", "打酱油"]]
}

extension ViewController: YXMenuViewDelegate, YXMenuViewDataSource {
    func numberOfSectionsInYXMenuView(menuVIew: YXMenuView) -> Int {
        return titleForSections.count
    }
    
    func menuView(menuView: YXMenuView, numberOfRowsInSection section: Int) -> Int {
        return titleForRows[section].count
    }
    
    func menuView(menuView: YXMenuView, titleForHeaderInSection section: Int) -> String {
        return titleForSections[section]
    }
    
    func menuView(menuView: YXMenuView, titleForRowAtIndexPath indexPath: NSIndexPath) -> String {
        return titleForRows[indexPath.section][indexPath.row]
    }
}