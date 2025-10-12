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
                .font(.headline)
                
                TextField("Move name", text: $title)
                    .bubbleStyle()
                    .limitText($title, to: 20)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Type").font(.headline)
                    Button {
                        isNew.toggle()
                    } label: {
                        if !moveTypes.isEmpty {
                        Image(systemName: isNew ? "return" : "plus.circle")
                        }
                   
                    }
                }
                
                HStack {
                    
                    ZStack {
                        
                        if isNew || moveTypes.isEmpty {
                            Group {
                                TextField("New type", text: $newType)
                                    .limitText($newType, to: 15)
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
                                        .foregroundStyle(selectedType == moveType ? Color.white : Color.gray)
                                        .fontWeight(.semibold)
                                     
                                        .background(
                                            ZStack {
                                                if selectedType == moveType {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color.accentColor)
                                                } else {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.gray, lineWidth: 2)
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                            .contentMargins(1)
                            .frame(height: 50)
                            .transition(.opacity)
                        }
                    }
                    .frame(height: 50)
                    .animation(.easeInOut(duration: 0.3), value: isNew)
                    
                    Spacer()
                    
                   
                    
                    

                    
                }
            }
         
            .padding(.vertical)
            
            Button(action: {
                addMove()
                dismiss()
            }) {
                Text("Add")
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isDisabled())
            .padding()
            
           
          
            
           
                
 
          
        }
        .padding()
        .customBlueBackground()
        .padding()
       
        
    }
    
    private func addMove() {
        
        if isNew || moveTypes.isEmpty  {
            let newMoveType = MoveType(name: newType, abbreviation: String(newType.first!) )
            part.moves.append(Move(title: title, details: "", order: part.moves.count + 1, type: newMoveType))
        }
        else {
            
            
            if let selectedType = selectedType {
                part.moves.append(Move(title: title, details: "", order: part.moves.count + 1, type: selectedType))
                
            }
        }
        
    }
    
    
    
    private func isDisabled() ->  Bool {
        
        if moveTypes.isEmpty  {
            
            return  newType.isEmpty || title.isEmpty
        }
        
        else if isNew {
            return newType.isEmpty || title.isEmpty
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
