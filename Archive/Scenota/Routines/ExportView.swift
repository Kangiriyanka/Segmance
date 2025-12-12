import SwiftUI

struct ExportView: View {
    
    @State private var exportFileURL: URL?
    @State private var isShowingExporter: Bool = false
    let exportTypes = ["HTML", "Markdown"]
    @State private var exportType = "HTML"
    var routines: [Routine]
    @Namespace var ns
    
    
    
    var body: some View {
       
          
            
            VStack {
              
                HStack {
                    ForEach(exportTypes, id: \.self) { exp in
                        
                        Button() {
                            
                            exportType = exp
                            
                        } label: {
                            GeoCard(name: exp, font: .headline, isTapped: exp == exportType, width: 90, height: 20, namespace: ns)
                        }
                    }
                }
                
                Divider().padding()
               
            
                Button {
                    isShowingExporter = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                    
                    
                }
              
             
                .buttonStyle(PressableButtonStyle())
                .scaleEffect(1.5)
             
                
             
                
            }
         
            
            
            
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
        var export = """
        <style>
            :root {
                --routine-color: #5B8FF9;
                --part-color: #5BD8A6;
                --move-color: #F6BD16;
                --text-color: #222;
                --bg: #ffffff;
                --soft-bg: #fafafa;
            }

            body {
                font-family: -apple-system, Helvetica, Arial, sans-serif;
                padding: 28px;
                line-height: 1.55;
                background: var(--soft-bg);
                color: var(--text-color);
            }

            h1 {
                font-size: 32px;
                font-weight: 700;
                margin-top: 40px;
                margin-bottom: 16px;
                color: var(--routine-color);
            }

            h2 {
                font-size: 22px;
                font-weight: 600;
                margin-top: 24px;
                margin-bottom: 10px;
                color: var(--routine-color);
            }

            h3 {
                font-size: 18px;
                font-weight: 600;
                margin-top: 14px;
                margin-bottom: 4px;
                
            }

            p {
                font-size: 16px;
                margin-bottom: 12px;
                background: var(--bg);
                padding: 10px 14px;
                border-radius: 10px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            }

            .part-block {
                padding: 4px 0 12px 0;
                margin-bottom: 18px;
            }
        
        

            .move-block {
                margin-left: 12px;
            }

            hr {
                margin: 32px 0;
                border: none;
                height: 1px;
                background: rgba(0,0,0,0.08);
            }
        </style>
        """
        
        for routine in routines {
            export += "<h1>\(routine.title)</h1>"
            export += "<span class='routine-description'>\(routine.routineDescription)</span>"
        

            for part in routine.parts {
                export += "<div class='part-block'>"
                export += "<h2>\(part.title)</h2>"

                for move in part.moves {
                    export += "<div class='move-block'>"
                    export += "<h3>\(move.title) - \(move.type!.name)</h3>"
                    export += "<p>\(move.details)</p>"
                    export += "</div>"
                }
                export += "</div>"
            }

            export += "<hr/>"
        }
        return export
    }
        
        
        func exportRoutinesToMarkdown(_ routines: [Routine]) -> String {
            var export = ""

            for routine in routines {
                export += "# \(routine.title)\n\n"
                export += "\(routine.routineDescription)\n\n"

                for part in routine.parts {
                    export += "## \(part.order). \(part.title)\n\n"

                    for move in part.moves {
                        export += "### \(move.title)"
                        if let typeName = move.type?.name {
                            export += " — \(typeName)"
                        }
                        export += "\n"
                        
                        export += "\(move.details)\n\n"
                    }
                }

                export += "---\n\n"
            }

            return export
        }
}


#Preview {
    let routines: [Routine] = [Routine.fifthExample]
    
    ExportView(routines: routines)
       
  
}
