import SwiftUI
import AVKit

struct DraggableVideoPlayer: View {
    let url: URL
    @Binding var isShowing: Bool
    
    @State private var offset: CGSize = .zero
    @State private var dragOffset: CGSize = .zero
    
    private let size: CGFloat = 350
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Video Player
            VideoPlayer(player: AVPlayer(url: url))
                .frame(width: size, height: size)
                .cornerRadius(12)
                .shadow(radius: 5)
                .offset(
                    x: offset.width + dragOffset.width,
                    y: offset.height + dragOffset.height
                )
                .gesture(dragGesture)
            
            // Close Button
            Button {
                isShowing = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
            }
            .padding(8)
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                offset.width += value.translation.width
                offset.height += value.translation.height
                dragOffset = .zero
            }
    }
}
