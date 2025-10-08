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
        List(moveTypes) { type in
            
            
            Text(type.name)
            
        }
    }
}

#Preview {
    let container = MoveType.previewContainer
    AllMoveTypesView()
        .modelContainer(container)
}
