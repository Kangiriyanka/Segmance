//
//  PartView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/18.
//

import SwiftUI
import PhotosUI
import Photos
import AVKit

struct PartView: View {
    
    @State var part: Part
    var moves: [Move] { part.moves.sorted { $0.order < $1.order }}
    @State private var showingAddMoveSheet = false
    @State private var draggedMove: Move?
    @FocusState private var focusedMoveID: UUID?
    @Namespace private var animation
    @State private var videoURL: URL?
    @State private var showingVideoPlayer = false
    @State private var isLoadingVideo = false
    @State private var selectedVideoItem: PhotosPickerItem?
    var onPlayAudio: (URL, String) -> Void
    let tip = VideoTip(customText: "Hold the play button to unlink the video.")
    
    
    
    init(part: Part, onPlayAudio: @escaping (URL,String) -> Void) {
        self._part = State(initialValue: part)
        self.onPlayAudio = onPlayAudio
        
    }

    var body: some View {
        ZStack {
           
            VStack {
                headerView
                movesScrollView
            }
            

        }
       

        .sheet(isPresented: $showingAddMoveSheet) {
            ZStack {
                noSinBackgroundGradient.ignoresSafeArea()
                AddMoveView(part: part).padding()
                 
            }
            
            .presentationDetents([.fraction(0.5)])
          
       
         
             
            
        }
        .sheet(isPresented: $showingVideoPlayer, onDismiss: { videoURL = nil }) {
            if let url = videoURL {
                VideoPlayer(player: AVPlayer(url: url))
                    .ignoresSafeArea()
                   
            }
            
            
        }
        
      
           
        
    }
    
    private var headerView: some View {
        
        VStack {
            
            Text("\(part.order). \(part.title)").customHeader().padding()
            actionButtons
        }
      
        .padding()
    }
    
    private var movesScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                if part.moves.isEmpty {
                    Group {
                        if part.order == 1 {
                            ContentUnavailableView {
                                Label("Controls", systemImage: "arcade.stick")
                            } description: {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("1. Add moves with \(Image(systemName: "plus.circle")).")
                                    Text("2. Toggle Audio Player with \(Image(systemName: "music.quarternote.3")).")
                                    Text("3. Link videos with \(Image(systemName: "film")).")
                                    Text("4. Hold order number to delete move.")
                                    Text("5. Reorder moves with drag and drop.")
                                }
                                .padding()
                                .multilineTextAlignment(.leading)
                            }
                            
                            
                        } else {
                            ContentUnavailableView {
                                Label("No moves", systemImage: "figure.dance")
                            } description: {
                               
                            }
                        
                            
                        }
                    }
                    .background(shadowOutline)
                    .padding()
                }
                    
                   
                  
                  
                else {
                    VStack(spacing: 50) {
                        ForEach(moves) { move in
                            MoveView(deleteFunction: deleteMove, move: move)
                                .onDrag {
                                    draggedMove = move
                                    return NSItemProvider()
                                }
                                .onDrop(
                                    of: [.text],
                                    delegate: MoveDropViewDelegate(
                                        destinationMove: move,
                                        originalArray: $part.moves,
                                        draggedMove: $draggedMove)
                                )
                                .id(move.id)
                                .focused($focusedMoveID, equals: move.id)
                                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 10))
                             
                               
                        }
                        .animation(.smoothReorder, value: moves)
                    }
                }
            }
            .contentMargins(.bottom, 50, for: .scrollContent)
            
            .onTapGesture {
                focusedMoveID = nil
            }
            .scrollDismissesKeyboard(.immediately)
            .onChange(of: focusedMoveID) { _, newValue in
                if let id = newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            proxy.scrollTo(id, anchor: .center)
                        }
                    }
                }
            }
        }
    }
    
    private var actionButtons: some View {
        HStack {
            
            
       

            // Play video button if video exists
           

            // Audio and add buttons
            HStack(spacing: 10) {
                
                Button {
                    withAnimation {
                        showingAddMoveSheet.toggle()
                    }
                } label: {
                    Image(systemName: "plus.circle")
                }
                
                Button {
                    
                        if let url = part.location {
                                onPlayAudio(url, part.title)
                        }
                    
                } label: {
                    Image(systemName: "music.quarternote.3")
                }
                
                filmButton

              
            }
            .buttonStyle(PressableButtonStyle())
            .contentShape(Rectangle())
            .foregroundStyle(.black)
            .frame(width: 100, height: 40)
            .padding(5)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func deleteMove(id: UUID) {
        guard let moveToDelete = part.moves.first(where: { $0.id == id }) else { return }
        
        part.moves.removeAll { $0.id == id }
        part.moves.forEach { move in
            if move.order > moveToDelete.order {
                move.order -= 1
            }
        }
    }
    
    @ViewBuilder
    private var filmButton: some View {
        
        if part.videoAssetID != nil {
            Button {
                // Lock any other video uploads with isLoadingVideo
                guard let id = part.videoAssetID, !isLoadingVideo else { return }
                isLoadingVideo = true
                fetchVideoURL(fromLocalIdentifier: id) { url in
                    isLoadingVideo = false
                    if let url = url {
                        videoURL = url
                        showingVideoPlayer = true
                    }
                }
            } label: {
              
                    Image(systemName: "play.circle")
                    .popoverTip(tip)
                      
                
            }
            .onAppear {
                Task {
                    await VideoTip.setVideoEvent.donate()
                }
            }
            .contextMenu {
                Button(role: .destructive) {
                    part.videoAssetID = nil
                } label: {
                    Label("Unlink Video", systemImage: "trash")
                }
            }
            .buttonStyle(PressableButtonStyle())
            .contentShape(Rectangle())
         
        }
        
        else {
            // itemIdentifier is an id referring to the video
            // set -> user selects a video which becomes the item
            
            
            PhotosPicker(
                        selection: $selectedVideoItem,
                        matching: .videos,
                        photoLibrary: .shared()
                    ) {
                        Image(systemName: "film")
                    }
                    .onChange(of: selectedVideoItem) { _, item in
                        if let id = item?.itemIdentifier {
                            part.videoAssetID = id
                        }
                        // Reset picker to allow reselecting the same video later
                        selectedVideoItem = nil
                    }
                    .buttonStyle(PressableButtonStyle())
                    .contentShape(Rectangle())
            
            
        }
    }
    
    private func fetchVideoURL(fromLocalIdentifier id: String, completion: @escaping (URL?) -> Void) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        // Finds the match
        guard let asset = assets.firstObject else {
            completion(nil)
            return
        }

        let options = PHVideoRequestOptions()
        options.version = .original
        options.deliveryMode = .highQualityFormat

        // Set the url from PHImageManager to the Part's state
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
            if let urlAsset = avAsset as? AVURLAsset {
                completion(urlAsset.url)
            } else {
                completion(nil)
            }
        }
    }
}

#Preview {
    let part = Part.firstPartExample
    TabView {
       
        PartView(part: part, onPlayAudio: { _, _ in })
    }
}

