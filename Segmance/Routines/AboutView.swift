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
                    title: "Segment your performance ",
                    description: "Segmance helps you break down performances into parts for organized meaningful practice.",
                    spacing: 12
                )
                
                BubbleSeparator()
                
                infoCard(
                    title: "Who is this for?",
                    description: "Built for anyone who wants to express themselves through music and movement.",
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
                    .customHeader()
                
                Text("Enjoying the app? I’d love to hear your feedback. Reach out anytime for support or feature requests.")
                    .padding()
                    .background(cardBackground)
                    .customBorderStyle()
                
                
               
                
                HStack(spacing: 12) {
                    Button {
                        let email = "joseph.farah100@gmail.com"
                        let subject = "Segmance Feedback"
                        let body = "Feel free to share what you'd like added, fixed or any other feedback."
                        
                        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        
                        let urlString = "mailto:\(email)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
                        
                        if let url = URL(string: urlString) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Support", systemImage: "mail")
                            .frame(maxWidth: .infinity)
                    }

                    Link(destination: URL(string: websiteURL)!) {
                        Label("Portfolio", systemImage: "safari")
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

