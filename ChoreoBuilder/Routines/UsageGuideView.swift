//
//  UsageGuideView.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/11/27.
//

import SwiftUI

struct UsageGuideView: View {
    var body: some View {
        
        Section {
            Text("1. In the Routines tab, you can add your choreography by pressing on the upload icon. ")
        } header: {
            Text("Uploading a Choreography")
        }
        
        Section {
            Text("Every part you upload will have its own audio associated with it. You can add moves to each part and add some details ")
        } header: {
            Text("Adding Moves")
        }
        
        Section {
            Text("1. Custom Looping: ")
            Text("Adding a Delay. Every time you pause, you reset the delay timer. This is useful if you want to time to get in position before you do your choreography ")
        } header: {
            Text("Audio Player")
        }
       
    }
}

#Preview {
    UsageGuideView()
}
