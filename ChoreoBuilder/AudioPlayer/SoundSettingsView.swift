//
//  SoundSettingsView.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/12/04.
//

import SwiftUI


enum CountdownSound: String, CaseIterable {
    case snap = "snap"
    case gabagoo
    case furio
}


struct SoundSettingsView: View {
    @AppStorage("countdownSound") var countdownSound: String = "snap"
    // With an optional URL, you don't have to force unwrap URL("")
    @State private var audioPlayerManager: AudioPlayerModel = AudioPlayerModel()
    @State private var sound: CountdownSound = .snap
   
   
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Choose the countdown sound ").customHeader()
                Picker("Sound", selection: Binding(
                    get: { CountdownSound(rawValue: countdownSound) ?? .snap },
                    // Don't need onChange
                    set: { newValue in
                        countdownSound = newValue.rawValue
                        audioPlayerManager.playTick()
                    }
                )) {
                    ForEach(CountdownSound.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                            .tag($0)
                    }
                }
                
                
                .pickerStyle(.segmented)
            }
            .padding()
        }
        .background(backgroundGradient)
        
    }
    
   
}

#Preview {
    SoundSettingsView()
}
