import SwiftUI
import AVFoundation

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
                      
                        emptyStateButton
                            .matchedGeometryEffect(id: "audioImport", in: uploadSpace)
                          
                       
                    }
                    
                    else {
                       
                        audioControls
                        AudioWaveformView(
                            startTime: $startHandle,
                            endTime: $endHandle,
                            trimmer: audioTrimmerManager)
                        
                       
                        
                        Spacer()
                        clipsSection.offset(y: 20)
                    }
                
               
            }
            
            .contentMargins(.horizontal, 10, for: .scrollContent)
            .background(backgroundGradient.ignoresSafeArea())
            .navigationTitle("Trimmer")
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
                endHandle = audioTrimmerManager.duration?.rounded(.down) ?? 1
               
            }
        }
    }
    
  
    
    @ViewBuilder
    /// TempComment:  HStack of Audio Controls, shouldn't cause any issues.
    private var audioControls: some View {
    
            HStack {
                
                
                Button(action: resetEverything) {
                    Image(systemName: "trash")
                        .font(.system(size: 20, weight: .semibold))
                }
                
                Button(action: { isImporting = true }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 20, weight: .semibold))
                        .matchedGeometryEffect(id: "audioImport", in: uploadSpace)
                }
                
                Button(action: audioTrimmerManager.togglePlayPause) {
                    Image(systemName: audioTrimmerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                }
                
                
                Button(action: clipAudio) {
                    Image(systemName: "scissors")
                        .font(.system(size: 20, weight: .semibold))
                }
            
                
             
                
            }
            .padding()
            
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
                Text("No clips yet")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                  
            } else {
                clipsList
                  
            }
        }
        
       
       
        
        
    }
    
    private var emptyStateButton: some View {
        HStack {
            Spacer()
            Button(action: { isImporting = true }) {
                Image(systemName: "square.and.arrow.down")
                    .font(.system(size: 50, weight: .semibold))
                    .frame(width: 100, height: 100)
            }
            .buttonStyle(PressableButtonStyle())
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
                    
                    .foregroundStyle(.accent.opacity(0.7))
                    .font(.caption)
            case .idle:
                Text("")
            }
        }
        .frame(height: 20)
    }
    
    private var shareButton: some View {
        ShareLink(items: audioTrimmerManager.clippedURLs) {
            Text("Done")
                .font(.subheadline)
         
      
        }
        .buttonStyle(NavButtonStyle())
    }
    
    private var clipsList: some View {
        ForEach(audioTrimmerManager.clippedURLs, id: \.self) { clipURL in
            HStack {
                Text(clipURL.lastPathComponent)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Spacer()
                Button {
                    withAnimation(.easeInOut) {
                        audioTrimmerManager.removeURL(url: clipURL)
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red.opacity(0.7))
                        .font(.system(size: 20))
                }
                .buttonStyle(.plain)
            }
           
            .bubbleStyle()
        }
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
    let URL = Bundle.main.url(forResource: "clave", withExtension: "wav")!
    let manager: AudioTrimmerModel = AudioTrimmerModel()
    AudioTrimmerView()
        .onAppear {
          
            manager.setupAudio(url: URL)
        }
    
}
