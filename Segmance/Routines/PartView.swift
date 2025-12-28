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

/// Don't create @State of part, it creates a local copy of it
/// Use Bindable. When you're in EditRoutineView, you want to reflect the changes automatically.
/// Suggestions #1:  onDrag feels a bit slow?
/// Suggestion #2: A PhotoPicker of only allowed items


extension View {
    
    @ViewBuilder
    func instructionRow(
        text: String,
        systemImage: String? = nil,
        customLabel: Text? = nil
    ) -> some View {
        HStack(spacing: 10) {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
            } else if let customLabel {
                customLabel
                    .frame(width: 20)
            }

            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct VideoPickerButton: View {
    @Binding var selectedVideoItem: PhotosPickerItem?
    var onVideoPicked: (PhotosPickerItem) -> Void

    var body: some View {
        PhotosPicker(
            selection: $selectedVideoItem,
            matching: .videos,
            photoLibrary: .shared()
        ) {
            Image(systemName: "film")
        }
        .onChange(of: selectedVideoItem) { _, item in
            guard let item else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut) {
                    onVideoPicked(item)
                    selectedVideoItem = nil
                }
            }
        }
//        Another way
//        .onChange(of: selectedVideoItem) { _, item in
//        guard let item else { return }
//        Task {
//            try? await Task.sleep(for: .milliseconds(300))
//            withAnimation {
//                onVideoPicked(item)
//                selectedVideoItem = nil
//            }
//        }
    
    }
}
struct PartView: View {
    
    
    @Bindable var part: Part
    
    var moves: [Move] { part.moves.sorted { $0.order < $1.order }}
    @State private var showingAddMoveSheet = false
    @State private var draggedMove: Move?
    @State private var gridMode: GridMode = .list
    @State private var videoManager: VideoPlayerModel
    @FocusState private var focusedMoveID: UUID?
    @State private var selectedVideoItem: PhotosPickerItem?
    
    
    // Callbacks for video
    var onPlayVideo: (String) -> Void
    var onPlayAudio: (URL, String) -> Void
    var onUnlinkVideo: (String?) -> Void
    var onVideoPicked: (PhotosPickerItem, Part) -> Void
    
    
    let tip = VideoTip(customText: "Hold the play button to unlink the video.")
    
    
    
    init(
           part: Part,
           manager: VideoPlayerModel,
           onPlayVideo: @escaping (String) -> Void,
           onPlayAudio: @escaping (URL, String) -> Void,
           onUnlinkVideo: @escaping (String?) -> Void,
           onVideoPicked: @escaping (PhotosPickerItem, Part) -> Void
       ) {
           self.part = part
           self.videoManager = manager
           self.onPlayVideo = onPlayVideo
           self.onPlayAudio = onPlayAudio
           self.onUnlinkVideo = onUnlinkVideo
           self.onVideoPicked = onVideoPicked
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
        
        
        
        
        
    }
    
