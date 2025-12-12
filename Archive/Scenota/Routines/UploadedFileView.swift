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
                .bubbleStyle()
            
               
            
        }
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        
        
    }
}

