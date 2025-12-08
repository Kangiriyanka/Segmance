//
//  Diamond.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/15.
//

import Foundation
import SwiftUI


struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width / 2, y: 0))             
        path.addLine(to: CGPoint(x: width, y: height / 2))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: 0, y: height / 2))
        path.closeSubpath()
        
        return path
    }
}





struct LoopMarker: Shape {
    // FROM SVG:
    //    M 0 0
    //    C 0 -10 10 -10 10 0
    //    Q 10 5 5 20
    //    Q 0 5 0 0
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: 0, y: 0))

            p.addCurve(
                to: CGPoint(x: 10, y: 0),
                control1: CGPoint(x: 0, y: -10),
                control2: CGPoint(x: 10, y: -10)
            )

            p.addQuadCurve(
                to: CGPoint(x: 5, y: 11),
                control: CGPoint(x: 10, y: 5)
            )

            p.addQuadCurve(
                to: CGPoint(x: 0, y: 0),
                control: CGPoint(x: 0, y: 5)
            )
        }
        }
    }



struct SineWave: Shape {
    var frequency: Double
    var amplitude: Double
    var phase: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.height / 2
        
        
        let step = max(rect.width / 200, 1)
        
        path.move(to: CGPoint(x: -rect.width * 1.2, y: midY))
        
        for x in stride(from: -rect.width * 1.2, through: rect.width * 1.2, by: step) {
            let relativeX = x / rect.width
            let base = sin(2 * .pi * frequency * relativeX + phase)
            let y = midY + base * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
}

#Preview {
    struct ShapesPreview: View {
        @State private var p: Double = 2.5
        @State private var f: Double = 0.6
        @State private var a: Double = 60
        @State private var off: Double = 20
        @State private var waves: Int = 3
        @State private var degrees: Int = 4
        @State private var strokeWidth: Int = 10
        
     
        
        
        var body: some View {
            VStack(spacing: 10) {
                
                HStack {
                    HStack {
                        Text("P:")
                        TextField("Phase", value: $p, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("F:")
                        TextField("Frequency", value: $f, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text("A:")
                        TextField("Amplitude", value: $a, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("O:")
                        TextField("Offset", value: $off, format: .number)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                HStack {
            
                        Text("Waves:")
                        TextField("Waves", value: $waves, format: .number)
                    
                    Text("Deg:")
                    TextField("Degrees", value: $degrees, format: .number)
                    
                    Text("Stroke:")
                    TextField("Stroke", value: $strokeWidth, format: .number)
                    
                    
                    
                        

                    
                }
            }
                
                ZStack {
                    Rectangle().fill(Color.customBlue)
                    
                  
                    // Joue sur fréquence
                 
                    ForEach(0..<waves, id: \.self) { i in
                        SineWave(
                            frequency: f,
                            amplitude: a,
                            phase: p * Double(i) * 5
                        )
                        .stroke(
                            Color.customLB.opacity(0.1),
                            lineWidth: CGFloat(strokeWidth)
                        )
                        .offset(y: off * Double(i))
                        .rotationEffect(.degrees(Double(degrees)))
                    }
                  
                   
                    
                    
                 
                }
                .ignoresSafeArea(.all)
          
        }
    }
    
    return ShapesPreview()
}
