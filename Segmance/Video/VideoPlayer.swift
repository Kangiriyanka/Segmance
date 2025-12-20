import SwiftUI
import AVKit

struct DraggableVideoPlayer: View {
    let url: URL
    @Binding var isShowing: Bool

    @State private var offset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero

    private let width: CGFloat = 400
    private let height: CGFloat = 400

    private var clampedOffset: CGSize {
        let screen = UIScreen.main.bounds
        let maxX = (screen.width - width) / 2
        let maxY = (screen.height - height) / 2
        return CGSize(
            width: offset.width + dragOffset.width,
            height: offset.height + dragOffset.height
        )
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VideoPlayer(player: AVPlayer(url: url))
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(width: width, height: height)
                .offset(clampedOffset)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                        }
                        .onEnded { value in
                            let screen = UIScreen.main.bounds
                            let maxX = (screen.width - width) / 2
                            let maxY = (screen.height - height) / 2

                            offset.width = min(max(offset.width + value.translation.width, -maxX), maxX)
                            offset.height = min(max(offset.height + value.translation.height, -maxY), maxY)
                        }
                )

            Button {
                isShowing = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .padding(6)
            }
            .offset(clampedOffset)
        }
    }
}
