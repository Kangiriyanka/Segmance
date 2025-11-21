//
//  Modiifers.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/06.
//

import Foundation
import SwiftUI





struct BubbleTextField: ViewModifier {
    

    func body(content: Content) -> some View {
        
        content
        .padding()
           .background(Color.routineCard)
           .overlay(
               RoundedRectangle(cornerRadius: 12)
                   .stroke(Color.black.opacity(0.2), lineWidth: 1)
           )
           .clipShape(RoundedRectangle(cornerRadius: 12))
          
        
    }
    
}


struct CustomBlueBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            
            .background(RoundedRectangle(cornerRadius:10)
                .fill(Color.customBlue.opacity(0.1))
                .stroke(.black.opacity(0.3), lineWidth: 1)
                .shadow(radius: 2, x: 0, y: 1))

    }
    
}


struct CustomBorderStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
        
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(0.2), lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
    }
}








extension View {
    func bubbleStyle() -> some View  {
        modifier(BubbleTextField())
    }
    
    func customBlueBackground() -> some View  {
        modifier(CustomBlueBackground())
    }
    
    func customBorderStyle() -> some View {
        modifier(CustomBorderStyle())
    }
}


