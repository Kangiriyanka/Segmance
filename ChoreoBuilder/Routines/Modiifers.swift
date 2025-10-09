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
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.8), lineWidth: 1))
        
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








extension View {
    func bubbleStyle() -> some View  {
        modifier(BubbleTextField())
    }
    
    func customBlueBackground() -> some View  {
        modifier(CustomBlueBackground())
    }
}


