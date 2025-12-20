
import SwiftUI
import AVFoundation
import SwiftData





struct ContentView: View {
    
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    
    

  
    init() {
        let itemAppearance = UITabBarItemAppearance()
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(
            Color.customBlue.opacity(0.7)
              )
      
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    
    var body: some View {
        
        ZStack {
            if hasOnboarded {
                TabView {
                    
                    
                    RoutineContainerView()
                    
                        .tabItem {
                            Label("Routines", systemImage: "figure.dance")
                            
                        }
                    
                    
                    AudioTrimmerView()
                        .tabItem {
                            Label("Clipper", systemImage: "scissors")
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
                .transition(.move(edge: .trailing))
               
             
                
            }
            
            else {
                OnboardingView()
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: hasOnboarded)
       
   
     
        
    
    }
    

}



#Preview {
    let preview = Routine.preview
   
    ContentView()
    
        .modelContainer(preview)
        .onAppear {
                UserDefaults.standard.set(false, forKey: "hasOnboarded")
            }
    
}

#Preview {
    let preview = Routine.preview
   
    ContentView()
        .modelContainer(preview)
        .preferredColorScheme(.dark)
    
}
