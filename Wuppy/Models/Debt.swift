//
//  Debt.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import Foundation
import SwiftData

enum DebtRole: String, Codable, CaseIterable {
    case iOwe = "I Owe"
    case theyOweMe = "They Owe Me"
}

@Model
final class Debt {
    var personName: String
    var role: DebtRole
    var principalAmount: Double
    var interestRate: Double?
    var createdDate: Date
    var dueDate: Date?
    var lastPaymentDate: Date?
    var remainingAmount: Double
    var currency: String
    var notes: String
    
    init(personName: String, role: DebtRole, principalAmount: Double, currency: String = "VND", interestRate: Double? = nil, createdDate: Date = Date(), dueDate: Date? = nil, lastPaymentDate: Date? = nil, remainingAmount: Double, notes: String = "") {
        self.personName = personName
        self.role = role
        self.principalAmount = principalAmount
        self.currency = currency
        self.interestRate = interestRate
        self.createdDate = createdDate
        self.dueDate = dueDate
        self.lastPaymentDate = lastPaymentDate
        self.remainingAmount = remainingAmount
        self.notes = notes
    }
}
