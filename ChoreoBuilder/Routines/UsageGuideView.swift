import SwiftUI

struct UsageGuideView: View {
    @State private var isCustomLooping: Bool = false
    @State private var delay: Double = 0.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                infoCard(
                    title: "Uploading a choreography",
                    description: "The number of music files you upload will be split into parts. Each part will have its own audio player. Once uploaded, you can rename and reorder parts by dragging. Use the clipper tool for trimming audio files."
                )
                
                BubbleSeparator()
                
                infoCard(
                    title: "Inside the choreography",
                    description: "You can switch between parts by swiping left and right. Each part is equipped with action buttons on top."
                )
                
                featureRow(
                    subtitle: "Link a video",
                    description: "Tap the film button to link a video from Photos. A play button appears once linked. Long-press to unlink."
                ) {
                    HStack(spacing: 12) {
                     
                        
                        Button {} label: {
                            Image(systemName: "film")
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
                
                featureRow(
                    subtitle: "Toggle the player",
                    description: "The music button allows you to toggle the audio player. Expand it by tapping."
                ) {
                    Button {} label: {
                        Image(systemName: "music.quarternote.3")
                    }
                    .buttonStyle(PressableButtonStyle())
                }
                
                featureRow(
                    subtitle: "Add a custom move",
                    description: "Add personalized moves. Tap the horizontal line to enter details. Drag to reorder or long-press to delete."
                ) {
                    Button {} label: {
                        Image(systemName: "plus.circle")
                    }
                    .buttonStyle(PressableButtonStyle())
                }
                
                MoveView(deleteFunction: { _ in }, move: Move.example1)
                    .contentShape(RoundedRectangle(cornerRadius: 16))
                    .contextMenu {
                        Button(role: .destructive) {} label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .padding(.horizontal)
                
                BubbleSeparator()
                
                explanationCard(
                    subtitle: "Audio player specifications",
                    description: "Besides basic audio controls, the audio player has a custom AB loop for subparts and a countdown function. Pause/resume resets the timer. Experiment to practice efficiently."
                )
                
                HStack(spacing: 25) {
                    Spacer()
                    
                    Image(systemName: "repeat")
                        .symbolRenderingMode(.monochrome)
                        .font(.system(size: 25))
                        .foregroundStyle(isCustomLooping ? Color.white : Color.black)
                        .overlay(
                            Text(isCustomLooping ? "Hold" : "AB")
                                .customCircle(),
                            alignment: .bottomTrailing
                        )
                    
                    Image(systemName: "powersleep")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                
            }
            .padding()
        }
        .background(backgroundGradient)
    }
    
    // MARK: - Info Card

    private func infoCard(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(description)
        }
        .padding()
        .background(cardBackground)
        .customBorderStyle()
    }
    
    // MARK: - Feature Row (Button + Description)
 
    private func featureRow<Content: View>(
        subtitle: String,
        description: String,
        @ViewBuilder button: () -> Content
    ) -> some View {
        HStack(alignment: .top, spacing: 16) {
            button()
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(subtitle)
                    .foregroundStyle(.accent).opacity(0.8)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .italic()
                
                Text(description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(cardBackground)
        .customBorderStyle()
    }
    
    // MARK: - Explanation Card
    @ViewBuilder
    private func explanationCard(subtitle: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(subtitle)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .italic()
            
            Text(description)
                .padding()
                .background(cardBackground)
                .customBorderStyle()
        }
        .padding()
    }
    
    // MARK: - Bubble Separator
    struct BubbleSeparator: View {
        var body: some View {
            HStack(spacing: 8) {
                Spacer()
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(.accent)
                        .frame(width: 8, height: 8)
                        .shadow(color: .black.opacity(0.15), radius: 2)
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    UsageGuideView()
}
