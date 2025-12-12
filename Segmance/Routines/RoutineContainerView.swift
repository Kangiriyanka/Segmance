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
    @Query(sort: \Routine.title) var routines: [Routine]
    @Environment(\.colorScheme) var colorScheme
    
    var filteredRoutines: [Routine] {
               if searchText.isEmpty {
                   return routines
               }
        return routines.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    

    
    var body: some View {
        
        NavigationStack {
            
            
        
            VStack {
                
                HStack(spacing: 0) {

                    CustomSearchBar(
                        text: $searchText,
                        placeholder: "Search routines"
                    )
                    .contentShape(Rectangle())
                 
                  
                    

                    addRoutineButton
                      
                }
                .offset(y: -20)
                .sheet(isPresented: $showingUploadRoutineSheet) {
                    UploadRoutineView()
                        .background(noSinBackgroundGradient.opacity(0.9))
                }
               
                
                
                
              
                
                Group {
                    if filteredRoutines.isEmpty {
                        
                        ContentUnavailableView {
                            Label("No routines found", systemImage: "music.quarternote.3")
                        } description: {
                            Text("Add your first one by tapping the \(Image(systemName: "figure.dance")) button.").padding([.top], 5)
                        }
                        
                        
                        
                        
                    }
                    else {
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(Array(filteredRoutines.enumerated()), id: \.element.id) { index, routine in
                                NavigationLink(destination: RoutineView(routine: routine)
                                                .navigationBarBackButtonHidden()) {
                                                    RoutineCardView(off: Double(index), routine: routine)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(NavButtonStyle())
                            }
                        }
                       
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
        .padding(5)
        .buttonStyle(PressableButtonStyle())
        .contentShape(Rectangle())
       
        
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
                
                VStack(alignment: .leading, spacing: 6) {
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






