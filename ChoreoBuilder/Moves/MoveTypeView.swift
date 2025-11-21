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
    
    var body: some View {
        ZStack {
            
            NavigationStack {
                
                Text("Edit Type Name")
                TextField("Type name", text: $typeName)
                    .bubbleStyle()
                    .padding()
                
                
                
                    .toolbar {
                        
                        Button("Save") {
                            moveType.name = typeName
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        
                    }
                
                    .toolbar {
                        
                        
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

            .navigationBarTitleDisplayMode(.inline)
            
            .background(
                backgroundGradient
            )
        }


       
        
        
        
    }
    
    
    
    
    private func deleteMoveType() {
        
        moveType.moves.forEach { modelContext.delete($0) }
        modelContext.delete(moveType)
        try? modelContext.save()
        dismiss()
        
        
        
    }
    
    
    init(moveType: MoveType) {
        
        self.moveType = moveType
        _typeName = .init(initialValue: moveType.name)
        
    }
        
        
        
        
        
        
    }


#Preview {
    let sample = MoveType.example
    MoveTypeView(moveType: sample)
}
