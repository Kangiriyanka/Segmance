//
//  Move.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/18.
//


import Foundation
import SwiftData

@Model
class Move {
    
    var id: UUID = UUID()
    var title: String = ""
    var type: MoveType?
    var details: String
    var parent: Part?
    var order: Int
    
    
 
    // The copy is made to prevent permanent changes when the user changes details about the move
    func copy() -> Move {
        let newMove = Move(title: self.title, details: self.details, order: self.order, type: self.type!)
        return newMove
    }
 

    init(title: String, details: String, order: Int, type: MoveType) {
        
        self.title = title
        self.details = details
        self.order = order
        self.type = type
        
    }
    
    
    static let example1 = Move(title: "Example Move", details: "This is an example move", order: 1, type: MoveType.init(name: "Juggling", abbreviation: "J"))
    static let example2 = Move(title: "Example Move 2", details: "This is an example move 2", order: 2, type: MoveType.init(name: "Juggling", abbreviation: "J"))
    static let example3 = Move(title: "Example Move 3", details: "This is an example move 3", order: 3, type: MoveType.init(name: "Dancing", abbreviation: "D"))
    static let example4 = Move(title: "Example Move 4", details: "This is an example move 4", order: 4, type: MoveType.init(name: "Dancing", abbreviation: "J"))
        

}
