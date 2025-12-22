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
            .cornerRadius(10)
            .shadow(radius: 5)
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

    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                
               
                   
                    VideoPlayer(player: player)
                        
                    
                        .task {
                            player = AVPlayer(url: url)
                            
                        }
                        .overlay(
                            
                            HStack {
                                
                                
                                
                                Button {
                                    withAnimation(.organicFastBounce) {
                                        toggleScreen(width: geometry.size.width, height: geometry.size.height)
                                    }
                                } label: {
                                    Image(systemName: isFullScreen ? "rectangle.arrowtriangle.2.inward" : "rectangle.arrowtriangle.2.outward")
                                        .padding(8)
                                      
                                        .clipShape(Circle())
                                }
                                
                                Button {
                                    withAnimation(.organicFastBounce) {
                                        isShowing = false
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .foregroundStyle(Color.white)
                                        .padding(8)
                                        .clipShape(Circle())
                                       
                                }
                                
                                
                            }
                                .offset(x: -35, y: 15)
                                
               
                                 
                                 
                            , alignment: .topTrailing)
                    
                
              
                
            }
            .toolbar(isShowing ? .hidden: . visible, for: .tabBar)
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
                }
          
         
            
            
            
            
        }
    }
    
    func toggleScreen(width: CGFloat, height: CGFloat) {
        
        isFullScreen.toggle()
        if isFullScreen {
            // Expand to fit within the available geometry while preserving aspect ratio
            let targetWidth = width
            let targetHeight = height
            // Use the larger that fits while keeping centered position within bounds
            videoWidth = targetWidth
            videoHeight = targetHeight
            currentPosition = .zero
            newPosition = .zero
        } else {
            // Restore to default compact size
            videoWidth = 300
            videoHeight = 200
            // Keep the player within bounds after shrinking
            currentPosition.width = min(max(currentPosition.width, 0), max(0, width - videoWidth))
            currentPosition.height = min(max(currentPosition.height, 0), max(0, height - videoHeight))
        }
        
    }
}


#Preview {
    DraggableVideoPlayer(url: URL("")! , isShowing: .constant(false))
}
