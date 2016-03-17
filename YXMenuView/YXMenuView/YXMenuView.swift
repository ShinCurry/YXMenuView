//
//  YXMenuView.swift
//  Partime
//
//  Created by ShinCurry on 16/3/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

public class YXMenuView: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initBaseView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBaseView()
    }
    
    public override func awakeFromNib() {
        bodyView.delegate = self
        bodyView.dataSource = self
        
        self.translatesAutoresizingMaskIntoConstraints = false

    }
    
    var selections: YXMenuViewSelection!
    let defaultTag = 3000
    
    
    //MARK: - Default Data
    var titleForSections = ["Stark", "Sakura", "Hoppou"]
    var titleForRowsInSection = [
    ["Apple", "Banana", "Blueberry"],
    ["Cherry", "Grape", "Lemon"],
    ["Mango", "Peach", "Pear"]]
    
    
    //MARK: - Properties
    override public var tintColor: UIColor! {
        didSet {
            let sectionViews = headerView.subviews as! [YXSectionView]
            sectionViews.forEach() { sectionView in
                sectionView.tintColor = tintColor
            }
        }
    }
    
    @IBOutlet public var delegate: YXMenuViewDelegate? {
        didSet {
            
        }
    }
    @IBOutlet public var dataSource: YXMenuViewDataSource? {
        didSet {
            updateHeaderView()
        }
    }
    

    

    var expansionHeight: CGFloat!
    var collapseHeight: CGFloat!
    var maxTableViewHeight: CGFloat!
    
    @IBOutlet var superView: UIView?
    var headerView: UIView!
//    var sectionViews: [YXSectionView]!
    var bodyView: UITableView!

}

// MARK: - View
extension YXMenuView {
    func initBaseView() {
        maxTableViewHeight = 44 * 3
        collapseHeight = frame.size.height
        expansionHeight = collapseHeight + maxTableViewHeight

        
        headerView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        initHeaderView(titleForSections.count)
        
        bodyView = UITableView(frame: CGRectMake(0, frame.size.height, frame.size.width, 0))
        bodyView.alpha = 0.2
        
        addSubview(headerView)
        addSubview(bodyView)

        
    }
    
    
    func initHeaderView(sectionNumber: Int) {
        selections = YXMenuViewSelection(numberOfSelection: sectionNumber)
        // +1 去除最后一个 sectionView 的分割线
        let fullWidth = frame.size.width + 1
        let buttonWidth = fullWidth / CGFloat(sectionNumber)
        let buttonHeight = headerView.frame.size.height
        for index in 0..<sectionNumber {
            let sectionView = YXSectionView(frame: CGRectMake(CGFloat(index) * buttonWidth, 0, buttonWidth, buttonHeight))
            let button = sectionView.button
            button.addTarget(self, action: "selectSection:", forControlEvents: .TouchUpInside)
            button.tag = defaultTag + index
            button.setTitle(titleForSections[index], forState: .Normal)
            sectionView.tintColor = tintColor
            headerView.addSubview(sectionView)
        }
    }
    
    func updateHeaderView() {
        let numberOfSections = dataSource!.numberOfSectionsInYXMenuView(self)
        initHeaderView(numberOfSections)
        
        reloadHeaderData()
    }
    
    // load view from xib
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(identifier: "com.windisco.YXMenuView")!
        let nib = UINib(nibName: "YXMenuView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
}

// MARK: - View Reaction and Animation
extension YXMenuView {
    func selectSection(sender: UIButton) {
        let sectionIndex = sender.tag - defaultTag
        let status = selections.selectionAt(sectionIndex)
        
        let sectionViews = headerView.subviews as! [YXSectionView]
        EnumerateSequence(sectionViews).forEach() { (index, sectionView) in
            sectionView.highlighted = selections.currentStatus[index]
        }
        
        switch status {
        case .SelectOne:
            print("SelectOne")
            bodyView.reloadData()
            self.expandTableView() {
                
            }

        
        case .SelectSelf:
            print("SelectSelf")
            self.collapseTableView() {
                self.collapseBackground()
            }

            

            
        case .SelectOther:
            print("SelectOther")
            collapseTableView() {
                self.bodyView.reloadData()
                self.expandTableView({})
            }
        default:
            print("default")
            break
        }
    }
    
    func collapseTableView(completion: () -> Void) {
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseInOut, animations: {
            self.bodyView.alpha = 0.2
            self.bodyView.frame.size.height = 0
            }, completion: { _ in
                completion()
        })
    }
    func expandTableView(completion: () -> Void) {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
            self.bodyView.alpha = 1
            self.bodyView.frame.size.height = self.maxTableViewHeight

            }, completion: { _ in
                self.expandBackground()
                completion()
        })
        
    }
    
    func collapseBackground() {
        UIView.animateWithDuration(0.15) {
            self.frame.size.height = self.collapseHeight
        }

    }
    
    func expandBackground() {
        UIView.animateWithDuration(0.3) {
            if let view = self.superView {
                self.frame.size.height = view.frame.size.height
            } else {
                self.frame.size.height = self.expansionHeight
            }
        }
    }
    
}

// MARK: - Data
extension YXMenuView {
    private func reloadHeaderData() {
        if let data = dataSource {
            let sectionViews = headerView.subviews as! [YXSectionView]
            EnumerateSequence(sectionViews).forEach() { (index, sectionView) in
                sectionView.button.setTitle(data.menuView(self, titleForHeaderInSection: index), forState: .Normal)
            }
        }
    }
    
    func reloadData() {
        reloadHeaderData()
        bodyView.reloadData()
    }
}

// MARK: - TableView Delegate and DataSource
extension YXMenuView: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let data = dataSource {
            return data.numberOfSectionsInYXMenuView(self)
        } else {
            return titleForSections.count
        }
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == selections.currentIndex else {
            return 0
        }
        
        if let data = dataSource {
            return data.menuView(self, numberOfRowsInSection: selections.currentIndex)
        } else {
            return titleForRowsInSection[section].count
        }
    }
    
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "MenuCell")

        if let data = dataSource {
            cell.textLabel!.text = data.menuView(self, titleForRowAtIndexPath: indexPath)
        } else {
            cell.textLabel!.text = titleForRowsInSection[indexPath.section][indexPath.row]
        }
        return cell
    }
}