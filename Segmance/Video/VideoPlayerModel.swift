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
    var videoURL: URL?
    

    func fetchVideoURL(fromLocalIdentifier id: String, completion: @escaping (URL?) -> Void) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        
        guard let asset = assets.firstObject else {
            completion(nil)
            return
        }
        
        let options = PHVideoRequestOptions()
        options.version = .original
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true // Allow iCloud downloads
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
            completion((avAsset as? AVURLAsset)?.url)
        }
    }
    
    func fetchVideo(for id: String) {
           guard !isLoadingVideo else { return }
           isLoadingVideo = true
           
           fetchVideoURL(fromLocalIdentifier: id) { [weak self] url in
               DispatchQueue.main.async {
                   guard let self = self else { return }
                   self.isLoadingVideo = false
                   if let url = url {
                       self.videoURL = url
                      
                       withAnimation(.organicFastBounce) {
                           self.showingVideoPlayer.toggle()
                       }
                   }
               }
           }
       }
    
    
    func validateAndAssignVideo(for item: PhotosPickerItem?, assignID: @escaping (String) -> Void, showAccessAlert: @escaping () -> Void) {
            guard let item = item, let id = item.itemIdentifier else {
                print("No access to selected video")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
                if assets.firstObject != nil {
                    assignID(id)
                    self.selectedVideoItem = item
                } else {
                    showAccessAlert()
                }
            }
        }
    

     
        
        
       
        
     
    
    func unlinkVideo() {
           selectedVideoItem = nil
           videoURL = nil
           showingVideoPlayer = false
           isLoadingVideo = false
       }
}
