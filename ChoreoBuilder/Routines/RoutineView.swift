//
//  RoutineView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/12.
//

import Foundation
import SwiftUI


struct RoutineView: View {
    var routine: Routine
    @State private var isExpanded : Bool = false
    
    // Toolbar hiding needs to be visible to the outermost layer
    // If you add it to a specific part, the other parts won't know to hide.
    
    @State private var anyPlayerExpanded: Bool = false
    
    var body: some View {
        VStack{
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    // Without this the parts, you'd see parts randomly shuffling
                    ForEach(routine.parts.sorted(by: { $0.order < $1.order })) { part in
                        PartView(part: part, playerExpanded: $anyPlayerExpanded)
                          
                   
                           
                            .frame(width: UIScreen.main.bounds.width)
                        
                    }
                }
                
            }
            
            .toolbar(anyPlayerExpanded ? .hidden : .visible, for: .tabBar)
            .ignoresSafeArea(.container, edges: anyPlayerExpanded ? .bottom : [])
           
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.never)
        }
       
     
       
           
            
        }
       
}

#Preview {
    let routine = Routine.secondExample
    RoutineView(routine: routine)
}
