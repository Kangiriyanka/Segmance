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


#Preview {
    ZStack {
        LoopMarker()
            .frame(width: 100, height: 200)
            
    }
    
}
    
    




