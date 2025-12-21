//
//  DropViewDelegate.swift
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/21.
//

import Foundation
import SwiftUI

struct DropViewDelegate<Item: Identifiable & Equatable>: DropDelegate {
    
    let destinationItem: Item
    @Binding var items: [Item]
    @Binding var draggedItem: Item?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        if let draggedItem {
            let fromIndex = items.firstIndex(of: draggedItem)
            if let fromIndex {
                let toIndex = items.firstIndex(of: destinationItem)
                if let toIndex, fromIndex != toIndex {
                    withAnimation(Animation.smoothReorder) {
                        self.items.move(
                            fromOffsets: IndexSet(integer: fromIndex),
                            toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex)
                        )
                    }
                }
            }
        }
    }
}
