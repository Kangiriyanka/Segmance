//
//  MoveView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/18.
//

import SwiftUI


struct MyDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Button {
                withAnimation(.organicFastBounce) {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack {
                
               
                      
                    Text("")
                      
                        
                     
                }
           
                // Tapping anywhere on the divider
                .frame(maxWidth: .infinity, maxHeight: 30)
                .contentShape(.rect)
                
        
                
            }
       
           
            
            if configuration.isExpanded {
                configuration.content
                    .transition(.blurReplace)
            }
        }
     
        .offset(y: -15)
        
        
        
    }
}



struct MoveView: View {
    
    @State private var moveTitle = ""
    @State private var moveDescription = ""
    @State private var typedCharacters = 0
    @State private var moveTitleLimit =  30
    @State private var characterLimit = 200
    @State private var showMoveType = false
    let tip = MoveTip(customText: "Hold the number to delete the move.")
    
    
    @FocusState private var isFocused: Bool
    var deleteFunction : (UUID) -> ()

    @Bindable var move: Move
    
    var moveTypeText: String {
        if let type = move.type {
            return showMoveType ? type.name : type.abbreviation
        } else {
            return ""
        }
    }
    var body: some View {
        
        
        
        
        VStack {
            HStack{
                TextField("Enter a move title", text: $move.title)
                    .limitText($move.title, to: moveTitleLimit)
                    .foregroundStyle(Color.mainText)
                Spacer()
                
                VStack(alignment: .trailing) {
                    
                    
                    
                    HStack {
                       
                        moveMarker(width: showMoveType ? 120 : 40, height: 20, text: moveTypeText, color: Color.customPink)
                            .onTapGesture {
                                 
                                    showMoveType.toggle()
                                
                                
                            }
                          
                            .contentShape(Rectangle())
                    
                            .transition(.slide)
                            .animation(.organicFastBounce, value: showMoveType)
                            
                        
                        moveMarker(width: 40, height: 20, text: String(move.order), color: Color.player)
                            .popoverTip(tip)
                            .contentShape(RoundedRectangle(cornerRadius: 4.0))
                            .contextMenu {
                                Button(role: .destructive) {
                                    deleteFunction(move.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        
                            .onAppear {
                                    Task {
                                        await MoveTip.setMoveEvent.donate()
                                    }
                                }
                        
                    }
                   
                    
                
                }
               
                
                
                

                .font(.headline)
       
        
                
              
            }
            
            .frame(width: 300, height: 30)
          
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
         
            Divider()
            DisclosureGroup("") {
                
               
                VStack {
                    
                    TextEditor(text: $move.details)
                        .frame(maxHeight: .infinity)
                        .font(.system(size: 16))
                        .lineSpacing(5)
                        .padding(1)
                        .textInputAutocapitalization(.never)
                        .scrollContentBackground(.hidden)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.customBlue.opacity(0.1))
                                .stroke(.black.opacity(0.7), lineWidth: 1)
                        }
                        
                        .focused($isFocused)
                        .submitLabel(.done)
                        .disableAutocorrection(true)
                    
                        .limitText($move.details, to: characterLimit)
                }
               
                .padding(5)
                .frame(height: 150)
              

                    HStack {
                        
                        
                        
                        Spacer()
                        Text(" \($move.details.wrappedValue.count) / \(characterLimit)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                    }
               
                    
  
            }
           
  
            
            .disclosureGroupStyle(MyDisclosureStyle())
            
         
            
            
            
            
            
            
            
        }
        
       
        
        

   
        .frame(width: UIScreen.main.bounds.width - 75)
        .padding(.horizontal, 20)
        .background(routineCardBackground)
        .customBorderStyle()
        .clipShape(RoundedRectangle(cornerRadius: 10))

     
        
        
        
    }
   
    private func updateMoveInfo(move: Move) {
        move.title = moveTitle
        
    }
    
    private func moveMarker(width: CGFloat, height: CGFloat, text: String, color: Color) -> some View {
        
        Text(text) .foregroundStyle(Color.mainText.opacity(0.85))
        
        .frame(width: width, height: height)
        
        .background(RoundedRectangle(cornerRadius: 4.0)
                    
            .fill(color.opacity(0.5))
            .stroke(.black.opacity(0.3), lineWidth: 1)
            .shadow(radius: 2, x: 0, y: 1)
                    )
    }
    
    
}





#Preview {
    
    let moveType = MoveType(name: "Juggling", abbreviation: "J")
    let move = Move(title: "Test", details: "Test", order: 1, type: moveType )
    MoveView(deleteFunction: { _ in }, move: move )
    
    
}

