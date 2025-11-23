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
                    Section {
                        
                        
                        HStack {
                            HStack(spacing: 10) {
                                Image(systemName: "circle.fill")
                                
                                    .foregroundStyle(.accent)
                                    .font(.system(size: 8, weight: .semibold))
                                
                                Text("View all routines")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(Color.mainText)
                                
                                
                                Spacer()
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bubbleStyle()
                        .background(
                            NavigationLink("", destination: AllRoutinesView())
                                .opacity(0)
                        )
                        
                        HStack {
                            Image(systemName: "circle.fill")
                            
                                .foregroundStyle(.accent)
                                .font(.system(size: 8, weight: .semibold))
                            
                            Text("View all move types")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(Color.mainText)
                            
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bubbleStyle()
                        
                        .background(
                            NavigationLink("", destination: AllMoveTypesView())
                                .opacity(0)
                        )
                        
                        HStack {
                            
                            Image(systemName: "circle.fill")
                                .foregroundStyle(.accent)
                                .font(.system(size: 8, weight: .semibold))
                            
                            Text("Export Format")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(Color.mainText)
                            
                            
                            Picker("", selection: $exportType) {
                                ForEach(exportTypes, id: \.self) { Text($0) }
                            }
                            
                            
                            
                        }
                        .bubbleStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                    } header: {
                        HStack {
                            Text("General")
                            Spacer()
                            exportButton
                        }
                    }
                    
                    Section {
                        
                        HStack {
                            HStack(spacing: 10) {
                                Image(systemName: "circle.fill")
                                
                                    .foregroundStyle(.accent)
                                    .font(.system(size: 8, weight: .semibold))
                                
                                Text("About Choreobuilder")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(Color.mainText)
                                
                                
                                Spacer()
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bubbleStyle()
                        .background(
                            NavigationLink("", destination: AboutView())
                                .opacity(0)
                        )
                        
                        
                        
                        
                    } header: {
                        
                        HStack {
                            Text("About")
                            Spacer()
                        
                        }
                        
                        
                        
                    }
                }
                
            
                
                
                
                
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .background(backgroundGradient)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var exportButton: some View {
        Button {
            isShowingExporter = true
        } label: {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.mainText)
                .frame(maxHeight: 30)
                .padding()
                .background(
                    Circle()
                        .fill(Color.routineCard)
                )
        }
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 3)
        .fileExporter(
            isPresented: $isShowingExporter,
            document: TextDocument(text: exportType == "Markdown" ? exportRoutinesToMarkdown(routines) : exportRoutinesToHTML(routines)),
            contentType: exportType == "Markdown" ? .plainText : .html
        ) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
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
}

#Preview {
    let container = Routine.preview
    OptionsView()
        .modelContainer(container)
}
