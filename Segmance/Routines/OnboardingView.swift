//
//  OnboardingView.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/12/04.
//

import SwiftUI


struct OnboardingView: View {
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    @State private var currentPage = 0
    @State private var startButtonScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                OnboardingPage(
                    image: "waveform",
                    title: "Segment Your Performance",
                    description: "Break your performance into parts by uploading separate audio files."
                )
                .tag(0)

                OnboardingPage(
                    image: "list.bullet.rectangle",
                    title: "Add Notes to Parts",
                    description: "Add notes, link videos, and practice with the built-in audio player."
                )
                .tag(1)

                OnboardingPage(
                    image: "scissors",
                    title: "Clip Audio",
                    description: "Clip audio tracks anytime to practice specific parts."
                )
                .tag(2)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            
            VStack {
                
                Spacer()
                if currentPage == 2 {
                    Button("Get Started") {
                        hasOnboarded = true
                    }
                    .padding()
                    .transition(.scale)
                    .animation(.easeInOut, value: startButtonScale)
                 
                    .onAppear {
                        withAnimation(Animation.organicFastBounce) {
                            startButtonScale = 1.0
                        }
                    }
                    .buttonStyle(ReviewButtonStyle())
                    .padding(.bottom, 50)
                }
            }
            // Add this to the outer stack for exit animations
            .animation(Animation.smoothReorder, value: currentPage)
            .onChange(of: currentPage) { oldValue, newValue in
                if newValue == 2 {
                    startButtonScale = 0.4
                }
            }
        }
        .background(backgroundGradient)
    }
}

struct OnboardingPage: View {
    let image: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
          
            Image(systemName: image).font(.system(size: 100)).foregroundStyle(.accent.opacity(0.7))
            Text(title)
                .font(.largeTitle)
                .bold()
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
          
        }
    }
}


#Preview {
    OnboardingView()
}
