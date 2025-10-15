
import SwiftUI
import AVFoundation
import SwiftData


struct ContentView: View {
  
    init() {
        let itemAppearance = UITabBarItemAppearance()
        let appearance = UITabBarAppearance()
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
                
                AudioClipperView()
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
