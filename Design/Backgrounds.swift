//
//  Backgrounds.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/15.
//

import Foundation
import SwiftUI


// Start radius is the inner glow
// End radius is the reach
var backgroundGradient: RadialGradient {
    RadialGradient(
        colors: [
            Color.customBlue.opacity(0.4),
            Color.customBlue.opacity(0.3)
        ],
        center: .topLeading,
        startRadius: 10,
        endRadius: 600
    )
}

var cardBackground: some View {
    Group {
        Color.customNavy
            .opacity(0.5)
         
        
    }
}

var playerBackground: RadialGradient {
    RadialGradient(
        colors: [
            Color.customBlue   // center glow
            
        ],
        center: .topLeading,
        startRadius: 50,   // start a bit away from corner
        endRadius: 600     // fade smoothly over larger area
    )
}



struct Backgrounds: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .frame(width: 800, height: 600)
            .background(backgroundGradient)
        
        VStack {
            Text("Kakariko Village")
            
        }
        .frame(width: 800, height: 600)
        .background(cardBackground)
    }
    
    
}
#Preview {
    
    Backgrounds()
    
}
