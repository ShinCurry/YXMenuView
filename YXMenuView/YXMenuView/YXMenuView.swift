//
//  YXMenuView.swift
//  YXMenuView
//
//  Created by ShinCurry on 16/3/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

let defaultTag = 3000

@IBDesignable
public class YXMenuView: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initBaseView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBaseView()
    }

    override public func didMoveToSuperview() {
        if let view = superview {
            shadowView = UIView(frame: view.frame)
            shadowView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "unselectSection:"))
            view.addSubview(shadowView!)
            view.bringSubviewToFront(self)
            shadowView!.hidden = true
        }
    }
    
    
    var selections: YXMenuViewSelection!
    
    
    
    //MARK: - Default Data
    var titleForSections = ["Fruit", "小说", "動漫"]
    var titleForRowsInSection = [
    ["Apple", "Banana", "Blueberry", "Cherry", "Grape", "Lemon", "Mango", "Peach", "Pear"],
    ["来自新世界", "白夜行", "失乐园", "三体", "大秦帝国", "龙族", "古典部系列"],
    ["冰菓", "银魂", "とらドラ!", "やはり俺の青春ラブコメはまちがっている。", "言の叶の庭", "新世界より"]]
    
    
    //MARK: - Properties
    @IBInspectable override public var tintColor: UIColor! {
        didSet {
            let sectionViews = headerView.subviews as! [YXSectionView]
            sectionViews.forEach() { sectionView in
                sectionView.tintColor = tintColor
            }
        }
    }

    public var delegate: YXMenuViewDelegate? {
        didSet {
            performDelegate()
        }
    }
    public var dataSource: YXMenuViewDataSource? {
        didSet {
            performDataSource()
        }
    }
    
    var expansionHeight: CGFloat!
    var collapseHeight: CGFloat!
    var maxTableViewHeight: CGFloat!
    
    
    var headerView: UIView!
    var bodyView: UITableView!
    var shadowView: UIView?
    
    

    public var imageType: YXSectionViewImageType? {
        didSet {
            if let type = imageType {
                let subviews = headerView.subviews as! [YXSectionView]
                let image: UIImage?
                switch type {
                case .Triangle:
                    image = UIImage(named: "Triangle", inBundle: NSBundle(identifier: "com.windisco.YXMenuView"), compatibleWithTraitCollection: nil)
                case .Arrow:
                    image = UIImage(named: "Arrow", inBundle: NSBundle(identifier: "com.windisco.YXMenuView"), compatibleWithTraitCollection: nil)
                case .Custom:
                    return
                }
                subviews.forEach({ sectionView in
                    sectionView.imageView.image = image
                })
            }
            
            
        }
    }
}

// MARK: - View
extension YXMenuView {
    func initBaseView() {
        maxTableViewHeight = 44 * 4
        collapseHeight = frame.size.height
        expansionHeight = collapseHeight + maxTableViewHeight
        
        headerView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        initHeaderView(titleForSections.count)
        
        bodyView = UITableView(frame: CGRectMake(0, frame.size.height, frame.size.width, 0))
        bodyView.alpha = 0.2
        
        addSubview(headerView)
        addSubview(bodyView)
        
        bodyView.delegate = self
        bodyView.dataSource = self
        
    }
    
    func initHeaderView(sectionNumber: Int) {
        headerView.subviews.forEach() { $0.removeFromSuperview() }
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

    func performDataSource() {
        let numberOfSections = dataSource!.numberOfSectionsInYXMenuView(self)
        initHeaderView(numberOfSections)
        reloadHeaderData()
        if let imageForSectionView = dataSource!.imageForSectionView {
            let subviews = headerView.subviews as! [YXSectionView]
            subviews.forEach({ sectionView in
                sectionView.imageView.image = imageForSectionView(self)
            })
        }
    }
    
    func performDelegate() {
        if let heightForBodyView = delegate!.heightForBodyView {
            maxTableViewHeight = heightForBodyView(self)
        }
        
    }
}

// MARK: - View Reaction and Animation
extension YXMenuView {
    func selectSection(sender: UIButton) {
        let sectionIndex = sender.tag - defaultTag
        let status = selections.selectionAt(sectionIndex)
        selectAction(status)
    }
    
    func unselectSection(sender: UITapGestureRecognizer) {
        selections.reset()
        selectAction(.SelectSelf)
    }
    
    func selectAction(status: YXMenuSelectionStatus) {
        let sectionViews = headerView.subviews as! [YXSectionView]
        EnumerateSequence(sectionViews).forEach() { (index, sectionView) in
            sectionView.highlighted = selections.currentStatus[index]
        }
        
        switch status {
        case .SelectOne:
            showShadowView()
            bodyView.reloadData()
            self.expandTableView({})
        case .SelectSelf:
            hideShadowView()
            self.collapseTableView({})
        case .SelectOther:
            collapseTableView() {
                self.bodyView.reloadData()
                self.expandTableView({})
            }
        default:
            break
        }
    }
    
    func collapseTableView(completion: () -> Void) {
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseInOut, animations: {
            self.bodyView.alpha = 0.2
            self.bodyView.frame.size.height = 0
            }, completion: { _ in
                self.frame.size.height = self.collapseHeight
                completion()
        })
    }
    func expandTableView(completion: () -> Void) {
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
            self.bodyView.alpha = 1
            self.bodyView.frame.size.height = self.maxTableViewHeight
            }, completion: { _ in
                self.frame.size.height = self.expansionHeight
                completion()
        })
        
    }
    func showShadowView() {
        shadowView?.hidden = false
        UIView.animateWithDuration(0.25) {
            self.shadowView?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.7, alpha: 0.7)
        }
    }
    func hideShadowView() {
        UIView.animateWithDuration(0.25, animations: {
            self.shadowView?.backgroundColor = UIColor.whiteColor()
            }) { _ in
            self.shadowView?.hidden = true
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
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.menuView?(self, didSelectRowAtIndexPath: indexPath)
        selections.reset()
        selectAction(.SelectSelf)
    }
}