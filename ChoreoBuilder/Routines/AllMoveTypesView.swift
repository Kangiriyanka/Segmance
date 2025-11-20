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
        Group {
            if moveTypes.isEmpty {
                ContentUnavailableView {
                    Label("No move types yet", systemImage: "music.quarternote.3")
                } description: {
                    Text("Create a type when you add moves to your routine using the \(Image(systemName: "figure.dance")) button.")
                        .padding(.top, 5)
                }
            } else {
                List(moveTypes) { type in
                    NavigationLink {
                        MoveTypeView(moveType: type)
                    } label: {
                        Text(type.name)
                    }
                    .bubbleStyle()
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
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


// No moves
#Preview {

    AllMoveTypesView()
    
}
