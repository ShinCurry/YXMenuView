//
//  YXMenuViewProtocol.swift
//  YXMenuView
//
//  Created by ShinCurry on 16/3/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

//MARK: - YXMenuView Delegate
 @objc public protocol YXMenuViewDelegate {
    /**
     Asks the delegate for the height of menu-view
     
     - parameter menuView: The menu-view object asking for the title.
     
     - returns: height value of menu-view
     */
    optional func heightForTableView(menuView: YXMenuView) -> CGFloat
    optional func numberOfVisibleCellsInYXMenuView(menuView: YXMenuView) -> Int
}

//MARK: - YXMenuView DataSource
@objc public protocol YXMenuViewDataSource {
    /**
     Asks the data source to return the number of sections in the menu view.
     The number of sections in menuView. The default value is 3.
     
     - parameter menuView: The menu-view object asking for the title.
     
     - returns: number of sections
     */
    
    func numberOfSectionsInYXMenuView(menuView: YXMenuView) -> Int
    
    /**
     Tells the data source to return the number of rows in a given section of a menu view.
     
     - parameter menuView: The menu-view object asking for the title.
     - parameter section:      An index number identifying a section in menuView.
     
     - returns: The number of rows in section.
     */
    func menuView(menuView: YXMenuView, numberOfRowsInSection section: Int) -> Int
    
    /**
     set header title of section
     
     - parameter menuView: The menu-view object asking for the title.
     - parameter section:      An index number identifying a section in menuView.
     
     - returns: title of section
     */
    func menuView(menuView: YXMenuView,  titleForHeaderInSection section: Int) -> String
    
    /**
     Set row title of section
     
     - parameter menuView: The menu-view object asking for the title.
     - parameter indexPath:    current indexPath
     
     - returns: title of row
     */
    func menuView(menuView: YXMenuView,  titleForRowAtIndexPath indexPath: NSIndexPath) -> String
    
    /**
     set custom view for header in section
     
     - parameter menuView: The menu-view object asking for the title.
     - parameter section:      An index number identifying a section in menuView.
     
     - returns: custom view
     */
    optional func menuView(menuView: YXMenuView, viewForHeaderInSection section: Int) -> UIView?
}