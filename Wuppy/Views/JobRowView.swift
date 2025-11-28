//
//  JobRowView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

struct JobRowView: View {
    let job: Job
    
    var body: some View {
        WuppyCard(padding: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(job.title)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .font(.caption)
                            Text(job.clientName)
                                .font(.subheadline)
                        }
                        .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    StatusBadge(status: job.status)
                }
                
                Divider()
                    .opacity(0.5)
                
                HStack {
                    // Currency/Amount
                    HStack(spacing: 4) {
                        Image(systemName: "banknote")
                        Text(job.remainingAmount, format: .currency(code: job.currency))
                            .fontWeight(.medium)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    // Deadline
                    if let deadline = job.deadline {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                            Text(deadline, style: .date)
                        }
                        .font(.caption)
                        .foregroundStyle(deadline < Date() ? .red : .secondary)
                    }
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}

struct StatusBadge: View {
    let status: JobStatus
    
    var color: Color {
        switch status {
        case .draft: return .gray
        case .negotiating: return .orange
        case .inProgress: return .blue
        case .review: return .purple
        case .waitingPayment: return .yellow
        case .paid: return .green
        case .canceled: return .secondary
        case .failed, .scammed: return .red
        }
    }
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.2))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
