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
                if part.moves.isEmpty && part.order == 1 {
                    ContentUnavailableView {
                        Label("Controls", systemImage: "arcade.stick")
                    } description: {
                        
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("1. Add moves with \(Image(systemName: "plus.circle")).")
                            Text("2. Toggle Audio Player with \(Image(systemName: "music.quarternote.3")).")
                            Text("3. Link videos with the \(Image(systemName: "film")).")
                            Text("4. Hold order number to delete move.")
                            Text("5. Reorder moves with drag and drop.")
                        }
                        .padding()
                        .multilineTextAlignment(.leading)
                            
                    }
                   
                    .background(shadowOutline)
                    .padding()
                } else {
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
                guard let id = part.videoAssetID, !isLoadingVideo else { return }
                isLoadingVideo = true
                fetchVideoURL(from: id) { url in
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
            // Video picker
            PhotosPicker(
                selection: Binding(
                    get: { nil },
                    set: { item in
                        Task {
                            if let id = item?.itemIdentifier {
                                part.videoAssetID = id
                            }
                        }
                    }
                ),
                matching: .videos,
                photoLibrary: .shared()
            ) {
                Image(systemName: "film")
            }
            .buttonStyle(PressableButtonStyle())
            .contentShape(Rectangle())
            
        }
    }
    
    private func fetchVideoURL(from id: String, completion: @escaping (URL?) -> Void) {
        let fetchOptions = PHVideoRequestOptions()
        fetchOptions.version = .current
        fetchOptions.deliveryMode = .fastFormat
        
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        guard let asset = assets.firstObject else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }

        PHImageManager.default().requestAVAsset(forVideo: asset, options: fetchOptions) { avAsset, _, _ in
            DispatchQueue.main.async {
                let url = (avAsset as? AVURLAsset)?.url
                completion(url)
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
