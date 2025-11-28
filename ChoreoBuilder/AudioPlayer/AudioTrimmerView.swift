import SwiftUI
import AVFoundation



struct AudioTrimmerView: View {
    
    @State private var isImporting: Bool = false
    @State private var audioTrimmerManager: AudioTrimmerModel = AudioTrimmerModel()
    @State private var startHandle: CGFloat = 0
    @State private var endHandle: CGFloat = 1
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    Button("Upload your audio file") {
                        isImporting = true
                    }
                    .bubbleStyle()
                    
                    if let url = audioTrimmerManager.audioURL {
                        
                        Section {
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
                                                let clipURL = try  await audioTrimmerManager.clipSelection(startFraction: startHandle, endFraction: endHandle)
                                                print("Created clip at: \(clipURL)")
                                            } catch {
                                                print("Failed to clip selection: \(error)")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "scissors")
                                    }
                                }
                                .padding()
                                
                                Waveform(
                                    startHandle: $startHandle,
                                    endHandle: $endHandle,
                                    amplitudes: [0.2,0.5,0.3,0.7,0.4,0.6,0.2],
                                    trimmer: audioTrimmerManager
                                )
                            }
                            
                            VStack {
                                
                                HStack {
                                    Button() {
                                        // Save clips if needed
                                    } label: {
                                        
                                        Image(systemName: "square.and.arrow.up")
                                            .foregroundColor(.mainText)
                                            .frame(maxHeight: 30)
                                            .padding()
                                            .background(
                                                Circle()
                                                    .fill(Color.routineCard)
                                            )
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                VStack {
                                    ForEach(audioTrimmerManager.clippedURLs, id: \.self) { clipURL in
                                        HStack {
                                            Text(clipURL.lastPathComponent)
                                            Spacer()
                                            Button() { audioTrimmerManager.removeURL(url: clipURL
                                            )}
                                            
                                            label: {
                                                Image(systemName: "xmark")
                                                    .foregroundColor(.accent)
                                                    .font(.system(size: 14, weight: .semibold))
                                            }
                                        }.bubbleStyle()
                                        
                                    }
                                }
                                
                                
                            }
                        } header: {
                            Text("Clipped parts")
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(backgroundGradient)
           
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
                    print("Error: \(err.localizedDescription)")
                }
            }
            
            .navigationTitle("Trimmer")
            .navigationBarTitleDisplayMode(.inline)
           
        }
       
  
        
       
    }
    
    
   
    func formatTime(_ seconds: CGFloat) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

#Preview {
    AudioTrimmerView()
}

