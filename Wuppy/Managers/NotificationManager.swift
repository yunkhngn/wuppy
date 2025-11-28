//
//  NotificationManager.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import UserNotifications
import Foundation

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
        }
    }
    
    func scheduleJobDeadlineNotification(job: Job) {
        guard let deadline = job.deadline else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Job Deadline Approaching"
        content.body = "Deadline for '\(job.title)' is tomorrow."
        content.sound = .default
        
        // Schedule 1 day before
        if let triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: deadline) {
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "job-deadline-\(ObjectIdentifier(job))", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func scheduleDebtDueDateNotification(debt: Debt) {
        guard let dueDate = debt.dueDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Debt Due Soon"
        content.body = "Debt '\(debt.personName)' is due tomorrow."
        content.sound = .default
        
        // Schedule 1 day before
        if let triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: dueDate) {
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "debt-due-\(ObjectIdentifier(debt))", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func removeNotification(for id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
