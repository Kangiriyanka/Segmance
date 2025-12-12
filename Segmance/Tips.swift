//
//  Tips.swift
//  Scenota
//
//  Created by Kangiriyanka The Single Leaf on 2025/12/09.
//

import Foundation


import TipKit
import SwiftUI

struct ReusableTip: Tip {
    let event: Event
    let customText: String
    
    var title: Text { Text(customText) }
    var message: Text? = nil
    
    var rules: [Rule] {
        #Rule(event) { $0.donations.count == 0 }
    }
}
