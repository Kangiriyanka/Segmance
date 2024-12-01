//
//  AddMoveView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/04/23.
//

import SwiftUI

struct AddMoveView: View {
    var part: Part
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var type: Move.MoveType = .neutral
    
    @State private var moveTypes: Move.MoveType = .juggling
    var body: some View {
        Form {
            Section("Move Name and Type") {
                TextField("Enter a move name", text: $title)
                    .limitText($title, to: 20)
                Picker("Type", selection: $type) {
                    ForEach(Move.MoveType.allCases, id: \.self) { move in
                        Text("\(move)")
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
        part.moves.append(Move(title: title, details: "", order: part.moves.count + 1, type: type.rawValue))
    }
}

#Preview {
    
    let sample = Part.firstPartExample
    AddMoveView(part: sample)
  
}
