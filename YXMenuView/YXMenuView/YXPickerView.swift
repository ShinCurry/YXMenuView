//
//  YXPickerView.swift
//  YXMenuView
//
//  Created by ShinCurry on 16/4/5.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

public typealias YXPickerViewData = [(String, [String])]?

class YXPickerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubView()
    }
    
    var view: UIView!
    
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    
    
//    var selectedRowInLeftTableView: Int {
//        get {
//            if let selectedIndex = leftTableView.indexPathForSelectedRow {
//                return selectedIndex.row
//            } else {
//                return 0
//            }
//        }
//    }
//    var selectedRowInRightTableView: Int {
//        get {
//            if let selectedIndex = rightTableView.indexPathForSelectedRow {
//                return selectedIndex.row
//            } else {
//                return 0
//            }
//        }
//    }
    
    var indexPathForSelectedRow: NSIndexPath {
        get {
            var selectedSection = 0
            var selectedRow = 0
            if let selectedIndex = leftTableView.indexPathForSelectedRow {
                selectedSection = selectedIndex.row
            }
            if let selectedIndex = rightTableView.indexPathForSelectedRow {
                selectedRow = selectedIndex.row
            }
            return NSIndexPath(forRow: selectedRow, inSection: selectedSection)
        }
    }
    
    var data: YXPickerViewData
    
    func reloadData() {
        leftTableView.reloadData()
        rightTableView.reloadData()
    }
}

// MARK: - View
extension YXPickerView {
    func initSubView() {
        view = loadViewFromNib(named: "YXPickerView")
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.frame = bounds
        addSubview(view)
    }
}


extension YXPickerView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let d = data else {
            return 0
        }
        
        switch tableView {
        case leftTableView:
            return d.count
        case rightTableView:
            return d[indexPathForSelectedRow.section].1.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "PickerViewCell")
        guard let d = data else {
            return cell
        }
        
        switch tableView {
        case leftTableView:
            cell.textLabel!.text = d[indexPath.row].0
        case rightTableView:
            cell.textLabel!.text = d[indexPathForSelectedRow.section].1[indexPath.row]
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let d = data else {
            return
        }
        
        switch tableView {
        case leftTableView:
            rightTableView.reloadData()
//        case rightTableView:
            
        default:
            break
        }
    }
}