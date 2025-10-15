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
    @Query(sort: \Routine.title) var routines: [Routine]
    private var backgroundGradient: RadialGradient {
        RadialGradient(
            colors: [Color.customBlue.opacity(0.3), Color.customBlue.opacity(0.5) ],
            center: .topLeading,
            startRadius: 200,
            endRadius: 500
        )
    }
    
    var body: some View {
        
        NavigationStack {
            
            
            if routines.isEmpty {
                
                ContentUnavailableView {
                    Label("No routines added", systemImage: "music.quarternote.3")
                } description: {
                    Text("Add your first routine by tapping the \(Image(systemName: "figure.dance")) button.").padding([.top], 5)
                }
               
                
                
                
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(routines) { routine in
                    NavigationLink(destination: RoutineView(routine: routine)) {
                        
                        RoutineCardView(routine: routine)
                        .contextMenu {
                            Button(role: .destructive) {
                                showingConfirmation = true
                             
                                
                            } label: {
                                Label("Delete Routine", systemImage: "trash")
                                    
                            }
                            
                            
                            
                        }
                        
                        .confirmationDialog("Are you sure you want to delete this choreography?", isPresented: $showingConfirmation) {
                            
                            // You need to put a Button here, not just the function
                            Button("Delete", role: .destructive) {
                                deleteRoutine(id: routine.id)
                            }
                           
                        } message: {
                            Text("Are you sure you want to delete thischoreography?")
                        }
                   
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
            }
            .padding()
            .background(
               backgroundGradient
            )
            
            
       
            .navigationTitle("Routines")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItemGroup {
                    
                    
                    
                    Button {
                        showingUploadRoutineSheet.toggle()
                    } label: {
                        
                        Image(systemName: "figure.dance")
                        
                        
                    }
                }
                
                
                
                
                
                
            }
            
            
            
        }
        
        .sheet(isPresented: $showingUploadRoutineSheet) {
            UploadRoutineView()
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
               
                
                Text(routine.title)
                    .font(.headline.weight(.semibold))
            }

            Text(routine.routineDescription)
                .font(.subheadline)
             
                .lineLimit(2)
            
            Spacer()
        }
        .foregroundStyle(Color.customNavy)
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 110)
        .background(Color.customWhite.opacity(0.9))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.customNavy.opacity(0.1), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 6, y: 3)
    }
}


#Preview {
    let container = Routine.preview
    
    RoutineContainerView()
        .modelContainer(container)
}





