//
//  SoundSettingsView.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/12/04.
//

import SwiftUI
import AVKit

enum CountdownSound: String, CaseIterable {
    case clave = "clave"
    case piano
    case bongo
    case kick
    case wood
    case tambourine
    case hihat
    case snap
 
}


struct GeoCard: View {
    let name: String
    let font: Font
    let isTapped: Bool
    let width: CGFloat
    let height: CGFloat
    
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            Text(name)
                .font(font)
                .foregroundStyle(.mainText)
        }
        .frame(width: width, height: height)
        .padding()
        
        .background(shadowOutline)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.routineCard.opacity(0.2)))
        
        .overlay {
            if isTapped {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accent.opacity(0.8), lineWidth: 3)
                    .matchedGeometryEffect(id: "border", in: namespace)
            }
        }
    }
}

    // Here, you don't need to use the AudioManagerModel, just create an instance
struct SoundSettingsView: View {
        @AppStorage("countdownSound") var countdownSound: String = "clave"
        @State private var previewPlayer: AVAudioPlayer?
        @State private var selectedSound: String?
        @Namespace var ns
        
        
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    
                    HStack(spacing: 7){
                        usageTitle(title: "Select the countdown sound")
                        Image(systemName: "timer")
                    }
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20)
                    {
                        ForEach(CountdownSound.allCases, id: \.self) { sound in
                            Button {
                                withAnimation(Animation.smoothReorder) {
                                    countdownSound = sound.rawValue
                                    playPreview(sound: sound.rawValue)
                                    selectedSound = sound.rawValue
                                }
                            } label: {
                                
                                
                                GeoCard(name: sound.rawValue.capitalized, font: .title3, isTapped: selectedSound == sound.rawValue, width: 140, height: 50, namespace: ns)
                            }
                        }
                    }
                   
                    .padding()
                    .onAppear {
                        selectedSound = countdownSound
                    }
                    
                    HStack {
                        VStack {
                            Text("Note: The countdown for rehearsing can be set in the expanded audio player of a routine (which appears when you tap the mini audio player).")
                                .padding()
                            
                         
                               
                        }
                        
                    }
                    .font(.caption)
                    .foregroundStyle(Color(.secondaryLabel))
                        
                }
                .background(backgroundGradient)
                
                
            }
            
            
            
            
            
            
        }
        
        func playPreview(sound: String) {
            guard let url = Bundle.main.url(forResource: sound, withExtension: "wav") else { return }
            previewPlayer = try? AVAudioPlayer(contentsOf: url)
            previewPlayer?.play()
        }
    }
    
    
    #Preview {
        SoundSettingsView()
    }

