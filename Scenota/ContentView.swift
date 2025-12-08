
import SwiftUI
import AVFoundation
import SwiftData





struct ContentView: View {
    
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    

  
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
        
        Group {
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
                
            }
            
            else {
                OnboardingView()
            }
        }
        .animation(.easeInOut(duration: 0.7), value: hasOnboarded)
        .transition(.move(edge: .trailing).combined(with: .opacity))
        
    
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
