//
//  RoutineView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/12.
//

import Foundation
import SwiftUI
import SwiftData


struct RoutineView: View {
    var routine: Routine
    
    // Toolbar hiding needs to be visible to the outermost layer
    // If you add it to a specific part, the other parts won't know to hide.
    // That's why it was moved to the RoutineView.
    
    @State private var playerIsPresented: Bool = false
    @State private var playerIsExpanded: Bool = false
    @State private var currentAudioURL: URL?
    @State private var currentPartTitle: String = ""
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Routine.title) var routines: [Routine]
    
    
    var body: some View {
        ZStack {
            
            backgroundGradient.ignoresSafeArea(.all)
            
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(routine.parts.sorted(by: { $0.order < $1.order })) { part in
                            PartView(part: part) { url, partTitle in
                                withAnimation(Animation.organicFastBounce) {
                                  
                                    if currentAudioURL == url && playerIsPresented {
                                        playerIsPresented = false
                                    } else {
                                        
                                        currentAudioURL = url
                                        currentPartTitle = partTitle
                                        playerIsPresented = true
                                    }
                                }
                            }
                            // Dismiss the view if the user changes the part name/
                            // The name of the audio file changes so if the user toggles it off and on, an error occurs.
                            .onChange(of: part) {
                                dismiss()
                            }
                            .frame(width: UIScreen.main.bounds.width)
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.never)
            }
            .toolbar(playerIsExpanded ? .hidden : .visible, for: .tabBar)
            .ignoresSafeArea(.container, edges: playerIsExpanded ? .bottom : [])
            
     
            if playerIsPresented, let url = currentAudioURL {
                AudioPlayerView(
                    audioFileURL: url,
                    partTitle: currentPartTitle,
                    isExpanded: $playerIsExpanded
                )
                .id(url)
                .offset(y: playerIsPresented ? 0 : 400)
                .opacity(playerIsPresented ? 1 : 0)
                .transition(.blurReplace)
                .zIndex(10)
            }
            
            
        }
        .onChange(of: routines) { _,_ in
                    // If this routine no longer exists, dismiss this view
                    if !routines.contains(where: { $0.id == routine.id }) {
                        dismiss()
                    }
                }
     
      
        .padding(.top, -10)
        
      
     
        
        
    }
}
       


#Preview {
    let routine = Routine.secondExample
    RoutineView(routine: routine)
}
