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
            .italic(true).bold()
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.8), lineWidth: 1))
        
    }
    
}


extension View {
    func bubbleStyle() -> some View  {
        modifier(BubbleTextField())
    }
}


