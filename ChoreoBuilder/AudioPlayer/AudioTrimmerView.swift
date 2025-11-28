import SwiftUI
import AVFoundation


import SwiftUI
import AVFoundation

struct AudioTrimmerView: View {
    
    @State private var isImporting: Bool = false
    @State private var audioTrimmerManager: AudioTrimmerModel = AudioTrimmerModel()
    @State private var trimRanges: [(start: Double, end: Double)] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    Button("Upload your audio file") {
                        isImporting = true
                    }
                    .bubbleStyle()
                    
                    if let url = audioTrimmerManager.audioURL,
                       let duration = audioTrimmerManager.duration {
                        
                        Text("Loaded: \(url.lastPathComponent)")
                            .foregroundColor(.gray)
                        
                        Text("Duration: \(formatTime(duration))")
                        
                        Button {
                            audioTrimmerManager.togglePlayPause()
                        } label: {
                            Image(systemName: audioTrimmerManager.isPlaying
                                  ? "pause.circle.fill"
                                  : "play.circle.fill")
                                .font(.system(size: 80))
                            
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
    
    func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

#Preview {
    AudioTrimmerView()
}

#Preview {
    
    AudioTrimmerView()
}
