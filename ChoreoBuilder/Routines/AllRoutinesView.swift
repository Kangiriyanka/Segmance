//
//  AllRoutinesView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/04/22.
//

import SwiftUI
import SwiftData

struct AllRoutinesView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Routine.title) var routines: [Routine]
    @State private var isPresentingConfirmed: Bool = false
    @State private var searchText = ""
    
    var filteredRoutines: [Routine] {
               if searchText.isEmpty {
                   return routines
               }
        return routines.filter { $0.title.localizedCaseInsensitiveContains(searchText)
            }
    }
    
    
   
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 0) {
                
                CustomSearchBar(text: $searchText, placeholder: "Search choreographies")
                    .padding()
                
                
                Group {
                    if filteredRoutines.isEmpty {
                        
                        ContentUnavailableView {
                            Label("No choreographies found", systemImage: "music.quarternote.3")
                        } description: {
                            Text("Add your first one by tapping the \(Image(systemName: "figure.dance")) button in the Routines tab.").padding([.top], 5)
                        }
                        
                    }
                    else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredRoutines) { routine in
                                    NavigationLink(destination: EditRoutineView(routine: routine)) {
                                        HStack {
                                            Image(systemName: "circle.fill")
                                                .foregroundStyle(.accent.opacity(0.7))
                                                .font(.system(size: 8, weight: .semibold))

                                            Text(routine.title)
                                                .font(.headline.weight(.semibold))
                                                .foregroundStyle(Color.mainText)

                                            Spacer()
                                        }
                                        .bubbleStyle()
                                    }
                                    .buttonStyle(NavButtonStyle())
                                }
                            }
                            .padding()
                        }
                      
                   
                     
                    }
                }
                
                
                
                
                
                
                
                
                
                
            }
        
            // Idea: maybe extract all common text into a single file.
            .navigationTitle("All Choreographies")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background(backgroundGradient)
        }
        .ignoresSafeArea(.keyboard)
       
        
   
       
    }
    
    func deleteAllRoutines() {
        
        let fileManager = FileManager.default
        for routine in routines {
            routine.parts.forEach { part in
                
                if let partURL = part.location {
                    do {
                        try fileManager.removeItem(at: partURL)
                        
                    } catch {
                        print("Error: \(error)")
                    }
                    
                }
                
                
            }
        }
        
        for routine in routines {
            modelContext.delete(routine)
            
        }
        
    }
}

#Preview {
    let container = Routine.preview
    
    AllRoutinesView()
        .modelContainer(container)
  
}
