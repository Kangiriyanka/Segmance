//
//  EditRoutineView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/04/23.
//

import SwiftUI

struct EditRoutineView: View {
    
    @Bindable var routine: Routine
    @Environment(\.dismiss) private var dismiss
    @State private var title : String
    @State private var description : String
    @State private var parts: [Part]
  
   
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Edit title and description") {
                    
                    TextField("Title and description", text: $title)
                    TextField("description", text: $description)
                    
                }
                
                Section("Arrange and rename parts") {
                    List {
                        ForEach($parts, id: \.id) { $part in
                            TextField("Enter a new part name", text: $part.title)
                        }
                        .onMove(perform: move)
                    }
                   
                   
                    
                    
                }
                
            }
            .onAppear {
                
                parts = routine.parts.map { $0.copy() }.sorted { $0.order < $1.order }
            }
            .navigationBarTitle("Edit \(routine.title)", displayMode: .inline )
            .toolbar {
                ToolbarItem {
                    
                    Button("Save", systemImage: "checkmark.circle") {
                        
                        routine.title = title
                        routine.routineDescription = description
                        routine.parts = parts
                        dismiss()
                        
                    }
                    
                    
                }
            }
        }
        
    }
    
    
    init(routine: Routine) {
        self.routine = routine
        var copiedParts : [Part] = []
        routine.parts.forEach { copiedParts.append($0.copy()) }
       
       
        _title = .init(initialValue: routine.title)
        _description = .init(initialValue: routine.routineDescription)
        _parts = .init(initialValue: copiedParts)
    }
    
    
    /// Moves a part within the routine's parts array and updates their order accordingly.
    /// - Parameters:
    ///   - source: The index set representing the original index of the moved part.
    ///   - destination: The index to move the part to.
    func move(from source: IndexSet, to destination: Int) {
        

        guard let sourceIndex = source.first, parts.count > 1 else {
               return
           }
        let movedPart = parts[sourceIndex]
        parts.remove(at: sourceIndex)
        let adjustedDestination = destination > sourceIndex ? destination - 1 : destination
        parts.insert(movedPart, at: adjustedDestination)
        
        for (index, part) in parts.enumerated() {
            part.order = index + 1
        }
    }
    
}
#Preview {
    let sample = Routine.firstExample
    EditRoutineView(routine: sample)
}
