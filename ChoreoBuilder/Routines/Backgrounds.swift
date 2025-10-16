//
//  Backgrounds.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/15.
//

import Foundation
import SwiftUI


var backgroundGradient: RadialGradient {
    RadialGradient(
        colors: [
            Color.customBlue.opacity(1),
            Color.customBlue.opacity(0.9),
           
        ],
        center: .topLeading,
        startRadius: 300,
        endRadius: 1000
    )
}
