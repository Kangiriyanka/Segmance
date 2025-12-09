//
//  Modiifers.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/06.
//

import Foundation
import SwiftUI



struct CustomHeader: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .tracking(0.2)
            .italic()
            .opacity(0.85)
    }
}


struct BubbleTextField: ViewModifier {
    

    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.routineCard)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
            )
            .buttonStyle(PlainButtonStyle())
            .textInputAutocapitalization(.never)
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
            .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
            .clipShape(RoundedRectangle(cornerRadius: 16))
           
    }
}

struct CustomLoopCircle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fixedSize()
        
            .font(.caption2)
            .padding(3)
          
            .background(
                    Ellipse()
                        .fill(Color.customBlue.opacity(0.8))
                )
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 3)
            .offset(x: 7)
    }
}


#Preview {
    
    @Previewable @State var a: Bool = false
    Text(a ? "Hold" : "AB" )
        .customCircle()
    
    Button("Toggle") {a.toggle()}
    
    Text("Hi").customHeader()
}








extension View {
    func bubbleStyle() -> some View  {
        modifier(BubbleTextField())
    }
    
    func customHeader() -> some View  {
        modifier(CustomHeader())
    }
    
    func customBlueBackground() -> some View  {
        modifier(CustomBlueBackground())
    }
    
    func customBorderStyle() -> some View {
        modifier(CustomBorderStyle())
    }
    
    func customCircle() -> some View {
        
        modifier(CustomLoopCircle())
    }
}



