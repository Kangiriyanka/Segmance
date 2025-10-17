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
               
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.customNavy.opacity(0.9), lineWidth: 1)
                )
        }
        
        .padding()
    }
}

