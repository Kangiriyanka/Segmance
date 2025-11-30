import SwiftUI

struct ExportView: View {
    
    @State private var exportFileURL: URL?
    @State private var isShowingExporter: Bool = false
    let exportTypes = ["HTML", "Markdown"]
    @State private var exportType = "Markdown"
    var routines: [Routine]
    
    var body: some View {
            VStack(spacing: 12) {
                Text("Export format").font(.subheadline).foregroundStyle(.secondary)
                Picker("", selection: $exportType) {
                    ForEach(exportTypes, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
                
                Button {
                    isShowingExporter = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                 
                      
                }
            
            }
            .padding()
    
            .buttonStyle(PressableButtonStyle())
           
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
    
    
    // MARK: - Export Functions
    func exportRoutinesToHTML(_ routines: [Routine]) -> String {
        var export = "<style>body{font-family:-apple-system;}</style>"
        for routine in routines {
            export += "<h1>\(routine.title)</h1>"
            export += "<p>\(routine.routineDescription)</p>"
            for part in routine.parts {
                export += "<h2>\(part.title)</h2>"
                for move in part.moves {
                    export += "<h3>\(move.title) — \(move.type!.name)</h3>"
                    export += "<p>\(move.details)</p>"
                }
            }
        }
        return export
    }
    
    func exportRoutinesToMarkdown(_ routines: [Routine]) -> String {
        var export = ""
        for routine in routines {
            export += "# \(routine.title)\n\n\(routine.routineDescription)\n\n"
            for part in routine.parts {
                export += "## \(part.order). \(part.title)\n\n"
                for move in part.moves {
                    export += "### \(move.title)"
                    if let typeName = move.type?.name { export += " — \(typeName)" }
                    export += "\n\(move.details)\n\n"
                }
            }
        }
        return export
    }
}


#Preview {
    let routines: [Routine] = [Routine.fifthExample]
    
    ExportView(routines: routines)
       
  
}
