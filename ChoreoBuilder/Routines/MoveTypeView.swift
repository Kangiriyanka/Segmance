//
//  MoveTypeView.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/09.
//

import SwiftUI

struct MoveTypeView: View {
    
    @Bindable var moveType: MoveType
    var body: some View {
        Text("Edit Name")
        TextField("Move name", text: $moveType.name)
            .bubbleStyle()
            .padding()
        
    }
}

#Preview {
    let sample = MoveType.example
    MoveTypeView(moveType: sample)
}
