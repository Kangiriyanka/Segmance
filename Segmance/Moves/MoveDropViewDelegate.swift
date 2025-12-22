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
      
          guard draggedMove != nil else { return false }
           draggedMove = nil
           return true
    
    }
    
    func dropEntered(info: DropInfo) {
        
        // Video player can trigger a drag
        guard let draggedMove = draggedMove else { return }
        
        var sortedArray = originalArray.sorted { $0.order < $1.order }
        
        guard
              let fromIndex = sortedArray.firstIndex(where: { $0.id == draggedMove.id }),
              let toIndex = sortedArray.firstIndex(where: { $0.id == destinationMove.id }),
              fromIndex != toIndex else { return }
        
        // Remove withAnimation here: just update the data, let the view handle the animation.

        withAnimation(.smoothReorder) {
            sortedArray.move(
                fromOffsets: IndexSet(integer: fromIndex),
                toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex)
            )
            
            
            updateOrderNumbers(newArray: sortedArray)
        }
            
      
    }
    
    private func updateOrderNumbers(newArray: [Move]) {
        
      
        for (index, move) in newArray.enumerated() {
            move.order = index + 1
           
        }
     }
}
