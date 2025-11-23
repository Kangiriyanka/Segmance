//
//  PartView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/18.
//

import SwiftUI

struct PartView: View {
    
    @State var part: Part
    var moves: [Move] { part.moves.sorted { $0.order < $1.order }}
    @State private var moveTitle = ""
    @State private var moveDescription = ""
    @State private var audioPlayerPresented = false
    @State private var showingAddMoveSheet: Bool = false
    @State private var draggedMove: Move?
    @FocusState private var focusedMoveID: UUID?
    @State private var scrollTarget: UUID?
    @Namespace private var animation


    var body: some View {
        
    
            ZStack {
                
                backgroundGradient.ignoresSafeArea(.all)
               
                
                VStack {
                    
                    
                    HStack {
                        Text("\(part.order). \(part.title)")
                            .font(.body)
                            .bold()
                        
                        Spacer()
                        
                        HStack(spacing: 5) {
                            Button {
                                withAnimation(Animation.organicFastBounce) {
                                    audioPlayerPresented.toggle()
                                }
                            } label: {
                                Image(systemName: "music.quarternote.3")
                                    .foregroundColor(.mainText)
                                    .frame(maxHeight: 30)
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(Color.routineCard)
                                    )
                            }
                            
                            
                      
                            
                            Button {
                                withAnimation {
                                    showingAddMoveSheet.toggle()
                                }
                            } label: {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.mainText)
                                    .frame(maxHeight: 30)
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(Color.routineCard)
                                    )
                                   
                            }
                         
                        }
                        
                        .foregroundStyle(.black)
                        .frame(width: 100, height: 40)
                        .padding(5)
                     
                    }
                 
                    .padding()
                    
                    
                    
                    
                    
                    
                    VStack {
                        
                        
                        ScrollViewReader { proxy in
                            ScrollView(showsIndicators: false) {
                                
                                if part.moves.isEmpty {
                                    ContentUnavailableView {
                                        Label("No moves added", systemImage: "figure.dance")
                                    } description: {
                                        Text("Add moves by tapping the \(Image(systemName: "plus.circle")) button.").padding([.top], 5)
                                    }
                                    
                                    
                                }
                                
                                VStack(spacing: 50){
                                    
                                    ForEach(moves) { move in
                                        
                                     
                                        MoveView(deleteFunction: self.deleteMove, move: move)
                                            .onDrag {
                                                draggedMove = move
                                                return NSItemProvider()
                                            }
                                            .onDrop(
                                                of: [.text],
                                                delegate: MoveDropViewDelegate(
                                                    destinationMove: move,
                                                    originalArray: $part.moves,
                                                    draggedMove: $draggedMove)
                                            )
                                        
                                            .id(move.id)
                                            .focused($focusedMoveID, equals: move.id)
                                            .contentShape(.contextMenuPreview,
                                                          RoundedRectangle(cornerRadius: 10))
                                                                                    .contextMenu {
                                                                                        Button(role: .destructive) {
                                                                                            deleteMove(id: move.id)
                                                                                        } label: {
                                                                                            Label("Delete", systemImage: "trash")
                                                                                        }
                                                                                    }
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                    }
                                }
                              
                             
                               
                           
                              
                               
                            }
                            
                            .onTapGesture {
                                focusedMoveID = nil
                            }
                            .scrollDismissesKeyboard(.immediately)
                           
                            .onChange(of: focusedMoveID) { _, newValue in
                                
                                if let id = newValue {
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation {
                                            proxy.scrollTo(id, anchor: .center)
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    .sheet(isPresented: $showingAddMoveSheet){
                        ZStack {
                            backgroundGradient
                                .ignoresSafeArea()

                            AddMoveView(part: part)
                                .padding()
                               
                        }
                           
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .presentationDetents([.fraction(0.5)])
                        
                    }
                   
                    
                    
                    
                    
                }
                
                    if audioPlayerPresented {
                        if let partURL = part.location {
                            AudioPlayerView(audioFileURL: partURL, partTitle: part.title)
                                .offset(y: audioPlayerPresented ? 0 : 400)
                                    .opacity(audioPlayerPresented ? 1 : 0)
                                    .transition(.blurReplace)
                            
                            
                        }
                        
                    }
                
             
                
                
                
                
            }
           
        
           
        
        
        
    }
    

    
    private func deleteMove(id: UUID) -> () {
        if let moveToDelete = part.moves.first(where: {$0.id == id}) {
            
            part.moves.removeAll{ $0.id == id }
            part.moves.forEach { move in
                if move.order > moveToDelete.order {
                    move.order -= 1
                }
            }
        }
        
    }
    
    
    
}


#Preview {
    
   

    let part = Part.firstPartExample
   
    PartView(part: part )
}
