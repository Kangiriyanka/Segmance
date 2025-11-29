//
//  BluesMakerApp.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/30.
//

import SwiftUI
import SwiftData

@main
struct ChoreoBuilder: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                
        }
        .modelContainer(for: Routine.self)
    }
}
