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
                withAnimation(.spring(duration: 0.3)) {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack {
                
                  
                    Spacer()
                                     Text("")
                        .padding()
                                         .foregroundColor(.accentColor)
                                         .font(.caption.lowercaseSmallCaps())
                                         .animation(nil, value: configuration.isExpanded)
                    Spacer()
                      
                        
                     
                }
                // Tapping anywhere on the divider
                .frame(maxWidth: .infinity, maxHeight: 20)
                
        
                
            }
       
           
            
            if configuration.isExpanded {
                configuration.content
                    .transition(.blurReplace)
            }
        }
        .contentShape(Rectangle())
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
    @FocusState private var isFocused: Bool
    var deleteFunction : (UUID) -> ()

    @Bindable var move: Move
    var body: some View {
        
        
        
        
        VStack {
            HStack{
                TextField("Enter a move title", text: $move.title)
                    .limitText($move.title, to: moveTitleLimit)
                    .foregroundStyle(Color.mainText)
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        moveMarker(width: 40, height: 20, text: move.type!.abbreviation, color: Color.customPink)
                        
                        moveMarker(width: 40, height: 20, text: String(move.order), color: Color.customBlue)
                        
                    }
                    .padding(5)
                
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
               
               
                .frame(height: 150)
              

                    HStack {
                        
                        
                        
                        Spacer()
                        Text(" \($move.details.wrappedValue.count) / \(characterLimit)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                    }
               
                    
  
            }
            .frame(maxWidth: .infinity)
            .disclosureGroupStyle(MyDisclosureStyle())
            
            
            
            
            
            
            
        }
        
       
        
        

   
        .frame(width: 300)
        .padding(.horizontal, 20)
        .background(cardBackground)
        .customBorderStyle()
        .clipShape(RoundedRectangle(cornerRadius: 10))

     
        
        
        
    }
   
    private func updateMoveInfo(move: Move) {
        move.title = moveTitle
        
    }
    
    private func moveMarker(width: CGFloat, height: CGFloat, text: String, color: Color) -> some View {
        
        Text(text) .foregroundStyle(Color.mainText)
        
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
