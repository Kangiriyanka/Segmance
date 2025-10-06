//
//  MoveType.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/05.
//

import Foundation
import SwiftData


@Model
class MoveType {
   
    var name: String
    var abbreviation: String
    
    init(name: String, abbreviation: String) {
        self.name = name
        self.abbreviation = abbreviation
    }
}
