//
//  AddMoveView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/04/23.
//

import SwiftUI
import SwiftData
struct AddMoveView: View {
    var part: Part
    
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var selectedType: MoveType?
    @Query(sort: \MoveType.name) var moveTypes: [MoveType]
    
    
    
    var body: some View {
        Form {
            Section("Move Name and Type") {
                TextField("Enter a move name", text: $title)
                    .limitText($title, to: 20)
                Picker("Type", selection: $selectedType) {
                    ForEach(moveTypes,  id: \.self) { type in
                        Text(type.name)
                    }
                }
                
                Button("Add") {
                    addMove()
                    dismiss()
                }
            }
          
        }
    }
    
    func addMove() {
        if let selectedType = selectedType {
            part.moves.append(Move(title: title, details: "", order: part.moves.count + 1, type: selectedType))
            
        }

    }
}

#Preview {
    
    let sample = Part.firstPartExample
    AddMoveView(part: sample)
  
}
