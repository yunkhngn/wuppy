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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(job.title)
                    .font(.headline)
                Spacer()
                StatusBadge(status: job.status)
            }
            
            HStack {
                Text(job.clientName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if let deadline = job.deadline {
                    Text(deadline, style: .date)
                    .font(.caption)
                    .foregroundStyle(deadline < Date() ? .red : .secondary)
                }
            }
            
            HStack {
                Text(job.remainingAmount, format: .currency(code: job.currency))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
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
