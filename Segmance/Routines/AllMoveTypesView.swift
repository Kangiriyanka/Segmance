//
//  AllMoveTypesView.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/07.
//

import SwiftUI
import SwiftData

struct AllMoveTypesView: View {
    
    @Query(sort: \MoveType.name) var moveTypes: [MoveType]
    @State private var searchText: String = ""
    var filteredMoveTypes: [MoveType] {
               if searchText.isEmpty {
                   return moveTypes
               }
        return moveTypes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    
    
    var body: some View {
            NavigationStack {

                VStack(spacing: 0) {

                    HStack{
                        Spacer()
                        CustomSearchBar(text: $searchText, placeholder: "Search move types")
                            .padding()
                        
                        
                        
                    }
                    
                 

                    Group {
                        if filteredMoveTypes.isEmpty {
                            
                            VStack {
                                ContentUnavailableView {
                                    Label("No move types found", systemImage: "music.quarternote.3")
                                } description: {
                                    Text("Create a move type when you add moves to a routine.")
                                        .padding(.top, 5)
                                }
                                
                            }
                            .offset(y: -63)
                        } else {
                          
                            
                            ScrollView {
                                LazyVStack(spacing: 16) {
                                    ForEach(filteredMoveTypes) { type in
                                        NavigationLink(destination: MoveTypeView(moveType: type)) {
                                            HStack {
                                                Image(systemName: "circle.fill")
                                                    .foregroundStyle(.accent.opacity(0.7))
                                                    .font(.system(size: 8, weight: .semibold))

                                                Text(type.name)
                                                    .font(.headline.weight(.semibold))
                                                    .foregroundStyle(Color.mainText)

                                                Spacer()
                                            }
                                            .bubbleStyle()
                                        }
                                        .buttonStyle(NavButtonStyle())
                                    }
                                }
                                .padding()
                            }
                        
                            
                            
                           
                          
                         
                        }
                    }
                   
                }
                

                
                .navigationTitle("Move Types")
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .background(backgroundGradient)
                
            }
            .ignoresSafeArea(.keyboard)
        }
    
}

#Preview {
    let container = MoveType.previewContainer
    AllMoveTypesView()
        .modelContainer(container)
}


// No moves
#Preview {

    AllMoveTypesView()
    
}
