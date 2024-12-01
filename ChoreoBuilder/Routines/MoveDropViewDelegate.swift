//
//  DropViewDelegate.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/21.
//

import Foundation
import SwiftUI

struct MoveDropViewDelegate: DropDelegate {
    let destinationMove: Move
    @Binding var originalArray: [Move]
    @Binding var draggedMove: Move?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
      
        draggedMove = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedMove,
              let fromIndex = originalArray.firstIndex(where: { $0.id == draggedMove.id }),
              let toIndex = originalArray.firstIndex(where: { $0.id == destinationMove.id }),
              fromIndex != toIndex else { return }
        
        withAnimation {
  
            originalArray.move(
                fromOffsets: IndexSet(integer: fromIndex),
                toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex)
            )
            
            updateOrderNumbers()
            
         
            
        
         
        }
    }
    
    private func updateOrderNumbers() {
        
      
        for (index, move) in originalArray.enumerated() {
            move.order = index + 1 
            originalArray[index] = move
        }
     }
}
