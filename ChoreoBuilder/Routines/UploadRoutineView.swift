//
//  UploadFileView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/09.
//

import SwiftUI


struct FileItem: Identifiable, Equatable {
    let id : UUID = UUID()
    let URL : URL
    var fileTitle: String
}


struct UploadRoutineView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var text = ""
    @State private var routineTitle = ""
    @State private var routineDescription = ""
    @State private var newRoutine: Routine?
    @State private var error: Error?
    @State private var isImporting = false
    @State private var selectedFiles: [FileItem] = []
    @State private var draggedFile: FileItem?
    @State private var characterLimit: Int = 25
    
    @FocusState private var isFocused: Bool
    @State private var scrollTarget: UUID?
    @FocusState private var focusedFileID: UUID?
   
    
    
    var body: some View {
        
        
        // User enters the routine title and description
        // Imports the relevant audio files for the routine.
        
        VStack {
            VStack(alignment: .leading,  spacing: 13) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "note.text")
                            .foregroundStyle(.accent).opacity(0.7)
                            .font(.system(size: 16, weight: .semibold))
                        Text("Details").font(.headline)
                    }
                    HStack {
                        
                        #if targetEnvironment(simulator)
                        Button {
                            // Simulate appending a new file
                            let newFile = FileItem(URL: URL(filePath: "/dummy/path2"),
                                                   fileTitle: "" + String(Int.random(in: 10..<10000)))
                            selectedFiles.append(newFile)
                        } label : {
                            Image(systemName: "plus")
                        }
                        #endif
                        
                        Spacer()
                        
                        Button {
                            isImporting = true
                        } label: {
                            
                            
                            Image(systemName: "square.and.arrow.down")
                             
                             
                              

                        }
                       
                        .buttonStyle(PressableButtonStyle())
                      
                           

                        
                    }
                }
                
                
                
                
      
                TextField("Enter the routine title", text: $routineTitle)
                    .bubbleStyle()
                    .limitText($routineTitle, to: characterLimit)
                    .focused($isFocused)
                
              
                TextField("Enter a short description", text: $routineDescription)
                    .bubbleStyle()
                    .limitText($routineDescription, to: characterLimit)
                    .focused($isFocused)
                
                
            }
            .padding()
           
                .background(shadowOutline)
            
            
            
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.audio], allowsMultipleSelection: true) { result in
                
                switch result {
                case .success(let urls):
                    
                    selectedFiles.append(contentsOf: urls.map {FileItem(URL: $0, fileTitle: ($0.lastPathComponent as NSString).deletingPathExtension )})
                    
                    print("Selected files: \(urls)")
                case .failure(let err):
                    error = err
                    print("Error selecting files: \(err.localizedDescription)")
                }
                
            }
            
            
            
            
            VStack {
                HStack {
                    HStack(spacing: 6) {
    
                            Image(systemName: "rectangle.stack")
                                .foregroundStyle(.accent).opacity(0.7)
                                .font(.system(size: 16, weight: .semibold))
                        Text("Rename & Arrange").font(.headline)
                    }
                    Spacer()
                    HStack {
                        
                        Button {
                            
                            // Create a Routine without parts
                            addRoutine()
                            // Copying the files to the documents directory, we add the destinationURL of those files to every part
                            
                            for (index,file) in selectedFiles.enumerated() {
                                copyFileToDocuments(file: file, order: index+1)
                            }
                            
                            modelContext.insert(newRoutine ?? Routine(title:"", routineDescription: ""))
                            dismiss()
                        } label: {
                            
                            Image(systemName: "plus.circle")
                            
                           
                            
                            
                            
                        }
                        // Using a custom button style requires to pass the disabled state
                        // to the custom button style
                        .disabled(!areFilesUploaded() || !areFieldsFilled())
                        .buttonStyle(PressableButtonStyle(isDisabled: !areFilesUploaded() || !areFieldsFilled()))
                     
                        
                
                    }
                    
                    
                }
                .padding()
                Divider()
                ScrollViewReader { proxy in
                    ScrollView {
                        
                        
                        
                        if selectedFiles.isEmpty {
                            
                            ContentUnavailableView {
                                Label("No uploaded music files", systemImage: "music.note")
                            } description: {
                                Text("Once you enter a title and description, you can upload music files. ").padding([.top], 5)
                            }
                        }
                        
                        
                        
                      
                        ForEach($selectedFiles) { $file in
                                
                                
                                UploadedFileView(
                                    partName: $file.fileTitle,
                                    
                                    
                                )
                               
                                .id(file.id)
                                .focused($focusedFileID, equals: file.id)
        
                                .onDrag {
                                    draggedFile = file
                                    return NSItemProvider()
                                }
                                
                                .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: file, items: $selectedFiles, draggedItem: $draggedFile))
                           
                                
                                
                            }
                        .onAppear {
                           selectedFiles = selectedFiles.sorted(by: {$0.fileTitle < $1.fileTitle})
                        }
                            
                        // For the focused view to work.
                        Spacer().frame(height: 1)
                        
                    }
                    .scrollIndicators(.hidden)
                    .clipped()
                    .onChange(of: focusedFileID) { _, newValue in
                        
                        if let id = newValue {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    proxy.scrollTo(id, anchor: .center)
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
           
            .background(shadowOutline)
            .offset(y: 15)
         
            
            
            
            
            
            
            
        }
       
        .frame(width: 370)
        .padding(.horizontal, 30)
        .padding(.vertical, 50)
     
        
    }
       
       
                   

    
    // Returns True if the fields are not empty
    private func areFieldsFilled() -> Bool {
        
        return !routineTitle.isEmpty && !routineDescription.isEmpty
    }
    
    private func areFilesUploaded() -> Bool {
        return !selectedFiles.isEmpty
    }
    
    
    private func addRoutine() {
        let newRoutine = Routine(title: routineTitle, routineDescription: routineDescription)
        self.newRoutine = newRoutine
        
    }
    // Copy from given URLs from fileimporter to Documents Directory
    private func copyFileToDocuments(file: FileItem, order: Int) {
        
        // Initialize the File Manager
        let fileManager = FileManager.default
        
        
        // Get the Documents directory URL
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not locate the Documents directory.")
            return
        }
        
        
        
        // The filename we want copied to our Documents directory
        let destinationURL = documentsURL.appendingPathComponent("\(routineTitle)_\(file.URL.lastPathComponent)")
        
        
        let accessGranted = file.URL.startAccessingSecurityScopedResource()
        // Copy the file to the Documents directory
        // Note that for the trimmer, you don't have to copy the file to the URL, you'd have to use defer.
        
        if accessGranted {
            do {
                if !fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.copyItem(at: file.URL, to: destinationURL)
                   
                } else {
                   
                }
            }   catch {
             
            }
            
            // Add that audio file destination to our newly created Routine
            
            let newPart = Part(title: file.fileTitle, fileName:  destinationURL.lastPathComponent, order: order)
            
            self.newRoutine?.parts.append(newPart)
            file.URL.stopAccessingSecurityScopedResource()
        }
        
        else {
           return
        }
        
        
        
        
    }
    
    
    
    
}

#Preview {
    UploadRoutineView()
    
}
