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
    let onDelete: () -> Void
    
  
    
    var body: some View {
        
        HStack {
            TextField("", text: $partName)
     
                .limitText($partName, to: partCharacterCount)
         
            
            
            Button {
                withAnimation(.smoothReorder) {
                    // Call the parent's onDelete
                    onDelete()
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red.opacity(0.7))
                    
            }
            .buttonStyle(.plain)
            
               
            
        }

        .bubbleStyle()
        .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 10))
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
       
        
        
    }
}

