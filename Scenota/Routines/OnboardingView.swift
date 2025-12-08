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
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                OnboardingPage(
                    image: "star.fill",
                    title: "Practice for your performances step by step",
                    description: "Get started with our app"
                )
                .tag(0)
                
                OnboardingPage(
                    image: "heart.fill",
                    title: "Upload audio files",
                    description: "Every part of your performance can be practiced separately"
                )
                .tag(1)
                
                OnboardingPage(
                    image: "bolt.fill",
                    title: "Feature Two",
                    description: "Description of another feature"
                )
                .tag(2)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            VStack {
                
                
                if currentPage == 2 {
                    Button("Get Started") {
                        hasOnboarded = true
                    }
                    .buttonStyle(NavButtonStyle())
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPage: View {
    let image: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
          
     
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
