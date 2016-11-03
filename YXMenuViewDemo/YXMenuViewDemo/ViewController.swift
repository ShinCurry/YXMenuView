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
        menuView.dataSource = self
        menuView.delegate = self
        menuView.imageType = .custom
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var menuView: YXMenuView!
    
    var sectionType: [YXBodyViewType] = [.basic, .basic, .advanced]
    var titleForSections = ["Location", "Time", "Company"]
    
//    var dataForBodyViewAtIndexPath = ()
    
    var titleForRows = [
        ["Chongqing", "San Francisco", "Beijing", "Los Angeles", "Hongkong"],
        ["Morning", "Afternoon", "Night"],
        ["Apple", "Google", "Microsoft", "Yahoo", "IBM", "Dell"]]
}

// MARK: - YXMenuView Delegate and DataSource
extension ViewController: YXMenuViewDelegate, YXMenuViewDataSource {
    func numberOfSectionsInYXMenuView(_ menuVIew: YXMenuView) -> Int {
        return titleForSections.count
    }
    
    func menuView(_ menuView: YXMenuView, numberOfRowsInSection section: Int) -> Int {
        return titleForRows[section].count
    }
    
    func menuView(_ menuView: YXMenuView, titleForHeaderInSection section: Int) -> String {
        return titleForSections[section]
    }
    
    func menuView(_ menuView: YXMenuView, titleForRowAtIndexPath indexPath: IndexPath) -> String {
        return titleForRows[indexPath.section][indexPath.row]
    }
    func menuView(_ menuView: YXMenuView, didSelectRowAtIndexPath indexPath: IndexPath) {
        // do something...
    }
    func imageForSectionView(_ menuView: YXMenuView) -> UIImage? {
        return UIImage(named: "Test")
    }
    
    func menuView(_ menuView: YXMenuView, typeForBodyViewInSection section: Int) -> YXBodyViewType {
        return sectionType[section]
    }
}
