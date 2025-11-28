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
        HStack {
            VStack(alignment: .leading) {
                Text(debt.personName)
                    .font(.headline)
                Text(debt.role.rawValue)
                    .font(.caption)
                    .foregroundStyle(debt.role == .iOwe ? .red : .green)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(debt.remainingAmount, format: .currency(code: "VND"))
                    .font(.body)
                    .fontWeight(.semibold)
                
                if let dueDate = debt.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundStyle(dueDate < Date() ? .red : .secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
