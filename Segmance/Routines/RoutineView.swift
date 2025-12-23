//
//  RoutineView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/12.
//

import Foundation
import SwiftUI
import SwiftData
import PhotosUI


struct RoutineView: View {
    var routine: Routine
    
    // Toolbar hiding needs to be visible to the outermost layer
    // If you add it to a specific part, the other parts won't know to hide.
    // That's why it was moved to the RoutineView.
    
    @State private var playerIsPresented: Bool = false
    @State private var playerIsExpanded: Bool = false
    @State private var videoIsExpanded: Bool = false
    @State private var currentAudioURL: URL?
    @State private var currentPartTitle: String = ""
    @State private var videoManager = VideoPlayerModel()
    
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Routine.title) var routines: [Routine]
    
    
    var body: some View {
        ZStack {
            
            backgroundGradient.ignoresSafeArea(.all)
            
            
            
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(routine.parts.sorted(by: { $0.order < $1.order })) { part in
                            PartView(
                                part: part,
                                manager: videoManager,
                                onPlayVideo: onPlayVideo,
                                onPlayAudio: onPlayAudio,
                                onUnlinkVideo: onUnlinkVideo,
                                onVideoPicked: onVideoPicked
                            )
                            
                      
                           
                            .frame(width: UIScreen.main.bounds.width)
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.never)
                
            }
            .toolbar(playerIsExpanded || videoManager.isFullScreen ? .hidden : .visible, for: .tabBar)
            .ignoresSafeArea(.container, edges: playerIsExpanded ? .bottom : [])
            .alert("No Access", isPresented: $videoManager.showingAccessAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                
                Button("Cancel", role: .cancel) {
                    videoManager.showingAccessAlert = false
                    videoManager.selectedVideoItem = nil
                    
                }
            } message: {
                Text("This video isn’t accessible with your current Photos permissions. You can allow access in Settings.")
            }
            
     
            // Design Choice: Audio Player across all parts
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
                .zIndex(playerIsExpanded ? 100: 10)
            }
            
            // Design Choice: Video Player Across all parts
            if videoManager.showingVideoPlayer {
               
               
                
                    DraggableVideoPlayer(videoManager: videoManager)
                    .ignoresSafeArea(edges: videoManager.isFullScreen ? .all : [])
                    
                    .zIndex(videoManager.isFullScreen ? 100: 10)
  
            }
            
            
            
        }
      
        // If this routine no longer exists, dismiss this view
        .onChange(of: routines) { _,_ in
                   
                    if !routines.contains(where: { $0.id == routine.id }) {
                        dismiss()
                    }
                }
     
    // Padding to align action buttons  of RoutineContainerView  and RoutineView
//        .padding(.top, -10)
      
        
        
        
        
      
     
        
        
    }

    // Edge case: if a user deletes a video and a user tries to access it.
    private func onPlayVideo(_ videoID: String) {
        videoManager.fetchVideo(for: videoID) {
        
            if let part = routine.parts.first(where: { $0.videoAssetID == videoID }) {
                part.videoAssetID = nil
            }
        }
    }

    private func onPlayAudio(_ url: URL, _ title: String) {
        withAnimation(.organicFastBounce) {
            if currentAudioURL == url && playerIsPresented {
                playerIsPresented = false
            } else {
                currentAudioURL = url
                currentPartTitle = title
                playerIsPresented = true
            }
        }
    }

    private func onUnlinkVideo(_ videoID: String?) {
        // Reset video player state
        videoManager.videoURL = nil
        videoManager.selectedVideoItem = nil
        videoManager.isLoadingVideo = false
        videoManager.showingVideoPlayer = false

        // Remove video from the specific part
        guard let id = videoID else { return }
        routine.parts.first { $0.videoAssetID == id }?.videoAssetID = nil
    }

    // Part view's PhotoPicker
    private func onVideoPicked(_ item: PhotosPickerItem, _ part: Part) {
        videoManager.validateAndAssignVideo(
            for: item,
            assignID: { part.videoAssetID = $0 },
           
        )
    }
}
       


#Preview {
    let routine = Routine.secondExample
    RoutineView(routine: routine)
}
