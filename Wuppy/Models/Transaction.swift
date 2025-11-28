//
//  Transaction.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import Foundation
import SwiftData

enum TransactionType: String, Codable, CaseIterable {
    case income = "Income"
    case expense = "Expense"
}

@Model
final class Transaction {
    var type: TransactionType
    var category: String
    var tags: [String]
    var amount: Double
    var date: Date
    var currency: String
    var note: String
    
    @Relationship(inverse: \Job.transactions) var job: Job?
    @Relationship(inverse: \Goal.transactions) var goal: Goal?
    
    init(type: TransactionType, category: String, tags: [String] = [], amount: Double, date: Date = Date(), currency: String = "VND", note: String = "") {
        self.type = type
        self.category = category
        self.tags = tags
        self.amount = amount
        self.date = date
        self.currency = currency
        self.note = note
    }
}
