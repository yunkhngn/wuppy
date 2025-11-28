//
//  Job.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import Foundation
import SwiftData

enum JobStatus: String, Codable, CaseIterable {
    case draft = "Draft"
    case negotiating = "Negotiating"
    case inProgress = "In Progress"
    case review = "Review"
    case waitingPayment = "Waiting Payment"
    case paid = "Paid"
    case canceled = "Canceled"
    case failed = "Failed"
    case scammed = "Scammed"
}

enum JobType: String, Codable, CaseIterable {
    case development = "Development"
    case design = "Design"
    case videoEditing = "Video Editing"
    case music = "Music"
    case other = "Other"
}

enum BillingType: String, Codable, CaseIterable {
    case fixedPrice = "Fixed Price"
    case hourly = "Hourly"
}

@Model
final class Job {
    var title: String
    var clientName: String
    var jobDescription: String
    var jobType: JobType
    var billingType: BillingType
    var rate: Double? // For hourly
    var fixedPrice: Double? // For fixed
    var depositAmount: Double
    var totalReceivedAmount: Double
    var createdDate: Date
    var startDate: Date?
    var deadline: Date?
    var paymentDueDate: Date?
    var status: JobStatus
    var currency: String
    var notes: String
    var tags: [String]
    
    @Relationship(deleteRule: .cascade) var timeSessions: [TimeSession]?
    @Relationship(deleteRule: .nullify) var transactions: [Transaction]?
    
    init(title: String, clientName: String, jobDescription: String = "", jobType: JobType = .other, billingType: BillingType = .fixedPrice, rate: Double? = nil, fixedPrice: Double? = nil, currency: String = "VND", depositAmount: Double = 0, totalReceivedAmount: Double = 0, createdDate: Date = Date(), startDate: Date? = nil, deadline: Date? = nil, paymentDueDate: Date? = nil, status: JobStatus = .draft, notes: String = "", tags: [String] = []) {
        self.title = title
        self.clientName = clientName
        self.jobDescription = jobDescription
        self.jobType = jobType
        self.billingType = billingType
        self.rate = rate
        self.fixedPrice = fixedPrice
        self.currency = currency
        self.depositAmount = depositAmount
        self.totalReceivedAmount = totalReceivedAmount
        self.createdDate = createdDate
        self.startDate = startDate
        self.deadline = deadline
        self.paymentDueDate = paymentDueDate
        self.status = status
        self.notes = notes
        self.tags = tags
    }
    
    var remainingAmount: Double {
        if billingType == .fixedPrice {
            return (fixedPrice ?? 0) - totalReceivedAmount
        } else {
            // For hourly, this would be calculated based on time sessions * rate - received
            // Simplified for now
            let totalEarned = (rate ?? 0) * (totalHours)
            return totalEarned - totalReceivedAmount
        }
    }
    
    var totalHours: Double {
        guard let sessions = timeSessions else { return 0 }
        return sessions.reduce(0) { $0 + $1.durationHours }
    }
}

@Model
final class TimeSession {
    var startTime: Date
    var endTime: Date?
    var note: String
    
    @Relationship(inverse: \Job.timeSessions) var job: Job?
    
    init(startTime: Date = Date(), endTime: Date? = nil, note: String = "") {
        self.startTime = startTime
        self.endTime = endTime
        self.note = note
    }
    
    var durationHours: Double {
        guard let end = endTime else { return 0 }
        return end.timeIntervalSince(startTime) / 3600.0
    }
}
