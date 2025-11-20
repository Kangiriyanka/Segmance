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
    var body: some View {
        if moveTypes.isEmpty {
            ContentUnavailableView {
                Label("No move types exist", systemImage: "music.quarternote.3")
            } description: {
                Text("Create a type when you add moves to your routine \(Image(systemName: "figure.dance")) button.").padding([.top], 5)
            }
        }
        List(moveTypes) { type in
            
            NavigationLink(type.name){
                MoveTypeView(moveType: type)
            }
            .bubbleStyle()
          
            
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
        .background(
            backgroundGradient
            )
        
    }
}

#Preview {
    let container = MoveType.previewContainer
    AllMoveTypesView()
        .modelContainer(container)
}
