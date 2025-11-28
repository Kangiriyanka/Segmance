import SwiftUI
import AVFoundation

    struct AudioTrimmerView: View {
        
        @State private var isImporting: Bool = false
        @State private var audioTrimmerManager: AudioTrimmerModel = AudioTrimmerModel()
        @State private var startHandle: CGFloat = 0
        @State private var endHandle: CGFloat = 1
        @State private var isExporting: Bool = false
        @State private var isClipping: Bool = false
        @State private var isSameClip: Bool = false
        
        private var clippingProgress: some View {
            Text("Clipping now")
                .foregroundColor(.accentColor)
                
                .scaleEffect(isClipping ? 1.1 : 1.0) // pulse
                .opacity(isClipping ? 1 : 0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isClipping)
        }

        private var sameClip: some View {
            Text("Already clipped")
                .foregroundColor(.accentColor)
                
                .scaleEffect(isSameClip ? 1.0 : 0)
                .opacity(isSameClip ? 1 : 0.0)
                .animation(.organicFastBounce, value: isSameClip)
                .transition(.opacity.combined(with: .scale))
        }
        
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 30) {
                        
                        Button("Upload your audio file") {
                            isImporting = true
                        }
                        .bubbleStyle()
                        
                        if let url = audioTrimmerManager.audioURL {
                            
                           
                                VStack {
                                    Text("Clipping: \(url.lastPathComponent)")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                    
                                    HStack {
                                        Button {
                                            audioTrimmerManager.togglePlayPause()
                                        } label: {
                                            Image(systemName: audioTrimmerManager.isPlaying
                                                  ? "pause.circle.fill"
                                                  : "play.circle.fill")
                                        }
                                        
                                        Button {
                                            Task {
                                                do {
                                                    isClipping = true
                                                    defer { isClipping = false }
                                                    
                                                    let _ = try await audioTrimmerManager.clipSelection(startFraction: startHandle, endFraction: endHandle)
  
                                                } catch {
                                                    
                                                    isSameClip = true
                                                
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                        withAnimation {
                                                            isSameClip = false
                                                        }
                                                                }
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "scissors")
                                        }
                                    }
                                    .padding()
                                    
                                    AudioWaveformView(
                                        startHandle: $startHandle,
                                        endHandle: $endHandle,
                                        trimmer: audioTrimmerManager,
                                      
                                    )
                                }
                                
                                VStack {
                                    HStack {
                                        
                                        Spacer()
                                        ZStack {
                                            if isClipping {
                                                clippingProgress
                                                
                                            }
                                            if isSameClip {
                                                
                                                sameClip
                                                
                                            }
                                        }
                                        .frame(height: 20)
                                        
                                        Spacer()
                                        
                                        
                                        
                                        if !audioTrimmerManager.clippedURLs.isEmpty {
                                            ShareLink(
                                                items: audioTrimmerManager.clippedURLs
                                            ) {
                                                Image(systemName: "square.and.arrow.up")
                                                    .foregroundColor(.mainText)
                                                    .frame(maxHeight: 30)
                                                    .padding()
                                                    .background(Circle().fill(Color.routineCard))
                                            }
                                        }
                                      
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    
                                    VStack {
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
                                }
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
                switch result {
                case .success(let urls):
                    if let audioURL = urls.first {
                        audioTrimmerManager.setupAudio(url: audioURL)
                    }
                case .failure(let err):
                    print("Error:", err.localizedDescription)
                }
            }
            
           
        }
    }
    

  

   
    func formatTime(_ seconds: CGFloat) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }


#Preview {
    AudioTrimmerView()
}

