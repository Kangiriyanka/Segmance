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
    @Query var routines: [Routine]
    @State private var isPresentingConfirmed: Bool = false
    @State private var searchText = ""
    
    var filteredRoutines: [Routine] {
               if searchText.isEmpty {
                   return routines
               }
        return routines.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    
   
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 0) {
                
                CustomSearchBar(text: $searchText, placeholder: "Search choreographies")
                    .padding()
                
                
                Group {
                    if filteredRoutines.isEmpty {
                        
                        ContentUnavailableView {
                            Label("No routines found", systemImage: "music.quarternote.3")
                        } description: {
                            Text("Add your first routine by tapping the \(Image(systemName: "figure.dance")) button in the Routines tab.").padding([.top], 5)
                        }
                        
                    }
                    else {
                        List {
                            ForEach(filteredRoutines) { routine in
                                HStack {
                                    NavigationLink(destination: EditRoutineView(routine: routine)) {
                                        HStack {
                                            Text("\(routine.title)")
                                            
                                            Spacer()
                                            Text("\(routine.parts.count)")
                                                .frame(width: 20, height: 20)
                                                .customCircle()
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    .bubbleStyle()
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            
                        }
                    }
                }
                
                
                
                
                
                
                
                
                
                
            }
            .navigationTitle("All Routines")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background(backgroundGradient)
        }
       
        
   
       
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
