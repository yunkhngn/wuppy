//
//  CategoryManagerView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI
import SwiftData

struct CategoryManagerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \JobCategory.name) private var categories: [JobCategory]
    
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    @State private var editingCategory: JobCategory?
    
    var body: some View {
        List {
            ForEach(categories) { category in
                HStack {
                    Text(category.name)
                        .font(.headline)
                    Spacer()
                    Button {
                        editingCategory = category
                        newCategoryName = category.name
                        showingAddCategory = true
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
                .contextMenu {
                    Button("delete", role: .destructive) {
                        modelContext.delete(category)
                    }
                }
            }
            .onDelete(perform: deleteCategories)
        }
        .navigationTitle("manage_categories")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    editingCategory = nil
                    newCategoryName = ""
                    showingAddCategory = true
                }) {
                    Label("add_category", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            VStack(spacing: 20) {
                Text(editingCategory == nil ? "new_category" : "edit_category")
                    .font(.headline)
                
                TextField("category_name", text: $newCategoryName)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 300)
                
                HStack {
                    Button("cancel") {
                        showingAddCategory = false
                    }
                    
                    Button("save") {
                        saveCategory()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newCategoryName.isEmpty)
                }
            }
            .padding()
            .frame(width: 400, height: 200)
        }
    }
    
    private func saveCategory() {
        if let category = editingCategory {
            category.name = newCategoryName
        } else {
            let newCategory = JobCategory(name: newCategoryName)
            modelContext.insert(newCategory)
        }
        showingAddCategory = false
    }
    
    private func deleteCategories(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(categories[index])
            }
        }
    }
}
