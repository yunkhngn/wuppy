//
//  DebtRowView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

struct DebtRowView: View {
    let debt: Debt
    
    var body: some View {
        WuppyCard(padding: 12, isInteractive: true) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(debt.personName)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 6) {
                        Text(debt.role.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background((debt.role == .iOwe ? Color.red : Color.green).opacity(0.1))
                            .foregroundStyle(debt.role == .iOwe ? .red : .green)
                            .clipShape(Capsule())
                        
                        if let dueDate = debt.dueDate {
                            Text(dueDate, style: .date)
                                .font(.caption)
                                .foregroundStyle(dueDate < Date() ? .red : .secondary)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(debt.remainingAmount, format: .currency(code: debt.currency))
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(debt.role == .iOwe ? .red : .green)
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}
