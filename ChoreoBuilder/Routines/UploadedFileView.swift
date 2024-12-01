//
//  UploadedPartView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/21.
//

import SwiftUI

struct UploadedFileView : View {
    
    @Binding var partName: String
    @State private var partCharacterCount: Int = 25
  
    
    var body: some View {
        
        HStack {
            TextField("", text: $partName)
     
                .limitText($partName, to: partCharacterCount)
                .italic(true).bold()
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.8), lineWidth: 1))
        }
        
        .padding()
    }
}

