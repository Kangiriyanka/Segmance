//
//  CompactMoveView.swift
//  Segmance
//
//  Created by Kangiriyanka The Single Leaf on 2025/12/20.
//

import Foundation
import SwiftUI


struct CompactMoveView: View {
    var move: Move
    let gridMode: String
    
    var fontSize: CGFloat {
        switch gridMode {
        case "grid2":
            return 16
        default:
            return 14
        }
    }
    
    var lineLimit: Int {
        switch gridMode {
        case "grid2":
            return 2
        default:
            return 3
        }
        
    }
    
    var height: CGFloat {
        switch gridMode {
        case "grid2":
            return 120
        default:
            return 130
        }
        
    }
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.player.opacity(0.85))
                    .frame(width: gridMode == "grid2" ? 40: 30, height: gridMode == "grid2" ? 40: 30)
                
                Text(String(move.order))
                    .foregroundStyle(.mainText.opacity(0.85))
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(width: 40, height: 40)
            
            
            Text(move.title)
                .font(.system(size: fontSize))
                .lineLimit(lineLimit)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.mainText)
                .truncationMode(.tail)
        
                
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: height, alignment: .top)
        .frame(height: height,  alignment: .top)
        .background(routineCardBackground)
       
        
        .customBorderStyle()
       
       
        
    }
    
    
    
    init(move: Move, gridMode: String) {
        self.move = move
        self.gridMode = gridMode
    }
}

#Preview {
    CompactMoveView(move: Move.example2, gridMode: "list")
}

