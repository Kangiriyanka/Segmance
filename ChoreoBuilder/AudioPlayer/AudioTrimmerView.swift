import SwiftUI
import AVFoundation

struct AudioTrimmerView: View {
    
    @State private var isImporting = false
    @State private var audioTrimmerManager = AudioTrimmerModel()
    @State private var startHandle: CGFloat = 0
    @State private var endHandle: CGFloat = 1
    @State private var clipStatus: ClipStatus = .idle
    @Namespace private var buttonAnimation
    
    enum ClipStatus {
        case idle, clipping, duplicate
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    if audioTrimmerManager.audioURL == nil {
                        // Large centered upload button
                        Button(action: { isImporting = true }) {
                            Image(systemName: "square.and.arrow.down")
                                .font(.system(size: 40, weight: .semibold))
                                .frame(width: 75, height: 75)
                        }
                        .buttonStyle(PressableButtonStyle())
                        .matchedGeometryEffect(id: "uploadButton", in: buttonAnimation)
                    } else {
                        audioControls
                        clipsSection
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(backgroundGradient)
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
            audioTrimmerManager.setupAudio(url: audioURL)
        }
    }
    
    @ViewBuilder
    private var audioControls: some View {
        if let url = audioTrimmerManager.audioURL {
            VStack {
                Text("Clipping: \(url.lastPathComponent)")
                    .foregroundColor(.gray)
                    .font(.caption)
                
                AudioWaveformView(
                    startHandle: $startHandle,
                    endHandle: $endHandle,
                    trimmer: audioTrimmerManager
                )
                
                HStack(spacing: 20) {
                    // Small upload button (same ID as large one)
                    Button(action: { isImporting = true }) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(PressableButtonStyle())
                    .matchedGeometryEffect(id: "uploadButton", in: buttonAnimation)
                    
                    Button(action: audioTrimmerManager.togglePlayPause) {
                        Image(systemName: audioTrimmerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(PressableButtonStyle())
                    
                    Button(action: clipAudio) {
                        Image(systemName: "scissors")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(PressableButtonStyle())
                    
                    Button(action: resetEverything) {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(PressableButtonStyle())
                }
                .padding()
            }
        }
    }
    
    private var clipsSection: some View {
        
        VStack {
            HStack {
                Spacer()
                statusView.frame(height: 20)
                Spacer()
                if !audioTrimmerManager.clippedURLs.isEmpty {
                    shareButton
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            clipsList
        }
    }
    
    @ViewBuilder
    private var statusView: some View {
        switch clipStatus {
        case .clipping:
            Text("Clipping now")
                .foregroundColor(.accentColor)
                .scaleEffect(1.1)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: clipStatus == .clipping)
        case .duplicate:
            Text("Already clipped")
                .foregroundColor(.accentColor)
                .transition(.opacity.combined(with: .scale))
        case .idle:
            EmptyView()
        }
    }
    
    private var shareButton: some View {
        ShareLink(items: audioTrimmerManager.clippedURLs) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.mainText)
                .frame(maxHeight: 30)
                .padding()
                .background(Circle().fill(Color.routineCard))
        }
    }
    
    private var clipsList: some View {
        ForEach(audioTrimmerManager.clippedURLs, id: \.self) { clipURL in
            HStack {
                Text(clipURL.lastPathComponent)
                Spacer()
                Button {
                    audioTrimmerManager.removeURL(url: clipURL)
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.accent)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .bubbleStyle()
        }
    }
    
    private func clipAudio() {
        Task {
            clipStatus = .clipping
            defer { clipStatus = .idle }
            
            do {
                try await audioTrimmerManager.clipSelection(
                    startFraction: startHandle,
                    endFraction: endHandle
                )
            } catch {
                clipStatus = .duplicate
                try? await Task.sleep(for: .seconds(2))
            }
        }
    }
    
    private func resetEverything() {
        withAnimation {
            audioTrimmerManager = AudioTrimmerModel()
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
    AudioTrimmerView()
}
