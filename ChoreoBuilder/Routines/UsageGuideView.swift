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
                    description: "Audio files uploaded will be split into parts. Each part will have its own audio player associated with it. You can rename and drag parts to change their order.", spacing: 12) {
                        
                        Button() {
                          
                        } label: {
                            Image(systemName: "info.circle")
                        }
        
                        
                    }
                
                infoButtonCard(
                    title: "Clipping Audio",
                    description: "If there's an audio file you want to clip beforehand, use the clipper tool.", spacing: 12) {
                        
                        Button() {
                          
                        } label: {
                            Image(systemName: "scissors")
                        }
        
                        
                    }
                
                
                
                BubbleSeparator()
                
                
                
                
                
                usageTitle(
                    title: "Inside the choreography",
                    
                )
           
                infoButtonCard(title: "Link a video" ,description: "Link a video from your Photos library to a specific part. Once linked, a new play button will appear. You can unlink the video by long-pressing the play button." ,spacing: 12) {
                    
                    Button() {
                        
                    } label: {
                        Image(systemName: "film")
                    }
                    
                
            
                    
                  
                }
              
                
                infoButtonCard(title: "Toggle the player" ,description: "Toggle the audio player. It can be expanded  by tapping on it." ,spacing: 12) {
                    
                    Button() {
                      
                    } label: {
                        Image(systemName: "music.quarternote.3")
                    }
                    
    
                
                }
                
               
                
                
                
                infoButtonCard(title: "Add a custom move" ,description: "Add personalized moves of any type you choose. The type is an abstract way to represent the move.  ." ,spacing: 12) {
                    
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
                
                infoButtonCard(title: "Custom Loop" ,description: "Set a custom loop for longer parts you want to practice. Turn it off by long-pressing it. ", spacing: 12) {
                    
                    
                    Image(systemName: "repeat")
                        .foregroundStyle(.mainText)
                        .font(.system(size: 20))
                        .foregroundStyle(isCustomLooping ? Color.white : Color.black)
                       
                     
                        .overlay(
                            Text(isCustomLooping ? "Hold" :"AB")
                                
                                
                                .customCircle().scaleEffect(0.8)
                            
                            
                            
                            , alignment: .bottomTrailing
                            
                        )
                   
                }
                
                infoButtonCard(title: "Countdown" ,description: "Set a countdown before you start practicing. The countdown resets every time you pause or when a loop finishes" ,spacing: 12) {
      
                    Group {
                        
                        VStack(spacing: 10) {
                            Image(systemName: "powersleep")
                                .font(.system(size: 20))
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
        .frame(maxWidth: .infinity, alignment: .leading)
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

