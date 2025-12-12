//
//  BluesMakerApp.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/30.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct Scenota: App {
    
  
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { try? Tips.configure([
                    .datastoreLocation(.applicationDefault)
                ])}
                
        }
      
        .modelContainer(for: Routine.self)
    }
}
