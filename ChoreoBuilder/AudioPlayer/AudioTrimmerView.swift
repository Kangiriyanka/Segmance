import SwiftUI
import AVFoundation

struct AudioTrimmerView: View {
    
    @State private var isImporting = false
    @State private var audioTrimmerManager = AudioTrimmerModel()
    @State private var startHandle: CGFloat = 0
    @State private var endHandle: CGFloat = 1
    @State private var clipStatus: ClipStatus = .idle
    @State private var isLoadingAudio = false
    @Namespace private var uploadSpace
    
    let seekTimes: [CGFloat] = [1,5,10,30,60]
    enum ClipStatus {
        case idle, clipping, duplicate
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    if audioTrimmerManager.audioURL == nil {
                      
                        emptyStateButton
                            .matchedGeometryEffect(id: "audioImport", in: uploadSpace)
                       
                    }
                    
                  
                    
                    if audioTrimmerManager.audioURL != nil {
                        Divider()
                        audioControls
                        clipsSection
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                audioTrimmerManager.cleanup()
                audioTrimmerManager.setupAudio(url: audioURL)
            }
        }
    }
    
  
    
    @ViewBuilder
    private var audioControls: some View {
        if let url = audioTrimmerManager.audioURL {
            VStack(spacing: 20) {
                Text(url.lastPathComponent)
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .frame(maxWidth: .infinity)
                
                if isLoadingAudio {
                    ProgressView("Drawing waveform...")
                        .frame(height: 60)
                } else {
                    AudioWaveformView(
                        startHandle: $startHandle,
                        endHandle: $endHandle,
                        trimmer: audioTrimmerManager
                    )
                }
                
                ScrollView {
                    LazyHStack {
                        Menu {
                            ForEach(seekTimes, id: \.self) { seconds in
                                Button("+ \(Int(seconds))s") {
                                    audioTrimmerManager.seekInterval(seconds)
                                }
                                Button("- \(Int(seconds))s") {
                                    audioTrimmerManager.seekInterval(seconds)
                                }
                            }
                        } label: {
                            Image(systemName: "gobackward")
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
                        
                        Button(action: resetEverything) {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .semibold))
                        }
                    }
                }
                .buttonStyle(PressableButtonStyle())
                .padding(.vertical)
            }
        }
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
            
            if audioTrimmerManager.clippedURLs.isEmpty {
                Text("No clips yet")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
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
    

    private var statusView: some View {
        Group {
            switch clipStatus {
            case .clipping:
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Clipping...")
                }
                .foregroundColor(.accentColor)
                .font(.caption)
            case .duplicate:
                Text("Already clipped")
                    .foregroundColor(.orange)
                    .font(.caption)
            case .idle:
                Text("")
            }
        }
        .frame(height: 20)
    }
    
    private var shareButton: some View {
        ShareLink(items: audioTrimmerManager.clippedURLs) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 16, weight: .semibold))
        }
        .buttonStyle(PressableButtonStyle())
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
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.routineCard)
            )
        }
    }
    
    private func clipAudio() {
        Task {
            withAnimation(.easeInOut) {
                clipStatus = .clipping
            }
            
            do {
                try await audioTrimmerManager.clipSelection(
                    startFraction: startHandle,
                    endFraction: endHandle
                )
                withAnimation(.easeInOut) {
                    clipStatus = .idle
                }
            } catch {
                withAnimation(.easeInOut) {
                    clipStatus = .duplicate
                }
                try? await Task.sleep(for: .seconds(2))
                withAnimation(.easeInOut) {
                    clipStatus = .idle
                }
            }
        }
    }
    
    private func resetEverything() {
        withAnimation(.easeInOut) {
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
    AudioTrimmerView()
}
