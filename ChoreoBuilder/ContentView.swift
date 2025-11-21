
import SwiftUI
import AVFoundation
import SwiftData



/// TO-DOS:
/// 1. Delay countdown
/// 2. Custom Loop Toggle
/// 3. Audio Trimmer

struct ContentView: View {
  
    init() {
        let itemAppearance = UITabBarItemAppearance()
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(
            Color.customBlue.opacity(0.5)
              )
        appearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
        
    }
    var body: some View {
        
      
            TabView {
                
                
                RoutineContainerView()
                   
                    .tabItem {
                        Label("Routines", systemImage: "figure.dance")
                        
                    }
                 
                
                AudioTrimmerView()
                    .tabItem {
                        Label("Trimmer", systemImage: "scissors")
                    }
               
                
                OptionsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                
                
                
                
                #if targetEnvironment(simulator)
                FilesView()
                    .tabItem {
                        Label("Files", systemImage: "folder")
                    }
                #endif
                
               
            }
     
        
    }
    

}



#Preview {
    let preview = Routine.preview
   
    ContentView()
        .modelContainer(preview)
    
}

#Preview {
    let preview = Routine.preview
   
    ContentView()
        .modelContainer(preview)
        .preferredColorScheme(.dark)
    
}
