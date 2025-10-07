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
    @Query(sort: \MoveType.name) var moveTypes: [MoveType]
    
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("New Move")
                .font(.title3)
                
                TextField("Move name", text: $title)
                    .bubbleStyle()
                    .limitText($title, to: 20)
            
            VStack(alignment: .leading) {
                Text("Type").font(.title3)
                
                HStack {
                    
                    ZStack {
                        
                        if isNew {
                            Group {
                                TextField("New type", text: $newType)
                            }
                            .bubbleStyle()
                            .transition(.opacity)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(moveTypes) { moveType in
                                        Button(moveType.name) {
                                            selectedType = moveType
                                        }
                                        .padding(8)
                                        .foregroundStyle(selectedType == moveType ? Color.blue : Color.gray)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(selectedType == moveType ? Color.blue : Color.gray, lineWidth: 1)
                                        )
                                    }
                                }
                            }
                            .frame(height: 50)
                            .transition(.opacity)
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: isNew)
                    
                    Spacer()
                    
                    Button(isNew ? "Back" : "New") {
                        withAnimation {
                            isNew.toggle()
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
            }
            .padding(.vertical)
            Button("Add") {
                addMove()
                dismiss()
            }
            .disabled(isDisabled())
            .frame(width: 200)
            .padding(20)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            .bold()
            .frame(maxWidth: .infinity)
                
                
                
            
        
        
          
        }
        .padding()
        
    }
    
    func addMove() {
        
        if isNew {
            let newMoveType = MoveType(name: newType, abbreviation: String(newType.first!) )
            part.moves.append(Move(title: title, details: "", order: part.moves.count + 1, type: newMoveType))
        }
        else {
            
            
            if let selectedType = selectedType {
                part.moves.append(Move(title: title, details: "", order: part.moves.count + 1, type: selectedType))
                
            }
        }
        
    

    }
    
    
    private var newMove: some View {
        
        VStack {
            TextField("Enter a new move type", text: $newType)
                .limitText($newType, to: 12)
                .padding()
            Button("Add") {
                addMove()
                dismiss()
            }
           
        }
    }
    
    private var typeCard: some View {
        
        VStack {
            
        }
    }
    
    private func isDisabled() ->  Bool {
        
        if isNew {
            
            return  newType.isEmpty || title.isEmpty 
            
        }
        
        else {
            return selectedType == nil || title.isEmpty
        }
        
    }
}

#Preview {
    
    
    let container = MoveType.previewContainer
    let sample = Part.firstPartExample
    AddMoveView(part: sample)
        .modelContainer(container)
    
  
}
