//
//  GoalRowView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

struct GoalRowView: View {
    let goal: Goal
    
    var body: some View {
        WuppyCard(padding: 12) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(goal.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(goal.progress, format: .percent.precision(.fractionLength(0)))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                ProgressView(value: goal.currentAmount, total: goal.targetAmount)
                    .tint(.blue)
                
                HStack {
                    Text(goal.currentAmount, format: .currency(code: goal.currency))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(goal.targetAmount, format: .currency(code: goal.currency))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}
