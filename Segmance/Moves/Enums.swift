//
//  Enums.swift
//  Segmance
//
//  Created by Kangiriyanka The Single Leaf on 2025/12/21.
//

import Foundation
import SwiftUI

enum GridMode: String, CaseIterable {
       case list, grid2, grid3
       
       var columns: [GridItem] {
           switch self {
           case .list: return [GridItem(.flexible())]
           case .grid2: return [GridItem(.adaptive(minimum: 140), spacing: 15)]
           case .grid3: return [GridItem(.adaptive(minimum: 100), spacing: 15)]
           }
       }
       
       var icon: String {
           switch self {
           case .list: return "rectangle.grid.1x2"
           case .grid2: return "square.grid.2x2"
           case .grid3: return "square.grid.3x2"
           }
       }
       
       mutating func cycle() {
           let all = Self.allCases
           self = all[(all.firstIndex(of: self)! + 1) % all.count]
       }
   }