    private var headerView: some View {
        
        VStack {
            
           
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
                                
                                Text("How buttons work and helpful tips") 
                                VStack(alignment: .leading, spacing: 14) {

                                    instructionRow(
                                        text: "Toggle the audio player",
                                        systemImage: "music.quarternote.3"
                                    )

                                    instructionRow(
                                        text: "Link a video from Photos. Unlink by holding it.",
                                        systemImage: "film"
                                    )

                                    instructionRow(
                                        text: "Switch to a read-only overview mode",
                                        systemImage: "rectangle.grid.1x2"
                                    )

                                    instructionRow(
                                        text: "Add new moves to a part",
                                        systemImage: "plus.circle"
                                    )

                                    Divider()
                                    
                                    instructionRow(
                                        text: "Delete a move by holding its order number",
                                        systemImage: "1.circle"
                                            
                                    )
                                    instructionRow(
                                        text: "Reorder moves by holding and dragging them",
                                        systemImage: "rectangle"
                                            
                                    )
                                    
                                    instructionRow(
                                        text: "Tap the part title to navigate between parts",
                                        systemImage: "textformat.characters"
                                            
                                    )
                                    instructionRow(
                                        text: "Tap the Routines tab to go back to your routines",
                                        systemImage: "figure.dance"
                                            
                                    )

                                   
                                    
                                    Divider()
                                    
                                    Button {
                                        showingAddMoveSheet = true
                                    } label: {
                                        Text("Add First Move")
                                    }
                                    .padding()
                                    .buttonStyle(ReviewButtonStyle())
                                       
                                }
                            }
                            
                            
                        } else {
                            ContentUnavailableView {
                                Label("No moves", systemImage: "figure.dance")
                            } description: {
                                
                                
                                VStack(alignment: .leading, spacing: 14) {
                                    Button {
                                        showingAddMoveSheet = true
                                    } label: {
                                        Text("Add First Move")
                                    }
                                    .padding()
                                    .buttonStyle(ReviewButtonStyle())
                                }
                            }
                            
                            
                        }
                    }
                
                }
                
                
                
                
                else {
                    
                    gridView(for: gridMode)
                    
                }
            }
            .contentMargins(.bottom, 50, for: .scrollContent)
           
            
            .onTapGesture {
                focusedMoveID = nil
                
            }
            .scrollDismissesKeyboard(.immediately)
            
        }
       
    }
    
    private var actionButtons: some View {
        HStack {
            
            
            
            
            // Play video button if video exists
            
            
            // Audio and add buttons
            HStack(spacing: 10) {
                
                
                
                Button {
                    
                    if let url = part.location {
                        onPlayAudio(url, part.title)
                    }
                    
                } label: {
                    Image(systemName: "music.quarternote.3")
                }
                
                filmButton
                
                Button {
                    
                    
                    gridMode.cycle()
                    
                    
                    
                } label: {
                    Image(systemName: gridMode.icon)
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
    
    
   
    
    
    private var viewModeButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                gridMode.cycle()
            }
            
            
            
            
            
        } label: {
            Image(systemName: gridMode.icon)
                .frame(width: 10)
        }
        .buttonStyle(PressableButtonStyle())
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private func gridView(for mode: GridMode) -> some View {
        if !(mode == .list) {
            HStack {
                Text("Overview mode: Switch to \(Image(systemName:"rectangle.grid.1x2")) to edit moves.").font(.caption2).foregroundStyle(.secondary)
                
            }
        }
        LazyVGrid(columns: mode.columns, spacing: 30) {
            ForEach(moves) { move in
                
                if mode == .list {
                    moveViewContainer(move: move)
                    
                } else {
                    CompactMoveView(move: move, gridMode: mode.rawValue)
                }
            }
            
        }
        .padding()
    }
    
    
    
    
    private func moveViewContainer(move: Move) -> some View {
        
        MoveView(deleteFunction: deleteMove, move: move)
        
            .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 16))
            .transition(.asymmetric(
                insertion: .opacity,
                removal: .opacity
            ))
            .onDrag {
                draggedMove = move
                return NSItemProvider()
                // Preview is a huge help for the jittering
            } preview: {
                MoveView(deleteFunction: deleteMove, move: move)
                
                
                    .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 16))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
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
        
        
    }
    
    
    
    
    private func deleteMove(id: UUID) {
        guard let moveToDelete = part.moves.first(where: { $0.id == id }) else { return }
        
        withAnimation(.smoothReorder) {
            part.moves.removeAll { $0.id == id }
            
            
            part.moves.forEach { move in
                if move.order > moveToDelete.order {
                    move.order -= 1
                }
            }
        }
    }
    
 
    @ViewBuilder
    private var filmButton: some View {
        if let videoID = part.videoAssetID {
            Button {
                onPlayVideo(videoID)
            } label: {
                Image(systemName: "play.circle")
                    .popoverTip(tip)
            }
            .onAppear {
                Task {
                    await VideoTip.setVideoEvent.donate()
                }
            }
            .contentShape(.contextMenuPreview, Circle())
            .contextMenu {
                Button(role: .destructive) {
                   
                        onUnlinkVideo(part.videoAssetID)
                    
                } label: {
                    Label("Unlink Video", systemImage: "trash")
                }
            }
            .buttonStyle(PressableButtonStyle())
            .contentShape(Rectangle())
            
        } else {
          
           
                VideoPickerButton(selectedVideoItem: $selectedVideoItem) { item in
                    onVideoPicked(item, part)
                }
            
           
        }
    }
    

    
}

#Preview {
  
    let part = Part.firstPartExample
    PartView(
        part: part,
        manager: VideoPlayerModel(),
        onPlayVideo: { videoID in
            print("Play video: \(videoID)")
        },
        onPlayAudio: { url, title in
            print("Play audio: \(title) at \(url)")
        },
        onUnlinkVideo: { videoID in
            print("Unlink video: \(videoID ?? "nil")")
        },
        onVideoPicked: { item, part in
            print("Picked video for part \(part.title)")
        }
    )
}

