import SwiftUI

struct UsageGuideView: View {
    
    @State private var isCustomLooping: Bool = false
    @State private var isToggled: Bool = false
    @State private var delay: Double = 0.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                
                
                
                usageTitle(
                    title: "Uploading a choreography",
                    
                )
           
                
                infoButtonCard(
                    title: "General",
                    description: "Audio files you upload will be split into parts. Each part will have its own audio player associated with it. You can rename and drag parts to change their order.", spacing: 12) {
                        
                        Button() {
                          
                        } label: {
                            Image(systemName: "info.circle")
                        }
        
                        
                    }
                
                infoButtonCard(
                    title: "Clipping Audio",
                    description: "If there's an audio file you want to clip, please use the clipper tool.", spacing: 12) {
                        
                        Button() {
                          
                        } label: {
                            Image(systemName: "scissors")
                        }
        
                        
                    }
                
                
                
                BubbleSeparator()
                
                
                
                
                
                usageTitle(
                    title: "Inside the choreography",
                    
                )
           
                infoButtonCard(title: "Link a video" ,description: "Link a video from your Photos library to your choreography parts. Once you link a video, a new play button will appear. You can unlink the video by long-pressing it." ,spacing: 12) {
                    
                    Button() {
                        
                    } label: {
                        Image(systemName: "film")
                    }
            
                    
                  
                }
              
                
                infoButtonCard(title: "Toggle the player" ,description: "Toggle the audio player. You can expand the player by tapping on it." ,spacing: 12) {
                    
                    Button() {
                      
                    } label: {
                        Image(systemName: "music.quarternote.3")
                    }
    
                
                }
                
               
                
                
                
                infoButtonCard(title: "Add a custom move" ,description: "Add personalized moves of any type you choose. The type is an abstract way to represent the move.  You can reorder the moves by dragging them or delete them by long-pressing." ,spacing: 12) {
                    
                    withAnimation(Animation.organicFastBounce) {
                        Button() {
                            isToggled.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                        
                    }
                   
                }
             
               
                    

         
                
                
                BubbleSeparator()
                
            
            
                
                usageTitle(
                    title: "Audio player specifications",
                    
                )
                
                infoButtonCard(title: "Custom Loop" ,description: "Set a custom loop for longer parts you want to practice. You can turn it off by long-pressing it. ", spacing: 12) {
                    
                    
                    Image(systemName: "repeat")
                        .symbolRenderingMode(.monochrome)
                        .font(.system(size: 26))
                        .foregroundStyle(isCustomLooping ? Color.white : Color.black)
                       
                     
                        .overlay(
                            Text(isCustomLooping ? "Hold" :"AB")
                                
                                
                                .customCircle()
                            
                            
                            
                            , alignment: .bottomTrailing
                            
                        )
                   
                }
                
                infoButtonCard(title: "Countdown" ,description: "Set a countdown before you start performing. The countdown resets every time you pause or when the looped parts are done." ,spacing: 12) {
      
                    Group {
                        
                        VStack(spacing: 10) {
                            Image(systemName: "powersleep")
                                .foregroundStyle(.mainText)
                            
                            
                     
                        }
                    }
                    .bold()
                    .foregroundStyle(.white)
                    .font(.title2)
                   
                }
                

            
            }
            .padding()
        }
        .background(backgroundGradient)
    }
    

}



func infoButtonCard<T: View>(
    title: String,
    description: String,
    spacing: CGFloat,
    content: () -> T
) -> some View {
    VStack(alignment: .leading, spacing: spacing) {
        HStack(alignment: .top, spacing: 16) {
            
            VStack {
                Spacer()
                content()
                Spacer()
            }
            .padding(5)
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .italic()
                
                Text(description)
                    .font(.footnote)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(cardBackground)
        .customBorderStyle()
        .buttonStyle(NavButtonStyle())
        
        
    }
}

// MARK: - Info Card
func explanationCard(subtitle: String, description: String, spacing: CGFloat) -> some View {
    VStack(alignment: .leading, spacing: spacing) {
       
            Text(subtitle)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary).italic()
            
            Text(description)
                .padding()
                .background(cardBackground)
                .customBorderStyle()
        
     
    }
    .padding()
    
    
}


#Preview {
    UsageGuideView()
}

