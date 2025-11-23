
//
//  CustomSearchBar.swift
//  Drawgress
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/27.
//

import Foundation
import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Find a prompt"
    @State private var isExpanded = false
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            if !isExpanded {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        isExpanded = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.mainText)
                            .fontWeight(.semibold)
                            .matchedGeometryEffect(id: "icon", in: animation)
                    }
                    .padding()
                    .background(
                        Capsule()
                            .fill(Color.routineCard)
                            .matchedGeometryEffect(id: "background", in: animation)
                    )
                 
                }
            } else {
           
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .matchedGeometryEffect(id: "icon", in: animation)
                    
                    TextField(placeholder, text: $text)
                    
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.none)
                        
                  
                    
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            isExpanded = false
                            text = ""
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.accent)
                            .font(.system(size: 14, weight: .semibold))
                    }
                   
                }
                .padding()
                .background(
                    Capsule()
                        .fill(Color.customBlue.opacity(0.3))
                        .matchedGeometryEffect(id: "background", in: animation)
                )
               
            }
        }
        .padding()
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 3)
        .frame(maxWidth: .infinity, maxHeight: 30, alignment: .trailing)
    }
}
