//
//  Goal.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import Foundation
import SwiftData

@Model
final class Goal {
    var name: String
    var targetAmount: Double
    var currentAmount: Double
    var createdDate: Date
    var targetDate: Date?
    var notes: String
    
    init(name: String, targetAmount: Double, currentAmount: Double = 0, createdDate: Date = Date(), targetDate: Date? = nil, notes: String = "") {
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.createdDate = createdDate
        self.targetDate = targetDate
        self.notes = notes
    }
    
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return currentAmount / targetAmount
    }
}
