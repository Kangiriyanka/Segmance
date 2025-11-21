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
            Color.customBlue.opacity(0.9),
            Color.customBlue.opacity(0.7)
        ],
        center: .topLeading,
        startRadius: 10,
        endRadius: 600
    )
}

var cardBackground: some View {
    
        Color.routineCard
           
    
}




var shadowOutline: some View {
    RoundedRectangle(cornerRadius: 10)
        .stroke(Color.black.opacity(0.3), lineWidth: 1)
        .shadow(radius: 2, x: 0, y: 2)
    
}

var playerBackground: RadialGradient {
    RadialGradient(
        colors: [
            Color.player.opacity(0.9),
            Color.player.opacity(0.8)
          
            
        ],
        center: .topLeading,
        startRadius: 50,
        endRadius: 600
    )
}


// -----------DEMOS------------------ //

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

struct DarkBackgrounds: View {
    var body: some View {
        VStack {
            Text("Deku Palace")
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
    TabView {
        Backgrounds()
        DarkBackgrounds().preferredColorScheme(.dark)
    }
    .tabViewStyle(.page)
    
}
