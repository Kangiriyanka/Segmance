//
//  ExportView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/04/15.
//

import SwiftUI
import SwiftData


struct OptionsView: View {
    
    @Query(sort: \Routine.title) var routines: [Routine]
    
    @State private var exportFileURL: URL?
    @State private var isShowingExporter: Bool = false
    let exportTypes = ["HTML", "Markdown"]
    @State private var exportType = "Markdown"
    
    
    
    var body: some View {
        NavigationStack {
            List {
                
                Group {
                    Section("Manage Routines") {
                        
                        NavigationLink(destination: AllRoutinesView()) {
                            VStack {
                                Text("View all routines")
                            }
                           
                            
                            
                        }
                        .bubbleStyle()
                        
                        
                        
                    }
                    
                    
                    
                    
                    Section("Manage Move Types") {
                        
                        NavigationLink(destination: AllMoveTypesView()) {
                            VStack {
                                Text("View all move types")
                            }
                        }
                        .bubbleStyle()
                        
                        
                        
                    }
                    
                    
                    
                    Section("Export Routines") {
                        Picker("Choose an export type", selection: $exportType) {
                            ForEach(exportTypes, id: \.self) {
                                Text($0)
                            }
                            
                        }
                        Button("Export Routines") {
                            isShowingExporter = true
                        }
                        .fileExporter(
                            isPresented: $isShowingExporter,
                            document: TextDocument(text: exportType == "Markdown" ? exportRoutinesToMarkdown(routines) : exportRoutinesToHTML(routines)),
                            contentType: exportType == "Markdown" ? .plainText  : .html
                        ) { result in
                            switch result {
                            case .success(let url):
                                print("Saved to \(url)")
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
         
            .background(
                backgroundGradient
                )
          
            
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
    

    func exportRoutinesToHTML(_ routines: [Routine]) -> String {
        
        var export = ""
        
        for routine in routines {
            export += "<h1>\(routine.title)</h1>\n"
            export += "<p>\(routine.routineDescription)</p>\n"
            
            for part in routine.parts {
                export += "<h2>\(part.order) \(part.title)</h2>\n"
                
                for move in part.moves {
                    export += "<h3>\(move.title)</h3>"
                    export += "<p>\(move.details)</p>\n\n"
                }
            }
        }
        
        return export
    }
    func exportRoutinesToMarkdown(_ routines: [Routine]) -> String {
        
        
        
        var export = ""
        
        for routine in routines {
            export += "# \(routine.title)\n"
            export += "## \(routine.routineDescription)\n"
            
            for part in routine.parts {
                export += "### \(part.order) \(part.title)\n"
                
                for move in part.moves {
                    export += "#### \(move.title)\n"
                    export += "\(move.details)\n"
                }
            }
        }
        
        return export
        
    }
    

       
    


#Preview {
    let container = Routine.preview
    OptionsView()
        .modelContainer(container)
        
}
