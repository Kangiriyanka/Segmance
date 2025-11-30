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
                        placeholder: "Search choreographies"
                    )
                    .contentShape(Rectangle())
                 
                  
                    

                    addRoutineButton
                      
                }
                .offset(y: -20)
                .sheet(isPresented: $showingUploadRoutineSheet) {
                    UploadRoutineView()
                        .background(backgroundGradient.opacity(0.9))
                }
               
                
                
                
              
                
                Group {
                    if filteredRoutines.isEmpty {
                        
                        ContentUnavailableView {
                            Label("No routines found", systemImage: "music.quarternote.3")
                        } description: {
                            Text("Add your first routine by tapping the \(Image(systemName: "figure.dance")) button.").padding([.top], 5)
                        }
                        
                        
                        
                        
                    }
                    else {
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(filteredRoutines) { routine in
                                NavigationLink(destination: RoutineView(routine: routine) .navigationBarBackButtonHidden() ) {
                                    
                                    RoutineCardView(routine: routine)
                                        .padding(.vertical, 10)
                                    
                                       
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                routinePendingDeletion = routine
                                                showingConfirmation = true
                                                
                                                
                                            } label: {
                                                Label("Delete Routine", systemImage: "trash")
                                                
                                            }
                                            
                                            
                                            
                                        }
                                     
                                        .confirmationDialog("Are you sure you want to delete this choreography?", isPresented: $showingConfirmation) {
                                            
                                            Button("Delete", role: .destructive) {
                                                if let routine = routinePendingDeletion {
                                                    deleteRoutine(id: routine.id)
                                                    routinePendingDeletion = nil
                                                }
                                            }
                                            Button("Cancel", role: .cancel) {
                                                routinePendingDeletion = nil
                                            }
                                            
                                        } message: {
                                            Text("Are you sure you want to delete this choreography?")
                                        }
                                    
                                    
                                    
                                    
                                    
                                    
                                }   .buttonStyle(NavButtonStyle())
                        
                             
                                
                                
                                
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
        .buttonStyle(PressableButtonStyle())
        .contentShape(Rectangle())
       
        
    }

    
    private func deleteRoutine(id: UUID) {
        
        let fileManager = FileManager.default
        if let routineToDelete = routines.first(where: { $0.id == id }) {
            routineToDelete.parts.forEach
            { part in
                
                if let partURL = part.location {
                    do {
                        try fileManager.removeItem(at: partURL)
                        
                    } catch {
                        print("Error: \(error)")
                    }
                    
                }
                
            }
            modelContext.delete(routineToDelete)
        }
        
        
        
        
    }
    

    
    
    
}





struct RoutineCardView: View {
    let routine: Routine

    var body: some View {
        HStack(spacing: 12) {
        
            ZStack {
                Circle()
                    .fill(Color.accent.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "music.note")
                    .foregroundStyle(.accent)
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
                
              
            }
            
            Spacer()
            
         
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .customBorderStyle()
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
     
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






