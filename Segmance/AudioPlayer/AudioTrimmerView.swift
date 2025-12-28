import SwiftUI
import AVFoundation

// Edge cases

/// 1. If a user reuploads a file, you must reset the handles back to the original positions and change isPlaying to false.

struct AudioTrimmerView: View {
    
    @State private var isImporting = false
    @State private var audioTrimmerManager = AudioTrimmerModel()
    @State private var startHandle: Double = 0
    @State private var endHandle: Double = 1
    @State private var clipStatus: ClipStatus = .idle
    @State private var isLoadingAudio = false
    @State private var clipTask: Task<Void, Never>?
    @Namespace private var uploadSpace
    

    enum ClipStatus {
        case idle, clipping, duplicate
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
               
             
                    if audioTrimmerManager.audioURL == nil {
                        ScrollView {
                            VStack {
                           
                                VStack {
                                    
                                    ContentUnavailableView {
                                        Label("No track uploaded", systemImage: "waveform")
                                    } description: {
                                        Text("Upload a track to split it into practice segments.").padding([.top], 5)
                                        emptyStateButton
                                    }
                                    
                                
                                    
                                }
                                .frame(minHeight: UIScreen.main.bounds.height * 0.7)
                             
                            }
                         
                        }
                      
                    }
                           
                          
                       
                    
                    
                    else {
                       
                        audioControls
                        AudioWaveformView(
                            startTime: $startHandle,
                            endTime: $endHandle,
                            trimmer: audioTrimmerManager)
                        .offset(y: 10)
                        
                       
                        
                        Spacer()
                        clipsSection.offset(y: 20)
                    }
                
               
            }
            
            .contentMargins(.horizontal, 10, for: .scrollContent)
            .contentMargins(.bottom, 30, for: .scrollContent)
            .background(backgroundGradient.ignoresSafeArea())
            .navigationTitle("Clipper")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            guard case .success(let urls) = result,
                  let audioURL = urls.first else { return }
            
            guard audioURL.startAccessingSecurityScopedResource() else { return }
            
            
            withAnimation(.easeInOut) {
               
                
                audioTrimmerManager.setupAudio(url: audioURL)
                audioTrimmerManager.isPlaying = false
                startHandle = 0
                endHandle = audioTrimmerManager.duration?.rounded(.down) ?? 1
               
            }
        }
    }
    
  
    
    @ViewBuilder
    /// TempComment:  HStack of Audio Controls, shouldn't cause any issues.
    private var audioControls: some View {
        HStack {
            Button(action: audioTrimmerManager.togglePlayPause) {
                Image(systemName: audioTrimmerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                 
            }
            
            Button(action: clipAudio) {
                Image(systemName: "scissors")
       
            }
            
            Button(action: resetEverything) {
                Image(systemName: "trash")
                 
            }
        }
   
        .buttonStyle(PressableButtonStyle(isDisabled: clipStatus == .clipping))
    }
                  
             


      
    
    private var clipsSection: some View {
        
        VStack(spacing: 15) {
            
            HStack {
                usageTitle(title: "Clips")
                Spacer()
                statusView
                if !audioTrimmerManager.clippedURLs.isEmpty {
                    shareButton
                }
            }
            .frame(height: 10)
            .padding()
            
            if audioTrimmerManager.clippedURLs.isEmpty {
                
                ContentUnavailableView {
                    Label("Controls", systemImage: "arcade.stick")
                } description: {
                    
                    Text("How the clipper works")
                    VStack(alignment: .leading, spacing: 14) {
                        instructionRow(
                            text: "Drag the handles to select a time range",
                            systemImage: "arrow.left.and.right"
                        )
                        instructionRow(
                            text: "Use the time buttons for precision",
                            systemImage: "1.square"
                        )
            
                        instructionRow(
                            text: "Clip the selected time range",
                            systemImage: "scissors"
                        )

                        instructionRow(
                            text: "Reset everything",
                            systemImage: "trash"
                        )
                        
                        instructionRow(
                            text: "Save all clips when finished clipping",
                            systemImage: "square.and.arrow.down" 
                            
                        )
                    }
                }
                    
                    
                   
            
            
                  
            } else {
                clipsList
                  
            }
        }
        
       
       
        
        
    }
    
    private var emptyStateButton: some View {
        HStack {
            Spacer()
            Button(action: { isImporting = true }) {
                Text("Upload Track")
                   
                    .frame(width: 100, height: 20)
                
            }
            .offset(y: -20)
            
            .buttonStyle(ReviewButtonStyle())
            Spacer()
        }
        .padding()
    }
    
    // Enum to switch views.
    private var statusView: some View {
        Group {
            switch clipStatus {
            case .clipping:
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Clipping...")
                }
                .foregroundStyle(.secondary)
                .font(.caption)
            case .duplicate:
                Text("Already clipped")
                    
                    .foregroundStyle(.secondary)
                    .font(.caption)
            case .idle:
                Text("")
            }
        }
        .frame(height: 20)
    }
    
    private var shareButton: some View {
        ShareLink(items: audioTrimmerManager.clippedURLs) {
            Text("Save Clips")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.accent.opacity(0.8))
               
      
        }
        
        .buttonStyle(NavButtonStyle())
    }
    
    private var clipsList: some View {
        VStack {
            ForEach(audioTrimmerManager.clippedURLs, id: \.self) { clipURL in
                HStack {
                    Text(clipURL.lastPathComponent)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Spacer()
                    Button {
                       withAnimation(.smoothReorder) {
                            audioTrimmerManager.removeURL(url: clipURL)
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red.opacity(0.7))
                            
                    }
                    .buttonStyle(.plain)
                }
                
                .bubbleStyle()
            }
        }
        .padding()
        .background(shadowOutline)
     
    }
    

    private func clipAudio() {
        // Cancel any existing task
        clipTask?.cancel()
        
        clipTask = Task {
            clipStatus = .clipping
            
            do {
            
                try await audioTrimmerManager.clipSelection(
                    startTime: startHandle,
                    endTime: endHandle
                )
                
                // Success
                clipStatus = .idle
                
            } catch {
                // If task was cancelled, just reset
                if Task.isCancelled {
                    clipStatus = .idle
                    return
                }
                
                // Otherwise show duplicate error
                clipStatus = .duplicate
                
                // Reset after 1 second
                try? await Task.sleep(for: .seconds(1))
                clipStatus = .idle
            }
        }
    }
    
    private func resetEverything() {
        withAnimation(.easeInOut) {
            clipTask?.cancel()
            clipTask = nil
            audioTrimmerManager.cleanup()
            startHandle = 0
            endHandle = 1
            clipStatus = .idle
        }
    }
}

func formatTime(_ seconds: CGFloat) -> String {
    String(format: "%02d:%02d", Int(seconds) / 60, Int(seconds) % 60)
}

#Preview {
    @Previewable var isImporting: Bool = true
    let URL = Bundle.main.url(forResource: "clave", withExtension: "wav")!
    let manager: AudioTrimmerModel = AudioTrimmerModel()
    AudioTrimmerView()
        .onAppear {
            manager.audioURL = URL
            
            manager.setupAudio(url: URL)
        }
    
}

