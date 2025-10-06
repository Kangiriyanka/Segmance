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
    @State private var isNew: Bool = false
    @State private var newType: String = ""
    @State private var abbreviation: String = ""
    @Query(sort: \MoveType.name) var moveTypes: [MoveType]
    
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Section("Move") {
                
                TextField("Move name", text: $title)
                    .bubbleStyle()
                    .limitText($title, to: 20)
                
                HStack {
                
              
                
                
            
                    
                    if isNew {
                        
                        Group {
                            TextField("New type", text: $newType)
                            
                       
                        }.bubbleStyle()
                        
                        
                        
                    }
                    
                    else  {
                        ForEach(moveTypes) { moveType in
                            
                            Button(moveType.name) {
                                selectedType = moveType
                            }
                            .foregroundStyle(selectedType == moveType ? Color.blue : Color.accentColor)
                            
                            
                        }
                        
                         
                        
                       
                    }
                    Spacer()
                    Button("New") {
                        
                        isNew.toggle()
                        
                    }
                   
                }
                
                Button("Add") {
                    addMove()
                    dismiss()
                }
                .padding()
                .overlay(
                    Circle()
                       
                    
                        .stroke(style: StrokeStyle(lineWidth:1))
                )
                
               
                .bold()
              
                
               
            }
          
          
        }
    }
    
    func addMove() {
        if let selectedType = selectedType {
            part.moves.append(Move(title: title, details: "", order: part.moves.count + 1, type: selectedType))
            
        }
        
        if isNew {
            let newMoveType = MoveType(name: newType, abbreviation: abbreviation)
            part.moves.append(Move(title: title, details: "", order: part.moves.count + 1, type: newMoveType))
        }

    }
    
    
    private var newMove: some View {
        
        VStack {
            TextField("Enter a new move type", text: $title)
                .padding()
            Button("Add") {
                addMove()
                dismiss()
            }
        }
    }
}

#Preview {
    
    
    let container = MoveType.previewContainer
    let sample = Part.firstPartExample
    AddMoveView(part: sample)
        .modelContainer(container)
    
  
}
