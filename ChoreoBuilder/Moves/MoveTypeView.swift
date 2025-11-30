//
//  MoveTypeView.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/09.
//

import SwiftUI

struct MoveTypeView: View {
    var moveType: MoveType
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var typeName: String
    @State private var isPresentingConfirm: Bool = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError: Bool = false
    @State private var characterLimit: Int = 25
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack {
                        TextField("Type name", text: $typeName)
                            .bubbleStyle()
                            .limitText($typeName, to: characterLimit)
                            .focused($isFocused)
                    }
                    .padding()
                    .toolbar {
                        ToolbarItem {
                            Button {
                                if validateTypeName() {
                                    moveType.name = typeName
                                    dismiss()
                                }
                            } label: {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    isPresentingConfirm = true
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                            }
                            .confirmationDialog("Deleting this move type will delete all related moves. Are you sure?", isPresented: $isPresentingConfirm) {
                                Button("Delete this move type permanently", role: .destructive) {
                                    deleteMoveType()
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Edit \(moveType.name)")
                .navigationBarTitleDisplayMode(.inline)
            }
            .ignoresSafeArea(.keyboard)
            .background(backgroundGradient)
            .alert(errorTitle, isPresented: $showingError) {
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    init(moveType: MoveType) {
        self.moveType = moveType
        _typeName = .init(initialValue: moveType.name)
    }
    
    private func validateTypeName() -> Bool {
        let trimmedName = typeName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            inputError(title: "Name Error", message: "Move type name cannot be empty.")
            return false
        }
        
        return true
    }
    
    private func inputError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    private func deleteMoveType() {
        moveType.moves.forEach { modelContext.delete($0) }
        modelContext.delete(moveType)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    let sample = MoveType.example
    MoveTypeView(moveType: sample)
}
