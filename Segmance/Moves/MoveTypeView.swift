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
    // Crash source: When deleting this could be a problem.
    @State private var originalType: String
    @State private var showToast: Bool = false
    
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
                                    moveType.abbreviation  = String(typeName.first!)
                                    dismiss()
                                }
                            } label: {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button("Delete Move Type", systemImage: "trash", role: .destructive) {
                                    isPresentingConfirm = true
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                            }
                           
                            
                            .confirmationDialog(
                                "Move Type Deletion",
                                isPresented: $isPresentingConfirm
                            ) {
                                Button("Delete", role: .destructive) {
                                    showToast = true
                                    deleteMoveType()
                                }
                                Button("Cancel", role: .cancel) {}
                            } message: {
                                Text("Deleting this move type will also delete all its associated moves. Are you sure?")
                                    
                            }
                        }
                    }
                }
                // Crash source: Don't access the variable
                .navigationTitle("Edit \(originalType)")
                .navigationBarTitleDisplayMode(.inline)
            }
            .ignoresSafeArea(.keyboard)
            .background(backgroundGradient)
            .alert(errorTitle, isPresented: $showingError) {
            } message: {
                Text(errorMessage)
            }
            .overlay(alignment: .top) {
                if showToast {
                    Text("Move type deleted!")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.green.opacity(0.8), in: RoundedRectangle(cornerRadius: 12))
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 20)
                }
            }
            .animation(.organicFastBounce, value: showToast)
        }
    }
    
    init(moveType: MoveType) {
        self.moveType = moveType
        _typeName = .init(initialValue: moveType.name)
        _originalType = .init(initialValue: moveType.name)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dismiss()
        }
    }
}

#Preview {
    let sample = MoveType.example
    MoveTypeView(moveType: sample)
}
