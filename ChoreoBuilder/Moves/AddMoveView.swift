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
        VStack(alignment: .leading, spacing: 5) {
            
            Text("New Move")
                .font(.headline)
                
                TextField("Move name", text: $title)
                    .bubbleStyle()
                    .limitText($title, to: 20)
            
            VStack(alignment: .leading) {
                HStack(spacing: 5){
                    Text("Type").font(.headline)
                    Button {
                        isNew.toggle()
                    } label: {
                        if !moveTypes.isEmpty {
                        Image(systemName: isNew ? "return" : "plus.circle") .foregroundStyle(Color.mainText.opacity(0.8))
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
                                        .foregroundStyle(selectedType == moveType ? Color.white : Color.gray.opacity(0.5))
                                        .fontWeight(.semibold)
                                     
                                     
                                        .background(
                                            ZStack {
                                                if selectedType == moveType {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.accentColor)
                                                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                                } else {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
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
                Image(systemName: "plus.circle")
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .fontWeight(.semibold)
            }
            .buttonStyle(PressableButtonStyle())
            
            .disabled(isDisabled())
            .padding()
            
           
          
            
           
                
 
          
        }
       
        
    
       
        
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
