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
    @State private var routinePendingDeletion: Routine? = nil
    @Query(sort: \Routine.title) var routines: [Routine]
    @Environment(\.colorScheme) var colorScheme
 
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                if routines.isEmpty {
                    
                    ContentUnavailableView {
                        Label("No routines added", systemImage: "music.quarternote.3")
                    } description: {
                        Text("Add your first routine by tapping the \(Image(systemName: "figure.dance")) button.").padding([.top], 5)
                    }
                    
                    
                    
                    
                }
                else {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(routines) { routine in
                            NavigationLink(destination: RoutineView(routine: routine) .navigationBarBackButtonHidden(true) ) {
                                
                                RoutineCardView(routine: routine)
                                    .navigationBarBackButtonHidden(true)
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
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    .padding()
                    // MARK: Screen Background
                    .background(
                        backgroundGradient
                    )
                    
                    
                   
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                }
            
            .navigationTitle("Routines")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItemGroup {
                    
                    
                    
                    Button {
                        showingUploadRoutineSheet.toggle()
                    } label: {
                        Image(systemName: "figure.dance")
                            .font(.system(size: 18, weight: .semibold))
                        
                        
                    }
                }
            } 
            
            .sheet(isPresented: $showingUploadRoutineSheet) {
                UploadRoutineView()
                    .background(backgroundGradient.opacity(0.9))
            }
        }
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
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "music.note")
                    
                    .font(.system(size: 16, weight: .semibold))
                
                Text(routine.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.mainText)
                    
                
                Spacer()
            }

            Text(routine.routineDescription)
                .font(.subheadline)
                .foregroundStyle(Color.mainText).opacity(0.5)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
                
            
            Spacer()
        }
        
   
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
              
            cardBackground
                       
                        
                
            )
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






