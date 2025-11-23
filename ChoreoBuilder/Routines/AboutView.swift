//
//  AboutView.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/11/23.
//

import SwiftUI

import SwiftUI
import StoreKit

struct AboutView: View {
   @Environment(\.requestReview) private var requestReview
   
   var body: some View {
       ScrollView {
           VStack(alignment: .leading, spacing: 24) {
               
               VStack(alignment: .leading, spacing: 12) {
                   Text("How to use")
                       .font(.headline)
                       .fontWeight(.semibold)
                   
                   Text("Upload parts of a song you want to practice with. With every part, you can take notes and practice the respective audio of that song.")
                       .font(.body)
                       .lineSpacing(2)
               }
               
               Divider()
               
               VStack(alignment: .leading, spacing: 12) {
                   Text("About ChoreoBuilder")
                       .font(.headline)
                       .fontWeight(.semibold)
                   
                   Text("ChoreoBuilder was built for anyone who wants to have an easy time creating and practicing choreographies. ")
                       .font(.body)
                       .lineSpacing(2)
               }
               
               Divider()
               
               VStack(alignment: .leading, spacing: 12) {
                   Text("Support ChoreoBuilder")
                       .font(.headline)
                       .fontWeight(.semibold)

                   Text("If you like the app, please rate it and leave a review.")
                       .font(.footnote)
                       .foregroundStyle(.secondary)

                   Text("For support or feature requests, you can e-mail me:")
                       .font(.footnote)
                       .foregroundStyle(.secondary)

                   Link("joseph.farah100@gmail.com",
                        destination: URL(string: "mailto:joseph.farah100@gmail.com")!)
                       .font(.footnote)
                       .foregroundStyle(.blue)
                   
                   
                   HStack {
                       Button("Leave a Review") {
                           requestReview()
                       }
                       .foregroundStyle(Color.mainText)
                       .bubbleStyle()
                   }
                   .frame(maxWidth: .infinity )
                
                   
                  
                  
               }
               
               
           }
           .padding()
       }
       .background(
        backgroundGradient
       )
   }
}

#Preview {
   AboutView()
}

#Preview {
    AboutView()
}
