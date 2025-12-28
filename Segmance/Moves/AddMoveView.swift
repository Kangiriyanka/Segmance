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
        VStack(alignment: .leading, spacing: 13) {
            
            HStack(spacing: 6) {
            
                usageTitle(title: "1. Enter a move name")
             
                
            
           
        }
                
                TextField("Enter a move name", text: $title)
                    .bubbleStyle()
                    .limitText($title, to: 20)
            
            VStack(alignment: .leading, spacing: 13) {
                HStack(spacing: 6){
                 
                    
                    if moveTypes.isEmpty {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            HStack(spacing: 5) {
                                usageTitleProminent(title: "2. Create your first move type")
                                
                                Image(systemName: "tag")
                                    .foregroundStyle(.accent).opacity(0.7)
                                    .font(.system(size: 16, weight: .semibold))
                               
                            }
                            Text("The move type is a quick mental note on how to execute the move. Examples: Rest, Transition, Power Move, Spin, Cascade etc.")
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundStyle(.secondary)
                                .font(.caption2)
                            
                              
                            
                        }
                      
                        
                        
                    }
                    else {
                        usageTitle(title: "2. Select a move type or create one")
                    }
                   
                     
                    
                      
                
                    Button {
                        isNew.toggle()
                    } label: {
                        if !moveTypes.isEmpty {
                        
                        Image(systemName: isNew ? "return" : "plus.circle")
                        }
                           
                   
                    }
                    .buttonStyle(MiniAudioButtonStyle(width: 30, color: .routineCard.opacity(0.85)))
                   
                }
                
                HStack {
                    
                    ZStack {
                        
                        if isNew || moveTypes.isEmpty {
                            Group {
                                TextField("Enter a new type", text: $newType)
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
                                                        .fill(Color.accentColor.opacity(0.7))
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
                            .scrollDismissesKeyboard(.immediately)
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
                withAnimation(.organicFastBounce) {
                    addMove()
                }
                    dismiss()
                
            }) {
                Text("Add Move")
                    
            }
            .frame(maxWidth: .infinity)
            .disabled(isDisabled())
            
            .buttonStyle(ReviewButtonStyle(isDisabled: isDisabled()))
            .contentShape(Rectangle())
            

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
    let sample = Part.secondPartExample
    AddMoveView(part: sample)
        .modelContainer(container)
    
  
}
