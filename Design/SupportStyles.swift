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
        usageTitle(title: title)
        
        Text(description)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(0.9)
            .multilineTextAlignment(.leading)
            .padding()
            .background(cardBackground)
            .customBorderStyle()
    }
}


func usageTitleProminent(title: String, ) -> some View {
    VStack(alignment: .leading) {
       
            Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.mainText.opacity(0.9))

    }
    
    
}

func usageTitle(title: String, ) -> some View {
    VStack(alignment: .leading) {
       
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.mainText.opacity(0.9))

    }
    
    
}

func navText(title: String, image: String) -> some View {
    
    HStack(spacing: 10) {
        Image(systemName: image)
            .foregroundStyle(.accent).opacity(0.7)
            .font(.system(size: 8, weight: .semibold))
        
        Text(title)
            .font(.headline.weight(.semibold))
            .foregroundStyle(Color.mainText)
        
        Spacer()
    }
    .bubbleStyle()
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
