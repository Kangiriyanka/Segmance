//
//  VideoPlayerModel.swift
//  Segmance
//
//  Created by Kangiriyanka The Single Leaf on 2025/12/23.
//

import Foundation
import SwiftUI
import PhotosUI
import Photos
import AVKit

// Problems:

// One problem that arises is when you link a video for the first time there's the prompt: Full - Limited - No access
// The alert shows initially even if you allow full access

@Observable
class VideoPlayerModel {
    var selectedVideoItem: PhotosPickerItem?
    var isFullScreen = false
    var isLoadingVideo = false
    var showingVideoPlayer = false
    var showingAccessAlert = false
    var videoURL: URL?
    
    func fetchVideo(for id: String, onDeleted: @escaping () -> Void) {
        
        if showingVideoPlayer {
                withAnimation(.organicFastBounce) {
                    showingVideoPlayer = false
                }
                return
            }
        
        guard !isLoadingVideo else { return }
        isLoadingVideo = true
        
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        guard let asset = assets.firstObject else {
            handleVideoDeleted(onDeleted)
            return
        }
        
        let options = PHVideoRequestOptions()
        options.version = .original
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { [weak self] avAsset, _, _ in
            guard let self = self else { return }
            
            if let url = (avAsset as? AVURLAsset)?.url {
                self.videoURL = url
                self.isLoadingVideo = false
                withAnimation(.organicFastBounce) {
                    self.showingVideoPlayer = true
                }
            } else {
                self.handleVideoDeleted(onDeleted)
            }
        }
    }
    
    private func assetIsAccessible(_ id: String) -> Bool {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        return assets.firstObject != nil
    }

    // Edge case: User deletes a video from their library. Simply unlink with the play button
    private func handleVideoDeleted(_ onDeleted: @escaping () -> Void) {
        isLoadingVideo = false
        onDeleted()
    }
    
    func canAccessAsset(withID id: String) -> Bool {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        return fetchResult.firstObject != nil
    }

  
    // In Limited Mode, iOS can randomly ask the user to allow access.
    func validateAndAssignVideo(
        for item: PhotosPickerItem?,
        assignID: @escaping (String) -> Void
    ) {
        guard let item = item, let id = item.itemIdentifier else { return }

        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized:
            assignID(id)
            selectedVideoItem = item
            
        // Check for the limited user videos
        case .limited:
            if canAccessAsset(withID: id) {
                assignID(id)
                selectedVideoItem = item
            } else {
                
                self.showingAccessAlert = true
            }
            
        // This is the case
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                // DispatchQue.main.async (UI updates on the main thread)
                Task { @MainActor in
                    if newStatus == .authorized {
                        assignID(id)
                        self.selectedVideoItem = item
                    } else if newStatus == .limited {
                        if self.canAccessAsset(withID: id) {
                            assignID(id)
                            self.selectedVideoItem = item
                        } else {
                            self.showingAccessAlert = true
                        }
                    } else {
                        self.showingAccessAlert = true
                    }
                }
            }

        case .denied, .restricted:
            showingAccessAlert = true

        @unknown default:
            showingAccessAlert = true
        }
    }
    
    func unlinkVideo() {
        selectedVideoItem = nil
        videoURL = nil
        showingVideoPlayer = false
        isLoadingVideo = false
    }
    
    private func handleFetchFailure() {
        isLoadingVideo = false
        showingAccessAlert = true
    }
}
