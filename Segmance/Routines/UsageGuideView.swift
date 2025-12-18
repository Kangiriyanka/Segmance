import SwiftUI

struct UsageGuideView: View {
    
    @State private var isCustomLooping: Bool = false
    @State private var isToggled: Bool = false
    @State private var delay: Double = 0.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                
                
                
                usageTitle(
                    title: "Uploading a routine",
                    
                )
           
                
                infoButtonCard(
                    title: "General",
                    description: "Audio files uploaded will be split into parts. Each part has its own audio player. Rename or reorder parts in Settings.", spacing: 12) {
                        
                        Button() {
                          
                        } label: {
                            Image(systemName: "info.circle")
                        }
        
                        
                    }
                
                infoButtonCard(
                    title: "Clip Audio",
                    description: "Clip audio files beforehand using the clipper tool.", spacing: 12) {
                        
                        Button() {
                          
                        } label: {
                            Image(systemName: "scissors")
                        }
        
                        
                    }
                
                
                
                BubbleSeparator()
                
                
                
                
                
                usageTitle(
                    title: "Inside the routine",
                    
                )
           
                infoButtonCard(title: "Reference videos" ,description: "Link a video from your Photos library to any part for reference. Hold the play button to unlink." ,spacing: 12) {
                    
                    Button() {
                        
                    } label: {
                        Image(systemName: "film")
                    }
                    
                
            
                    
                  
                }
              
                
                infoButtonCard(title: "Toggle the player" ,description: "Show/hide the audio player. Tap to expand." ,spacing: 12) {
                    
                    Button() {
                      
                    } label: {
                        Image(systemName: "music.quarternote.3")
                    }
                    
    
                
                }
                
               
                
                
                
                infoButtonCard(title: "Add custom moves" ,description: "Create custom moves and assign types that fit your creative process. Delete them by holding their number." ,spacing: 12) {
                    
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
                
                infoButtonCard(title: "Custom Loop" ,description: "Loop any section for focused practice. Hold to clear loop marks.", spacing: 12) {
                    
                    
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
                
                infoButtonCard(title: "Countdown" ,description: "Set a countdown before rehearsing. The countdown resets on pause or when the loop completes. Change the tick sound in the Settings." ,spacing: 12) {
      
                    Group {
                        
                        VStack(spacing: 10) {
                            Image(systemName: "timer")
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

