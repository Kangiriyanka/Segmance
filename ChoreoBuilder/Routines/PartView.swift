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
    
    @State  var part: Part
    var moves: [Move] { part.moves.sorted { $0.order < $1.order }}
    @State private var audioPlayerPresented = false
    @State private var showingAddMoveSheet = false
    @State private var draggedMove: Move?
    @FocusState private var focusedMoveID: UUID?
    @Namespace private var animation
    @State private var videoURL: URL?
    @State private var showingVideoPlayer = false
    @State private var isLoadingVideo = false
    @Binding private var playerExpanded: Bool
    
    init(part: Part, playerExpanded: Binding<Bool>) {
        self._part = State(initialValue: part)
        self._playerExpanded = playerExpanded
    }

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea(.all)
            
            VStack {
                headerView
                movesScrollView
            }
            
            if audioPlayerPresented, let partURL = part.location {
                AudioPlayerView(audioFileURL: partURL, partTitle: part.title, isExpanded: $playerExpanded)
                   
                    .offset(y: audioPlayerPresented ? 0 : 400)
                    .opacity(audioPlayerPresented ? 1 : 0)
                    .transition(.blurReplace)
                    .zIndex(10)
            }
        }
       

        .sheet(isPresented: $showingAddMoveSheet) {
            ZStack {
                backgroundGradient.ignoresSafeArea()
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
                    ContentUnavailableView {
                        Label("No moves added", systemImage: "figure.dance")
                    } description: {
                        Text("Add moves by tapping the \(Image(systemName: "plus.circle")) button.")
                            .padding(.top, 5)
                    }
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
                                .contentShape(Circle())
                                .contextMenu {
                                    Button(role: .destructive) {
                                        deleteMove(id: move.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
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
                       
                            
                           
                    
                }
                .contextMenu {
                    Button(role: .destructive) {
                        part.videoAssetID = nil
                    } label: {
                        Label("Remove Video", systemImage: "trash")
                    }
                }
                .buttonStyle(PressableButtonStyle())
                .contentShape(Rectangle())
                .disabled(isLoadingVideo)
            }
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

            // Play video button if video exists
           

            // Audio and add buttons
            HStack(spacing: 5) {
                Button {
                    withAnimation(Animation.organicFastBounce) {
                        audioPlayerPresented.toggle()
                    }
                } label: {
                    Image(systemName: "music.quarternote.3")
                }

                Button {
                    withAnimation {
                        showingAddMoveSheet.toggle()
                    }
                } label: {
                    Image(systemName: "plus.circle")
                }
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
       
        PartView(part: part, playerExpanded: .constant(true))
    }
}
