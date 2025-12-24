//
//  UploadedPartView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/21.
//

import SwiftUI




struct UploadedFileView : View {
    
    @Binding var partName: String {
        didSet {
            if partName.count > partCharacterCount {
                partName = String(partName.prefix(partCharacterCount))
            }
        }
    }
    @State private var partCharacterCount: Int = 30
    let onDelete: () -> Void
    
  
    
    var body: some View {
        
        HStack {
            TextField("Enter a part name", text: $partName)
     
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

