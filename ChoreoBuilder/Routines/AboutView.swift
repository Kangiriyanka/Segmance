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
                   Text("About ChoreoBuilder")
                       .font(.headline)
                       .fontWeight(.semibold)
                   
                   Text("ChoreoBuilder was built for anyone who wants to have an easy time creating and practicing choreographies. In broader terms, it was built  ")
                       .font(.body)
                       .lineSpacing(2)
               }
               .padding()
               .background(shadowOutline)
               
               Divider()
               
               VStack(alignment: .leading, spacing: 12) {
                   Text("Support ChoreoBuilder")
                       .font(.headline)
                       .fontWeight(.semibold)

                   Text("If you like the app, please rate it and leave a review.\n\nFor support or feature requests, you can e-mail me: joseph.farah100@gmail.com")
                       .font(.footnote)
                       .foregroundStyle(.secondary)
                   
                   
                   
                   HStack {
                       Button("Leave a Review") {
                           requestReview()
                       }
                       .foregroundStyle(Color.mainText)
                       .bubbleStyle()
                   }
                   .padding()
                   .frame(maxWidth: .infinity )
                
                   
                  
                  
               }
               
               .padding()
               .background(shadowOutline)
               
               
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
