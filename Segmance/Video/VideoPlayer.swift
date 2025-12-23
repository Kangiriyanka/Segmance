import SwiftUI
import AVKit


// On top of the ScrollView
// You have to think: What View is obstructing the other?
// It interferes with the move view and orders so weird.

struct DragModifier: ViewModifier {
    let videoWidth: CGFloat
    let videoHeight: CGFloat
    @Binding var currentPosition: CGSize
    @Binding var newPosition: CGSize
    let geometry: GeometryProxy
    
    
    func body(content: Content) -> some View {
        content
         
            .frame(width: videoWidth, height: videoHeight)
            .cornerRadius(8)
            .shadow(radius: 4)
            .offset(
                x: min(max(currentPosition.width + newPosition.width, 0), geometry.size.width - videoWidth),
                y: min(max(currentPosition.height + newPosition.height, 0), geometry.size.height - videoHeight)
            )
    
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        newPosition = value.translation
                    }
                    .onEnded { value in
                        
                        let newX = currentPosition.width + value.translation.width
                        let newY = currentPosition.height + value.translation.height
                        
                        currentPosition.width = min(max(newX, 0), geometry.size.width - videoWidth)
                        currentPosition.height = min(max(newY, 0), geometry.size.height - videoHeight)
                        newPosition = .zero
                    }
            )
    }
}



struct DraggableVideoPlayer: View {
    let url: URL
    @Binding var isShowing: Bool
    @State private var player: AVPlayer?
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State private var isFullScreen: Bool = false
    
    
    @State private var videoWidth: CGFloat = 350
    @State private var videoHeight: CGFloat = 200
    
    @State private var showControls = true
    @State private var autoDismissTask: Task<Void, Never>?

    var body: some View {
        GeometryReader { geometry in
            VideoPlayer(player: player)
                .overlay (
                    customControls(geometry: geometry)
                       
                        .padding(.top, isFullScreen ? 15 : 5)
                        .opacity(showControls ? 1 : 0)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .animation(.easeInOut(duration: 0.2), value: showControls)
                        
                    ,alignment: .top)
                
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            autoDismissTask?.cancel()
                            withAnimation(.smoothReorder) {
                                showControls.toggle()
                            }
                            if showControls {
                                startAutoDismiss()
                            }
                        }
                )
                .task {
                    player = AVPlayer(url: url)
                }
                .modifier(DragModifier(
                    videoWidth: videoWidth,
                    videoHeight: videoHeight,
                    currentPosition: $currentPosition,
                    newPosition: $newPosition,
                    geometry: geometry
                ))
                .onAppear {
                    guard currentPosition == .zero else { return }
                    currentPosition = CGSize(
                        width: (geometry.size.width - videoWidth) / 2,
                        height: (geometry.size.height - videoHeight) / 2
                    )
                    if showControls {
                        startAutoDismiss()
                    }
                }
        }
       
        .ignoresSafeArea(.all)
        
    }

    private func startAutoDismiss() {
        autoDismissTask?.cancel()
        autoDismissTask = Task {
            try? await Task.sleep(for: .seconds(2.75))
            guard !Task.isCancelled else { return }
            withAnimation(.smoothReorder) {
                showControls = false
            }
        }
    }
    private func customControls(geometry: GeometryProxy) ->  some View {
        
        
        HStack(spacing: 5) {
            
        
            
            Button {
                withAnimation(
                    .spring(
                        response: 0.35,
                        dampingFraction: 0.9,
                        blendDuration: 0.1
                    )
                ) {
                    toggleScreen(width: geometry.size.width, height: geometry.size.height)
                }
            } label: {
                Image(systemName: isFullScreen ? "rectangle.arrowtriangle.2.inward" : "rectangle.arrowtriangle.2.outward")
                    .foregroundStyle(Color.white)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                   
            }
            
            Button {
                withAnimation(
                    .spring(
                        response: 0.35,
                        dampingFraction: 0.9,
                        blendDuration: 0.1
                    )
                ) {
                    isShowing = false
                }
            } label: {
                Image(systemName: "xmark.circle")
                    .foregroundStyle(Color.white)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                  
                
            }
            
        
            
            
        }
       
    }
    
    @State private var previousPosition: CGSize = .zero

    func toggleScreen(width: CGFloat, height: CGFloat) {
        isFullScreen.toggle()
        
        if isFullScreen {
            // Store current position before going full-screen
            previousPosition = currentPosition
            
            let targetWidth = width
            let targetHeight = height
            videoWidth = targetWidth
            videoHeight = targetHeight
            currentPosition = .zero
            newPosition = .zero
        } else {
            // Restore to default compact size
            videoWidth = 350
            videoHeight = 200
            
            // Restore previous position, clamped to new bounds
            currentPosition.width = min(max(previousPosition.width, 0), max(0, width - videoWidth))
            currentPosition.height = min(max(previousPosition.height, 0), max(0, height - videoHeight))
        }
    }
}


#Preview {
    DraggableVideoPlayer(url: URL("")! , isShowing: .constant(false))
}
