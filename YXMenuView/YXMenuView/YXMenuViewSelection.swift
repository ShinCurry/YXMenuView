//
//  ViewSelection.swift
//  YXMenuView
//
//  Created by ShinCurry on 16/3/15.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Foundation

enum YXMenuSelectionStatus {
    case SelectSelf
    case SelectOther
    case SelectNone
    case SelectOne
}

class YXMenuViewSelection {
    var numberOfSelection: Int!
    private let defaultStatus: [Bool]!
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
    
    
    func selectionAt(index: Int) -> YXMenuSelectionStatus {
        guard index >= 0 && index < numberOfSelection else {
            return .SelectNone
        }
        
        if currentStatus[index] {
            currentStatus[index] = false
            return .SelectSelf
        }
        
        if currentStatus == defaultStatus {
            currentStatus[index] = true
            currentIndex = index
            return .SelectOne
        }
        
        currentStatus = defaultStatus
        currentIndex = index
        currentStatus[index] = true
        return .SelectOther
    }
    
    func reset() {
        self.currentStatus = defaultStatus
    }
    
}