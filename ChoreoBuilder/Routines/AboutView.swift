//
//  AboutView.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/11/23.
//

import SwiftUI
import StoreKit

struct AboutView: View {
    @Environment(\.requestReview) private var requestReview
    
    private let supportEmail = "joseph.farah100@gmail.com"
    private let websiteURL = "https://joefarah.com"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                infoCard(
                    title: "Why ChoreoBuilder?",
                    description: "ChoreoBuilder offers a simple and organized way of segmenting music into manageable parts to brainstorm and practice choreographies enjoyably.",
                    spacing: 12
                )
                
                BubbleSeparator()
                
                infoCard(
                    title: "What's a choreography?",
                    description: "In this app, a choreography is a sequence of movements that brings your performance to life.",
                    spacing: 12
                )
                
                BubbleSeparator()
                
                supportCard()
            }
            .padding()
        }
        .background(backgroundGradient)
    }
    

    
    // MARK: - Support Card
    func supportCard() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            
            VStack(alignment: .leading){
                Text("Support")
                    .font(.headline)
                    .foregroundStyle(.secondary).italic()
                    .fontWeight(.semibold)
                
                Text("Enjoying the app? Rate it, reach out personally for support or request features.")
                    .padding()
                    .background(cardBackground)
                    .customBorderStyle()
                
                
               
                
                HStack(spacing: 12) {
                    Button {
                        requestReview()
                    } label: {
                        Label("Review", systemImage: "star.circle.fill")
                            .frame(maxWidth: .infinity)
                    }

                    Link(destination: URL(string: websiteURL)!) {
                        Label("Website", systemImage: "safari")
                            .frame(maxWidth: .infinity)
                    }
                }
                .offset(y: 20)
                .scaleEffect(0.9)
                .padding(25)
               
                
                .buttonStyle(ReviewButtonStyle())
                
            }
            
        }
    }
    
    // MARK: - Bubble Separator
    struct BubbleSeparator: View {
        var body: some View {
            HStack(spacing: 8) {
                Spacer()
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(.accent).opacity(0.7)
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
    AboutView()
}
