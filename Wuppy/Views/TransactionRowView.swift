//
//  TransactionRowView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        WuppyCard(padding: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.category)
                        .font(.headline)
                        .fontWeight(.bold)
                    if !transaction.note.isEmpty {
                        Text(transaction.note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(transaction.amount, format: .currency(code: transaction.currency))
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(transaction.type == .income ? .green : .red)
                    
                    Text(transaction.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}
