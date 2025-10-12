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
    
    var body: some View {
        Text("Edit Type Name")
        TextField("Type name", text: $typeName)
            .bubbleStyle()
            .padding()
        
        
        Button("Delete") {
            deleteMoveType()
        }
        .buttonStyle(.borderedProminent)
        
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
