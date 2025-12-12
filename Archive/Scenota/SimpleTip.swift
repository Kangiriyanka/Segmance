//
//  SimpleTip.swift
//  Scenota
//
//  Created by Kangiriyanka The Single Leaf on 2025/12/09.
//


import TipKit
import SwiftUI

struct UploadTip: Tip {
    
    static let setUploadEvent = Event(id: "uploadEvent")
    
    let customText: String
    
    var title: Text {
        Text(customText)
    }
    var message: Text?
    
    
    // Show only once
    var rules: [Rule] {
        
        #Rule(Self.setUploadEvent) {
            $0.donations.count == 1
        }
        
    }
}

struct MoveTip: Tip {
    
    static let setMoveEvent = Event(id: "moveEvent")
    
    let customText: String
    
    var title: Text {
        Text(customText)
    }
    var message: Text?
    
    
    // Show only once
    var rules: [Rule] {
        
        #Rule(Self.setMoveEvent) {
            $0.donations.count == 1
        }
        
    }
}

struct VideoTip: Tip {
    
    static let setVideoEvent = Event(id: "moveEvent")
    
    let customText: String
    
    var title: Text {
        Text(customText)
    }
    var message: Text?
    
    
    // Show only once
    var rules: [Rule] {
        
        #Rule(Self.setVideoEvent) {
            $0.donations.count == 1
        }
        
    }
    
}
