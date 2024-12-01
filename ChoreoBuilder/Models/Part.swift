//
//  Part.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/12.
//

import Foundation
import SwiftData

@Model
class Part {
    
    var id: UUID = UUID()
    var title: String
    var fileName: String
    var parent: Routine?
    var order: Int
    @Relationship(deleteRule: .cascade) var moves =  [Move]()
    
    var location: URL? {
        
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(fileName)
        
    }
    
    func copy() -> Part {
        let newPart = Part(title: self.title, fileName: self.fileName, order: self.order)
        newPart.moves = self.moves.map { $0.copy() }
        return newPart
    }
    
    init(title: String, fileName: String, order: Int ) {
        self.title = title
        self.fileName = fileName
        self.order = order
     
       
    }
    
    static let firstPartExample = Part(title: "First Example Part", fileName: "firstExample.mp3", order: 1)
    static let secondPartExample = Part(title: "Second Example Part", fileName: "secondExample.mp3", order: 2)
    

}
