//
//  RoutineContainerView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/12.
//

import SwiftUI
import SwiftData

struct RoutineContainerView: View {
    
    @Environment(\.modelContext)  var modelContext
    @State private var showingUploadRoutineSheet: Bool = false
    @State private var showingConfirmation: Bool = false
    @State private var searchText: String = ""
    @State private var routinePendingDeletion: Routine? = nil
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Routine.title) var routines: [Routine]
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("viewMode") private var isCompactView: Bool = false
    
    var filteredRoutines: [Routine] {
               if searchText.isEmpty {
                   return routines
               }
        return routines.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    


    
    var body: some View {
        
        NavigationStack {
            
            
        
            VStack {
                
                HStack(spacing: 10) {
                    Spacer()
                    CustomSearchBar(
                        text: $searchText,
                        placeholder: "Search routines"
                    )
                    
                    .contentShape(Rectangle())
                
                  
                    
                    HStack {
                        addRoutineButton
                        viewModeButton
                    }
                        
                    Spacer()
                      
                }
                .frame(maxWidth: .infinity)
                .offset(y: -15)
                .sheet(isPresented: $showingUploadRoutineSheet) {
                    UploadRoutineView()
                        .background(noSinBackgroundGradient.opacity(0.9))
                }
               
                
                
                
              
                
                Group {
                    if filteredRoutines.isEmpty {
                        
                        ContentUnavailableView {
                            Label("No routines found", systemImage: "music.quarternote.3")
                        } description: {
                            Text("Add one by tapping the \(Image(systemName: "figure.dance")) button.").padding([.top], 5)
                        }
                        
                        
                        
                        
                    }
                    else {
                        
                        
                       
                        ScrollView(.vertical, showsIndicators: false) {
                            if isCompactView {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                    ForEach(filteredRoutines) { routine in
                                        NavigationLink(destination: RoutineView(routine: routine) .navigationBarBackButtonHidden(true)) {
                                            CompactRoutineCard(routine: routine)
                                        }
                                        .buttonStyle(NavButtonStyle())
                                     
                                    }
                                }
                            
                            } else {
                                ForEach(Array(filteredRoutines.enumerated()), id: \.element.id) { index, routine in
                                    NavigationLink(destination: RoutineView(routine: routine) .navigationBarBackButtonHidden(true))  {
                                        RoutineCardView(off: Double(index), routine: routine)
                                            .padding(.vertical, 10)
                                    }
                                    .buttonStyle(NavButtonStyle())
                                  
                                }
                             
                            }
                        }
                       
                        .animation(.smoothReorder, value: isCompactView)
                        .contentMargins(.bottom, 50, for: .scrollContent)
                       
                
                    
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                }
                
            }
            .padding()
            // MARK: Screen Background
            .background(
                backgroundGradient
            )
            
            .navigationTitle("Routines")
            .ignoresSafeArea(.keyboard)
            .navigationBarTitleDisplayMode(.inline)
        
           
          
            
           
        }
        
     
     
    }
    
    
    private var addRoutineButton: some View {
        Button {
            showingUploadRoutineSheet.toggle()
        } label: {
            Image(systemName: "figure.dance")
                
                
             
        }
     
        .buttonStyle(PressableButtonStyle())
        .contentShape(Rectangle())
       
        
    }
    
    
    private var viewModeButton: some View {
        Button {
            withAnimation(Animation.smoothReorder) {
                  isCompactView.toggle()
              }
          } label: {
              Image(systemName: isCompactView ? "square.grid.2x2" : "rectangle.grid.1x2")
                  .frame(width: 10)
                  
          }
          
     
          .buttonStyle(PressableButtonStyle())
          .contentShape(Rectangle())
       
        
    }

    
   
    

    
    
    
}




struct CompactRoutineCard: View {
    let routine: Routine
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.accent.opacity(0.15))
                    .frame(width: 30, height: 30)
                
                Image(systemName: "music.note")
                    .foregroundStyle(.accent.opacity(0.7))
                    .font(.system(size: 14, weight: .semibold))
            }
            
            VStack(spacing: 4) {
                Text(routine.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.mainText)
                    .fixedSize(horizontal: false, vertical: true)
                   
                    .multilineTextAlignment(.center)
                
             
            }
          
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(routineCardBackground)
        .customBorderStyle()
    }
}


struct RoutineCardView: View {
    
    let off: Double
    let routine: Routine
    
    var body: some View {
        
      
           
          
            HStack(spacing: 12) {
                
                ZStack {
                    Circle()
                        .fill(Color.accent.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "music.note")
                        .foregroundStyle(.accent.opacity(0.7))
                        .font(.system(size: 20, weight: .semibold))
                    
                    
                    
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(routine.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.mainText)
                    
                    Text(routine.routineDescription)
                        .font(.footnote)
                        .foregroundStyle(Color.mainText.opacity(0.6))
                        .lineLimit(2)
                        .offset(y: -8)
                    
                    
                }
                .frame(height: 50)
                
                Spacer()
                
                
            
            
        }
        
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(routineCardBackground)
        .customBorderStyle()
        
     
    }
}



#Preview {
    let container = Routine.preview
    
    RoutineContainerView()
        .modelContainer(container)
}

#Preview {
    
    RoutineContainerView()
       
    
}






