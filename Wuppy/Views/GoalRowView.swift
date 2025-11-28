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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(goal.name)
                    .font(.headline)
                Spacer()
                Text(goal.progress, format: .percent.precision(.fractionLength(0)))
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            ProgressView(value: goal.currentAmount, total: goal.targetAmount)
            
            HStack {
                Text(goal.currentAmount, format: .currency(code: "VND"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(goal.targetAmount, format: .currency(code: "VND"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
