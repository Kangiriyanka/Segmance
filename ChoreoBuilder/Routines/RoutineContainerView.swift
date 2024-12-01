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
    @Query(sort: \Routine.title) var routines: [Routine]
    
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
                    NavigationLink(destination: RoutineView(routine: routine).navigationBarBackButtonHidden(true)) {
                        VStack(alignment: .trailing) {
                            Text("\(routine.title)")
                                .font(.title3)
                                .foregroundStyle(Color.white)
                                .bold()
                            Text("\(routine.routineDescription)")
                                .foregroundStyle(.black)
                                .font(.caption)
                                .italic()
                                .bold()
                        }
                        .padding(.trailing, 10)
                       
                        .frame(width: 300, height: 100, alignment: .trailing)
                        
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                            
                                .fill(Color.customBlue.gradient.opacity(0.8))
                       
                                 
                        )
                        
                        
                     
                        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 10))
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteRoutine(id: routine.id)
                                
                            } label: {
                                Label("Delete Routine", systemImage: "trash")
                                    
                            }
                            
                            
                            
                        }
                        .shadow(radius: 2, x:3 , y: 0)
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
            }
            .padding()
       
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
    
    
    
    func deleteRoutine(id: UUID) {
        
        let fileManager = FileManager.default
        if let routineToDelete = routines.first(where: { $0.id == id }) {
            routineToDelete.parts.forEach { part in
                
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

#Preview {
    let container = Routine.preview
    
    RoutineContainerView()
        .modelContainer(container)
}





