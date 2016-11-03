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
     
     - returns: height of menu-view's body-view
     */
    @objc optional func heightForBodyView(_ menuView: YXMenuView) -> CGFloat
    
    /**
    Tells the delegate that the specified row is now selected.
    
    - parameter menuView:  The menu-view object asking for the title.
    - parameter indexPath: indexPath of current selected row
    */
    @objc optional func menuView(_ menuView: YXMenuView, didSelectRowAtIndexPath indexPath: IndexPath)
    
    /**
     Tells the delegate that the type of menu-view's section-view
     
     - parameter menuView: The menu-view object asking for the title.
     - parameter section:  An index number identifying a section in menuView.
     
     - returns: type of menu-view's section-view
     */
    @objc optional func menuView(_ menuView: YXMenuView, bodyViewTypeInSection section: Int) -> YXBodyViewType
}

//MARK: - YXMenuView DataSource
@objc public protocol YXMenuViewDataSource {
    /**
     Asks the data source to return the number of sections in the menu view.
     The number of sections in menuView. The default value is 3.
     
     - parameter menuView: The menu-view object asking for the title.
     
     - returns: number of sections
     */
    func numberOfSectionsInYXMenuView(_ menuView: YXMenuView) -> Int
    
    /**
     Tells the data source to return the number of rows in a given section of a menu view.
     
     - parameter menuView: The menu-view object asking for the title.
     - parameter section:      An index number identifying a section in menuView.
     
     - returns: The number of rows in section.
     */
    func menuView(_ menuView: YXMenuView, numberOfRowsInSection section: Int) -> Int
    
    /**
     set header title of section
     
     - parameter menuView: The menu-view object asking for the title.
     - parameter section:      An index number identifying a section in menuView.
     
     - returns: title of section
     */
    func menuView(_ menuView: YXMenuView,  titleForHeaderInSection section: Int) -> String
    
    /**
     Set row title of section
     
     - parameter menuView: The menu-view object asking for the title.
     - parameter indexPath:    current indexPath
     
     - returns: title of row
     */
//    func menuView(menuView: YXMenuView,  titleForRowAtIndexPath indexPath: NSIndexPath) -> String
    
    /**
    Asks the delegate for custom image-view
    
    - parameter menuView: The menu-view object asking for the title.
    
    - returns: custom image-view
    */
    @objc optional func imageForSectionView(_ menuView: YXMenuView) -> UIImage?
    
    
    // ----- NEW ----
    
//    func menuView(_ menuView: YXMenuView,  typeForBodyViewInSection section: Int) -> YXBodyViewType
//    func menuView(_ menuView: YXMenuView,  dataForBodyViewIndexPath indexPath: IndexPath) -> AnyObject

}
