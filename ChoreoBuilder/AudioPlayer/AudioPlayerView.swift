//
//  AudioPlayerView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/03.
//

import SwiftUI
import AVKit


struct AudioPlayerView: View {
    
    @State private var isPlaying: Bool = false
    @State private var partTitle: String
    @State private var playbackSpeed: Float = 1.0
    @State private var delay: Float = 0.0
    @State private var isExpanded = false
    @State private var showMarkers = false
  
    @State private var audioPlayerManager: AudioPlayerModel
    @State private var offsetY: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var previewTime: Double = 0
    @State private var dragCounter = 0
    @State private var squareProgress: CGFloat = 1.0
    @Namespace private var animation
    

    let playbackSpeedOptions: [Float] = [2.0,1.75,1.5,1.25,1.0,0.75,0.5,0.25]
    let delayOptions: [Float] = [15,10,5,3,1,0]
    
    
    var body: some View {
        
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            
            ZStack(alignment: .top) {
                ZStack {
                    Rectangle()
                        .fill(playerBackground)
                    
                    
                    Rectangle()
                        .fill(playerBackground)
                    
                    
                    
                        .opacity(isExpanded ? 1 : 0)
                    
                }
                .clipShape(.rect(cornerRadius: isExpanded ? 45 : 3))
                .frame(height: isExpanded ? nil : 60)
                
                
                // This was added to prevent
                ZStack(alignment: .top) {
                    if isExpanded {
                        ExpandedPlayerView(size, safeArea)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        CompactPlayerView()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(Animation.organicFastBounce, value: isExpanded)
                
               
                
                
            }
            .frame(height: isExpanded ? nil : 55, alignment: .top)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, isExpanded ? 0 : safeArea.bottom + 20)
            .padding(.horizontal, isExpanded ? 0 : 10)
            .ignoresSafeArea()
            .offset(y: offsetY).animation(.smooth(duration: 0.3), value: offsetY)
            .gesture(
                // To dismiss the expanded player
                DragGesture()
                    .onChanged { value in
                        guard isExpanded else { return }
                        if value.startLocation.y < size.height / 4 {
                            let translation = max(value.translation.height, 0)
                            offsetY = translation
                        }
                    }
                    .onEnded { value in
                        guard isExpanded else { return }
                        if value.startLocation.y < size.height / 4 {
                            let translation = max(value.translation.height, 0)
                            let velocity = value.velocity.height / 1
                            
                            withAnimation(.smooth(duration: 0.1, extraBounce: 0)) {
                                if (translation + velocity) > (size.height * 0.8) {
                                    
                                    isExpanded = false
                                }
                                offsetY = 0
                            }
                        }
                        
                    }
            )
            .ignoresSafeArea()
            .toolbar(isExpanded ? .hidden : .visible, for: .tabBar)
            
        }
        .alert("Error", isPresented: $audioPlayerManager.showError) {
            Button("OK") {
                audioPlayerManager.showError = false
            }
        } message: {
            Text(audioPlayerManager.errorMessage ?? "Unknown error")
        }
        
        
        
        
    }
    
    
    private func CompactPlayerView() -> some View {
        
        
        GeometryReader { geometry in
            HStack(spacing: 20) {
                
                SlidingText(text: partTitle)
            
                    // Don't need onChange, I add this to reset the animation.
                    .id(isExpanded)
                Spacer()
                
                Image(systemName: "backward.end.fill")
                    .symbolRenderingMode(.monochrome)
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                    .onTapGesture {
                        audioPlayerManager.seekBackwards()
                        
                    }
                
                
                
                Image(systemName: audioPlayerManager.isPlaying ? "pause.fill" : "play.fill")
                    .symbolRenderingMode(.monochrome)
                    .font(.system(size: 20))
                    .foregroundStyle(.black)
                
                    .onTapGesture {
                        
                        audioPlayerManager.isPlaying ? audioPlayerManager.pauseAudio() : audioPlayerManager.playAudio()
                    }
                
                
                
                Image(systemName: "forward.end.fill")
                    .symbolRenderingMode(.monochrome)
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                    .onTapGesture {
                        audioPlayerManager.seekForwards()
                        
                    }
                
                
                
            }
           
            
            .padding()
            .contentShape(.rect)
            .onTapGesture {
                withAnimation(.spring(response: 0.1, dampingFraction: 1.0)) {
                    isExpanded = true
                }
            }
            .overlay(
                
                Rectangle()
                
                    .clipShape(.rect(cornerRadius: 3))
                
                    .frame(width: max(0,audioPlayerManager.currentTime / audioPlayerManager.totalTime * geometry.size.width) , height: 3)
                ,alignment: .topLeading
                
                
            )
            
            
        }
        
    }
    private func ExpandedPlayerView(_ size: CGSize, _ safeArea: EdgeInsets) -> some View {
        VStack(spacing: 12) {
            Capsule()
                .fill(.white.secondary)
                .frame(width:35,height: 5)
                .offset(y: -10)
            Spacer()
            
            
            
            VStack (spacing: 20) {
                
                
                ZStack(alignment: .top) {
                   
                     
                    
                    Text(partTitle)
                        
                        
                        .font(.title2)
                        .fontWeight(.medium)

                    
                }
              
            
              
                
                
                VStack {
                    
                    
                    
                    HStack(spacing: 25) {
                        
                        
                        
                        
                        
                        Image(systemName: "repeat")
                            .symbolRenderingMode(.monochrome)
                            .font(.system(size: 25))
                            .foregroundStyle( audioPlayerManager.isCustomLooping ? Color.white : Color.black)
                            .onTapGesture {
                                audioPlayerManager.toggleMarkers()
                                
                                
                            }
                            .onLongPressGesture {
                                audioPlayerManager.cancelCustomLoop()
                            }
                            .overlay(
                                Text(audioPlayerManager.isCustomLooping ? "Hold" :"AB")
                                    
                                    
                                    .customCircle()
                                
                                
                                
                                , alignment: .bottomTrailing
                                
                            )
                          
                        Image(systemName: "backward.end.fill")
                            .symbolRenderingMode(.monochrome)
                            .font(.system(size: 25))
                            .foregroundStyle(.black)
                            .onTapGesture {
                                audioPlayerManager.seekBackwards()
                                
                            }
                        
                        Image(systemName: audioPlayerManager.isPlaying  ? "pause.fill" : "play.fill")
                            .symbolRenderingMode(.monochrome)
                            .font(.system(size: 35))
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                        
                            .onTapGesture {
                                
                                audioPlayerManager.isPlaying ? audioPlayerManager.pauseAudio() : audioPlayerManager.playAudio()
                                
                                
                            }
                        
                        Image(systemName: "forward.end.fill")
                            .symbolRenderingMode(.monochrome)
                            .font(.system(size: 25))
                            .foregroundStyle(.black)
                            .onTapGesture {
                                audioPlayerManager.seekForwards()
                                
                            }
                        
                        
                        
                        
                        
                        Image(systemName: audioPlayerManager.isLooping ? "repeat" : "repeat")
                            .symbolRenderingMode(.monochrome)
                            .font(.system(size: 25))
                            .foregroundStyle(audioPlayerManager.isLooping ? Color.white : Color.black)
                            .onTapGesture {
                                audioPlayerManager.isLooping ? audioPlayerManager.stopLoop() : audioPlayerManager.loop()
                            }
                        
                    
                        
                    }
                    .padding()
                    .frame(width: 300)
                    
                    
                    
                    
                    
                    
                    
                }
                
                VStack {
                    
                    if audioPlayerManager.showMarkers {
                        
                        markerSelection
                        
                        
                    }
                    
                }
                
                
                
                .foregroundStyle(.white)
                .font(.title2)
                .frame(height: 20)
                
                
                
                
                
                
                
                
                
                
                
                
                VStack(spacing: 20){
                    
                    
                    
                    customSlider
                    
                    
                    
                    
                }
                
                HStack(spacing: 20) {
                    
                    
                    Menu {
                        Picker("Delay", selection: $delay) {
                            
                            ForEach(delayOptions, id: \.self) { delay in
                                Text("\(delay,specifier: "%g seconds")" ).tag(delay)
                            }
                            
                            
                        }
                        
                        
                        .onChange(of: delay) {
                            audioPlayerManager.changeDelay(delay)
                          
                            
                        }
                    } label: {
                        
                        Group {
                            
                            VStack(spacing: 10) {
                                Image(systemName: "powersleep")
                                
                                
                                
                                Text("\(delay, specifier: "%g ")")
                            }
                        }
                        .bold()
                        .foregroundStyle(.white)
                        .font(.title2)
                        
                        
                    }
                    Spacer()
                    
                    Menu {
                        Picker("Playback Speed", selection: $playbackSpeed) {
                            
                            ForEach(playbackSpeedOptions, id: \.self) { speedRate in
                                Text("\(speedRate, specifier: "%g")" ).tag(speedRate)
                            }
                            
                        }
                        
                        .onChange(of: playbackSpeed) {
                            audioPlayerManager.changeSpeedRate(playbackSpeed)
                            
                        }
                    }
                    
                    label: {
                        Group {
                            
                            VStack(spacing: 10) {
                                Image(systemName: "hare")

                                Text(String(format: "%g", playbackSpeed))
                            }
                        }
                        .bold()
                        .foregroundStyle(.white)
                        .font(.title2)
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                }
                
                                
            }
            .overlay(countdownTimer(width: 150, height: 150) .offset(y: -200), alignment: .top)
           
           
            
            Spacer()
        }
        
        
        .padding(15)
        .padding(.top, safeArea.top)
        
        
        
    }
    private var customSlider: some View {
        GeometryReader { geometry in
            if audioPlayerManager.isCustomLooping {
                
                markers(audioPlayerManager.firstMark / audioPlayerManager.totalTime * geometry.size.width, audioPlayerManager.secondMark / audioPlayerManager.totalTime * geometry.size.width)
                
            }
            VStack {
                
                
                GeometryReader { geo in
                    let currentProgress = isDragging ? previewTime : audioPlayerManager.currentTime
                    // Watch out for division by 0
                    // You'll get an invalid frame dimension
                    // Susceptible to error
                    let progressWidth = currentProgress / audioPlayerManager.totalTime * geo.size.width
                    
                    ZStack(alignment: .leading) {
                        // Background track
                        Capsule()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 4)
                        
                        // Progress fill
                        Capsule()
                            .fill(Color.white)
                            .frame(width: progressWidth , height: 4)
                        
                        // Thumb
                        Circle()
                            .fill(Color.white)
                            .frame(width: 14, height: 14)
                        
                            .shadow(color: .black.opacity(0.2), radius: 2)
                        
                            .scaleEffect(isDragging ? 1.3: 1)
                        
                            .offset(x: progressWidth - 7)
                        
                        
                    }
                    
                    
                    .frame(height: 20)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if !isDragging {
                                    previewTime = audioPlayerManager.currentTime
                                }
                                isDragging = true
                                let progress = max(0, min(1, value.location.x / geo.size.width))
                                previewTime = progress * audioPlayerManager.totalTime
                                
                            }
                            .onEnded { _ in
                                audioPlayerManager.seekAudio(to: previewTime)
                                audioPlayerManager.updateProgress()
                                withAnimation(.spring(duration: 0.2, bounce: 0)) {
                                    isDragging = false
                                }
                                
                                
                            }
                    )
                }
                // Frame of the whole slider
                .frame(height: 20)
                .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
                    if !isDragging {
                        audioPlayerManager.updateProgress()
                        
                    }
                }
                
                
                
                
                HStack {
                    Text(isDragging ? audioPlayerManager.timeString(time: previewTime) : audioPlayerManager.timeString(time: audioPlayerManager.currentTime))
                        .foregroundColor(.white)
                    Spacer()
                    Text(audioPlayerManager.timeString(time: audioPlayerManager.totalTime))
                        .foregroundColor(.white)
                }
                
                
                .accentColor(.white)
            }
            
            
              
            
            
            
            
        }
        
        .frame(height: 50)
        
    }
    
    
    /// MARK: Marker Buttons  to set  Custom Loop
    private var markerSelection:  some View {
        ZStack {
            Group {
                if !audioPlayerManager.firstMarkerSelected {
                    Button {
                        audioPlayerManager.setFirstMarker()
                    } label: {
                        Text("Select A Mark").foregroundStyle(.mainText)
                            .fontWeight(.medium)
                    }
                    
                    
                } else if !audioPlayerManager.secondMarkerSelected {
                    Button {
                        audioPlayerManager.setSecondMarker()
                    }label: {
                        Text("Select B Mark").foregroundStyle(.mainText)
                            .fontWeight(.medium)
                    }
                    
                    
                }
            }
            .frame(height: 10)
            .bubbleStyle()
            .shadow( radius: 1, y:1  )
        }
    }
    
    /// MARK: Marker selectors
    private func markers(_ m1: CGFloat , _ m2: CGFloat) -> some View {
        
        ZStack {
            Group {
                
                LoopMarker()
                    .offset(x: m1, y: -30 )
                
              
                
                LoopMarker()
                    .offset(x: m2, y: -30 )
            }
          
        }
        
    }
    
    
    
    
    private func countdownTimer(width: CGFloat , height: CGFloat) ->  some View {
       
        ZStack {
           
            Circle()
                .stroke(Color.accent.opacity(0.1), lineWidth: 5)
                .fill(Color.accent.opacity(0.1))

         
            Circle()
                .trim(from: 0, to: squareProgress)
                .stroke(Color.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                // --> faces this way by default
                .rotationEffect(.degrees(-90))
                .shadow(color: .accent.opacity(0.3), radius: 8)

            
            Text("\(audioPlayerManager.countdownRemaining)")
                .font(.system(size: 50))
                .foregroundColor(.accent)
                .bold()
        }
        .frame(width: width, height: height)
        
        
        .opacity((audioPlayerManager.isCountingDown && audioPlayerManager.countdownRemaining > 0) ? 1 : 0)
        .scaleEffect(audioPlayerManager.isCountingDown ? 1 : 0.7)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: audioPlayerManager.isCountingDown)
        .onChange(of: audioPlayerManager.countdownRemaining) { oldValue, newValue in
            guard newValue > 0 else { return }
            AudioServicesPlaySystemSound(1103)
            squareProgress = 0
            withAnimation {
                squareProgress = 1
            }
        }
        .onChange(of: audioPlayerManager.isCountingDown) { _, active in
            if !active {
                squareProgress = 1
            }
        }
    }

   
   
    
    init(audioFileURL: URL, partTitle: String) {
       
        self.partTitle = partTitle
        self.audioPlayerManager = AudioPlayerModel(audioFileURL: audioFileURL)
        self.audioPlayerManager.setupAudio()
        
        
    }
    
 


}

#Preview {
    let URL = Bundle.main.url(forResource: "gabagoo", withExtension: "mp3")!
    AudioPlayerView(audioFileURL: URL, partTitle: "The Initial Start " )
   
}

