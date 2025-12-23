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

@Observable
class VideoPlayerModel {
    var selectedVideoItem: PhotosPickerItem?
    var isFullScreen = false
    var isLoadingVideo = false
    var showingVideoPlayer = false
    var showingAccessAlert = false
    var videoURL: URL?
    
    func fetchVideo(for id: String, onDeleted: @escaping () -> Void) {
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
    
    func validateAndAssignVideo(for item: PhotosPickerItem?, assignID: @escaping (String) -> Void) {
        guard let item = item, let id = item.itemIdentifier else { return }
        
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        if assets.firstObject != nil {
            assignID(id)
            selectedVideoItem = item
        } else {
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
