//
//  TextEffects.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/11/21.
//

import SwiftUI
struct SlidingText: View {
    let text: String
    let speed: Double = 30
    let spacing: CGFloat = 50
    
    @State private var offset: CGFloat = 0
    @State private var needsSliding = false
    @State private var textWidth: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: needsSliding ? spacing : 0) {
                Text(text)
                    .fixedSize()
                    .background(
                        GeometryReader { textGeo in
                            Color.clear.onAppear {
                                textWidth = textGeo.size.width
                                needsSliding = textWidth > geo.size.width
                                
                                guard needsSliding else { return }
                                
                                let segmentWidth = textWidth + spacing
                                
                                withAnimation(.linear(duration: segmentWidth / speed).repeatForever(autoreverses: false)) {
                                    offset = -segmentWidth
                                }
                            }
                        }
                    )
                if needsSliding {
                    Text(text).fixedSize()
                }
            }
            .offset(x: offset)
            
        }
        .mask {
         
                if needsSliding {
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0.0),
                            .init(color: .black, location: 0.1),
                            .init(color: .black, location: 0.9),
                            .init(color: .clear, location: 1.0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
                    else {
                        Color.black
                    }
                }
        
        
        .clipped()
        .frame(height: 20)
    }
}

#Preview {
    SlidingText(text: "Joe is taking")
}

#Preview {
    
    SlidingText(text: "Joe is taking dfdfdthe best possiblefdfd action right now")
}
