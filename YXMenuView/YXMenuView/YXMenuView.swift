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
open class YXMenuView: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initBaseView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBaseView()
    }

    override open func didMoveToSuperview() {
        if let view = superview {
            shadowView = UIView(frame: view.frame)
            shadowView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YXMenuView.unselectSection)))
            view.addSubview(shadowView!)
            view.bringSubview(toFront: self)
            shadowView!.alpha = 0.2
            shadowView!.isHidden = true
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
    @IBInspectable override open var tintColor: UIColor! {
        didSet {
            let sectionViews = headerView.subviews as! [YXSectionView]
            sectionViews.forEach() { sectionView in
                sectionView.tintColor = tintColor
            }
        }
    }

    open var delegate: YXMenuViewDelegate? {
        didSet {
            performDelegate()
        }
    }
    open var dataSource: YXMenuViewDataSource? {
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
    
    var headerSelectionTitle: [String] = []

    open var imageType: YXSectionViewImageType? {
        didSet {
            if let type = imageType {
                let subviews = headerView.subviews as! [YXSectionView]
                let image: UIImage?
                switch type {
                case .triangle:
                    image = UIImage(named: "Triangle", in: Bundle(identifier: "com.windisco.YXMenuView"), compatibleWith: nil)
                case .arrow:
                    image = UIImage(named: "Arrow", in: Bundle(identifier: "com.windisco.YXMenuView"), compatibleWith: nil)
                case .custom:
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
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        initHeaderView(titleForSections.count)
        
        bodyView = UITableView(frame: CGRect(x: 0, y: frame.size.height, width: frame.size.width, height: 0))
        bodyView.alpha = 0.2
        
        addSubview(headerView)
        addSubview(bodyView)
        
        bodyView.delegate = self
        bodyView.dataSource = self
        
    }
    
    func initHeaderView(_ sectionNumber: Int) {
        headerView.subviews.forEach() { $0.removeFromSuperview() }
        selections = YXMenuViewSelection(numberOfSelection: sectionNumber)
        // +1 去除最后一个 sectionView 的分割线
        var fullWidth = frame.size.width + 1
        if let view = superview {
            fullWidth = view.frame.size.width + 1
        }

        
        let buttonWidth = fullWidth / CGFloat(sectionNumber)
        let buttonHeight = headerView.frame.size.height
        for index in 0..<sectionNumber {
            
            let sectionView = YXSectionView(frame: CGRect(x: CGFloat(index) * buttonWidth, y:  0, width: buttonWidth, height: buttonHeight))
            let button = sectionView.button
            button?.addTarget(self, action: #selector(YXMenuView.selectSection(_:)), for: .touchUpInside)
            button?.tag = defaultTag + index
            button?.setTitle(titleForSections[index], for: .normal)

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
    func selectSection(_ sender: UIButton) {
        let sectionIndex = sender.tag - defaultTag
        let status = selections.selectionAt(sectionIndex)
        selectAction(status)
    }
    
    func unselectSection(_ sender: UITapGestureRecognizer) {
        selections.reset()
        selectAction(.selectSelf)
    }
    
    func selectAction(_ status: YXMenuSelectionStatus) {
        let sectionViews = headerView.subviews as! [YXSectionView]
        sectionViews.enumerated().forEach() { (index, sectionView) in
            sectionView.highlighted = selections.currentStatus[index]
        }
        
        switch status {
        case .selectOne:
            showShadowView()
            bodyView.reloadData()
            self.expandTableView({})
        case .selectSelf:
            hideShadowView()
            self.collapseTableView({})
        case .selectOther:
            collapseTableView() {
                self.bodyView.reloadData()
                self.expandTableView({})
            }
        default:
            break
        }
    }
    
    func collapseTableView(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.bodyView.alpha = 0.2
            self.bodyView.frame.size.height = 0
            }, completion: { _ in
                self.frame.size.height = self.collapseHeight
                completion()
        })
    }
    func expandTableView(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.bodyView.alpha = 1
            self.bodyView.frame.size.height = self.maxTableViewHeight
            }, completion: { _ in
                self.frame.size.height = self.expansionHeight
                completion()
        })
        
    }
    func showShadowView() {
        shadowView?.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.shadowView?.alpha = 1
            self.shadowView?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.7, alpha: 0.7)
        }) 
    }
    func hideShadowView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.shadowView?.alpha = 0
            self.shadowView?.backgroundColor = UIColor.white
            }, completion: { _ in
            self.shadowView?.isHidden = true
        }) 
    }
}

// MARK: - Data
extension YXMenuView {
    fileprivate func reloadHeaderData() {
        if let data = dataSource {
            let sectionViews = headerView.subviews as! [YXSectionView]
            sectionViews.enumerated().forEach() { (index, sectionView) in
                sectionView.button.setTitle(data.menuView(self, titleForHeaderInSection: index), for: UIControlState())
            }
        }
    }
    
    public func reloadHeader() {
        reloadHeaderData()
    }
    public func reloadBody() {
        bodyView.reloadData()
    }
}

// MARK: - TableView Delegate and DataSource
extension YXMenuView: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let data = dataSource {
            return data.numberOfSectionsInYXMenuView(self)
        } else {
            return titleForSections.count
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == selections.currentIndex else {
            return 0
        }
        
        if let data = dataSource {
            return data.menuView(self, numberOfRowsInSection: selections.currentIndex)
        } else {
            return titleForRowsInSection[section].count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MenuCell")

        if let data = dataSource {
            cell.textLabel!.text = data.menuView(self, titleForHeaderInSection: indexPath.section)
        } else {
            cell.textLabel!.text = titleForRowsInSection[indexPath.section][indexPath.row]
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.menuView?(self, didSelectRowAtIndexPath: indexPath)
        selections.reset()

        selectAction(.selectSelf)
        let subviews = headerView.subviews as! [YXSectionView]
        subviews[indexPath.section].button.setTitle(bodyView.cellForRow(at: indexPath)!.textLabel!.text!, for: UIControlState())

    }
}
