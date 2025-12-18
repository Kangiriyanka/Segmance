//
//  Backgrounds.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/15.
//

import Foundation
import SwiftUI


var SineBackground: some View {
 
    let off: Double = 30
    let waves: Int = 11
    let strokeWidth: CGFloat = 9
    
  

    return ZStack(alignment: .bottom) {
        ForEach(0..<waves, id: \.self) { i in
            SineWave(
                frequency: 2.0,
                amplitude: 12.0,
                phase: 0
            )
            .stroke(
                Color.customLB.opacity(0.3),
                lineWidth: CGFloat(strokeWidth)
            )
            .offset(y: off * Double(i) * 0.5)
        }
            
      
        
    }
    


    
}


// Usage in your background
var backgroundGradient: some View {
    ZStack(alignment: .bottom) {
     
        SineBackground
            .frame(height: 300)
              
            
        
      
        
        RadialGradient(
            colors: [
                Color.customBlue.opacity(0.9),
                Color.customBlue.opacity(0.8)
            ],
            center: .topLeading,
            startRadius: 10,
            endRadius: 600
        )
     
        
        
        
    }
    .ignoresSafeArea()
}

var noSinBackgroundGradient: some View {
    ZStack(alignment: .bottom) {
     
    
        
        RadialGradient(
            colors: [
                Color.customBlue.opacity(0.9),
                Color.customBlue.opacity(0.8)
            ],
            center: .topLeading,
            startRadius: 10,
            endRadius: 600
        )
     
        
        
        
    }
    .ignoresSafeArea()
}

var cardBackground: some View {
    
        Color.routineCard
           
    
}

var routineCardBackground: some View {
    
    RoundedRectangle(cornerRadius: 10)
        .fill(
            LinearGradient(
                colors: [
                    .customBlue.opacity(0.8),
                    .customBlue.opacity(0.7),
                    .customBlue.opacity(0.5),
                    .customBlue.opacity(0.4),
                  
                   
                ],
                startPoint: .bottom,
                endPoint: .top
            )
        )
        .frame(height: 40)
        .blur(radius: 30)
        .frame(maxHeight: .infinity, alignment: .bottom)
    
       
}

var shadowOutline: some View {
    RoundedRectangle(cornerRadius: 10)
        .stroke(Color.black.opacity(0.3), lineWidth: 1)
        .shadow(radius: 2, x: 0, y: 2)
    
}

var trimmerOutline: some View {
    RoundedRectangle(cornerRadius: 10)
        .stroke(Color.black.opacity(0.3), lineWidth: 2)
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


var optionsBackground: some View {
    return (
        ZStack{
            RoundedRectangle(cornerRadius: 10)
           
                .fill(Color.customWhite.opacity(0.1))
            
            
        }
            
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
        VStack {
            Text("HI")
        }
        .frame(maxWidth: .infinity)
        .background(routineCardBackground)
        Backgrounds()
        DarkBackgrounds().preferredColorScheme(.dark)
    }
    .tabViewStyle(.page)
    
}

