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
    
    var body: some View {
        VStack{
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(routine.parts.sorted(by: { $0.order < $1.order })) { part in
                        PartView(part: part)
                            .frame(width: UIScreen.main.bounds.width)
                        
                    }
                }
                
            }
            
           
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.never)
        }
           
         
            
        }
       
    
}

#Preview {
    let routine = Routine.secondExample
    RoutineView(routine: routine)
}
