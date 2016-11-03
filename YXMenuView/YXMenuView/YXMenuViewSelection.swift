//
//  ViewSelection.swift
//  YXMenuView
//
//  Created by ShinCurry on 16/3/15.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Foundation

enum YXMenuSelectionStatus {
    case selectSelf
    case selectOther
    case selectNone
    case selectOne
}

class YXMenuViewSelection {
    var numberOfSelection: Int!
    fileprivate let defaultStatus: [Bool]!
    var currentStatus: [Bool]!
    var currentIndex: Int!
    
    init(numberOfSelection count: Int) {
        numberOfSelection = count
        defaultStatus = [Bool]()
        for _ in 0..<numberOfSelection {
            defaultStatus.append(false)
        }
        currentStatus = defaultStatus
        currentIndex = 0
    }
    
    func selectionAt(_ index: Int) -> YXMenuSelectionStatus {
        guard index >= 0 && index < numberOfSelection else {
            return .selectNone
        }
        
        if currentStatus[index] {
            currentStatus[index] = false
            return .selectSelf
        }
        
        if currentStatus == defaultStatus {
            currentStatus[index] = true
            currentIndex = index
            return .selectOne
        }
        
        currentStatus = defaultStatus
        currentIndex = index
        currentStatus[index] = true
        return .selectOther
    }
    
    func reset() {
        self.currentStatus = defaultStatus
    }
    
}
