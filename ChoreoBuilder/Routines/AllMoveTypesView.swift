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

                    // Your custom search bar at the top
                    CustomSearchBar(
                        text: $searchText,
                        placeholder: "Search move types"
                    )
                    .padding()
                 

                    Group {
                        if filteredMoveTypes.isEmpty {
                            ContentUnavailableView {
                                Label("No move types found", systemImage: "music.quarternote.3")
                            } description: {
                                Text("Create a type when you add moves to your routine using the \(Image(systemName: "figure.dance")) button.")
                                    .padding(.top, 5)
                            }
                        } else {
                            List(filteredMoveTypes) { type in
                                
                                HStack {
                                    Text(type.name)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                    .bubbleStyle()
                                            .background(
                                              NavigationLink("", destination: MoveTypeView(moveType: type))
                                                .opacity(0)
                                        )
                             
                                
                              
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                }

                .navigationTitle("Move Types")
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .background(backgroundGradient)
            }
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
