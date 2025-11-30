//
//  SupportStyles.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/11/30.
//

import Foundation
import SwiftUI
import StoreKit

// MARK: - Info Card
func infoCard(title: String, description: String, spacing: CGFloat) -> some View {
    VStack(alignment: .leading, spacing: spacing) {
       
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary).italic()
            
            Text(description)
                .padding()
                .background(cardBackground)
                .customBorderStyle()
        
     
    }
    
    
}
func usageTitle(title: String, ) -> some View {
    VStack(alignment: .leading) {
       
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary).italic()
            
       
        
     
    }
    
    
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
