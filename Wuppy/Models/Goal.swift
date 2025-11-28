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
    var createdDate: Date
    var targetDate: Date?
    var currency: String
    var notes: String
    
    @Relationship(deleteRule: .cascade) var transactions: [Transaction]?
    
    init(name: String, targetAmount: Double, currency: String = "VND", createdDate: Date = Date(), targetDate: Date? = nil, notes: String = "") {
        self.name = name
        self.targetAmount = targetAmount
        self.currency = currency
        self.createdDate = createdDate
        self.targetDate = targetDate
        self.notes = notes
    }
    
    var currentAmount: Double {
        transactions?.reduce(0) { $0 + $1.amount } ?? 0
    }
    
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return currentAmount / targetAmount
    }
}
