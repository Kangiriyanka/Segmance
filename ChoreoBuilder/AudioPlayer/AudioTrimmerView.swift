import SwiftUI
import AVFoundation


// Step 1: Import the Audio File
// Step 2: Attach it to the AudioPlayerModel


struct AudioTrimmerView: View {
    
    
    @State private var isImporting: Bool = false
    @State private var audioTrimmerManager:  AudioTrimmerModel = AudioTrimmerModel()
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {  // ← Add this
                Button("Upload your audio file") {
                    isImporting = true
                }
                
                if let url = audioTrimmerManager.audioURL {
                    Text("Loaded: \(url.lastPathComponent)")
                        .foregroundColor(.gray)
                    
                    Button(action: { audioTrimmerManager.togglePlayPause() }) {
                        Image(systemName: audioTrimmerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 80))
                    }
                }
            }  // ← Close VStack
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.audio], allowsMultipleSelection: false) { result in
                
                switch result {
                case .success(let urls):
                    if let audioURL = urls.first {
                        audioTrimmerManager.setupAudio(url: audioURL)
                    }
                case .failure(let err):
                    print("Error: \(err.localizedDescription)")
                }
            }
        }
        .background(backgroundGradient)
    }
    
    
   
    
    
    
    
}

#Preview {
   
    AudioTrimmerView()
}

