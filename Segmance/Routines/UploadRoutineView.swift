//
//  UploadFileView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/09.
//

import SwiftUI
import TipKit

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
    @State private var reviewManager = ReviewManager()
    let tip = UploadTip(customText: "Hold and drag to reorder your files.")
    
    @FocusState private var isFocused: Bool
    @State private var scrollTarget: UUID?
    @FocusState private var focusedFileID: UUID?
    @AppStorage("hasUploaded") var hasUploaded: Bool = false
    
   
    
    
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
                        Text("Routine Details").font(.headline)
                    }
                   
                }
                Divider()
                
                
                
                
      
                TextField("Enter a title", text: $routineTitle)
                    .bubbleStyle()
                    .limitText($routineTitle, to: characterLimit)
                    .focused($isFocused)
                
              
                TextField("Enter a subtitle", text: $routineDescription)
                    .bubbleStyle()
                    .limitText($routineDescription, to: characterLimit)
                    .focused($isFocused)
                
                
            }
            .padding()
           
                .background(shadowOutline)
            
            
            
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.audio], allowsMultipleSelection: true) { result in
                
                switch result {
                case .success(let urls):
                    for url in urls {
                        let fileName = url.lastPathComponent
                        
                       
                        // Skip duplicates
                        if selectedFiles.contains(where: { $0.URL.lastPathComponent == fileName }) {
                            continue
                        }
                        
                        selectedFiles.append(FileItem(URL: url, fileTitle: (fileName as NSString).deletingPathExtension))
                    }
               
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
                        Text("Ordered Parts").font(.headline)
                            .popoverTip(tip)
                        
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
                            
                            
                            HStack {
                                Button {
                                    // Dismiss keyboard if sharing
                                    isFocused = false
                                    focusedFileID = nil
                                    isImporting = true
                                } label: {
                                    
                                    
                                    Image(systemName: "square.and.arrow.down")
                                    
                                    
                                    
                                    
                                }
                                
                                .buttonStyle(PressableButtonStyle())
                                
                                
                                addButton
                                    
                                
                            }
                            
                            
                          
                               

                            
                        }
                         
                        

                            
                            
                    }
                    Spacer()

                    
                    
                }
                .padding()
                Divider()
                ScrollViewReader { proxy in
                    ScrollView {
                        
                        
                        
                        if selectedFiles.isEmpty {
                            
                            ContentUnavailableView {
                                Label("Import Audio", systemImage: "music.note")
                            }  description: {
                                Text("Upload audio files with the \(Image(systemName: "square.and.arrow.down")) button. When finished reordering the files, tap \(Image(systemName: "plus.circle")) to add the routine. ")
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(2) // optional for readability
                                    .padding(.top, 5)
                            }

                        }
                        
                        
                        
                      
                        ForEach($selectedFiles) { $file in
                                
                                
                            UploadedFileView(partName: $file.fileTitle) {
                                withAnimation(.smoothReorder) {
                                    selectedFiles.removeAll { $0.id == file.id }
                                }
                            }
                         
                                
                                .id(file.id)
                                .focused($focusedFileID, equals: file.id)
                               
        
                                .onDrag {
                                    draggedFile = file
                                    // Provide some identifiable content for the drag
                                    return NSItemProvider()
                                } 
                                
                                .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: file, items: $selectedFiles, draggedItem: $draggedFile))
                           
                                
                                
                            }
                        .onAppear {
                        
                            
                            
                            
                           
                           selectedFiles = selectedFiles.sorted(by: {$0.fileTitle < $1.fileTitle})
                            
                           
                        }
                        .onChange(of: selectedFiles) { oldValue, newValue in
                            
                            // First upload
                            if oldValue.isEmpty && !newValue.isEmpty {
                                Task {
                                    await UploadTip.setUploadEvent.donate()
                                }
                            }
                        }
                     
                        // For the focused view to work.
                        Spacer().frame(height: 10)
                        
                    }
                  
                    // MARK: - Saviour Code
                    // You need this otherwise to have the whole UploadedFileView show
                    .contentMargins(.vertical, 20)
                
                    .scrollIndicators(.hidden)
                    .clipped()
                    .onChange(of: focusedFileID) { _, newValue in
                        
                        if let id = newValue {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    proxy.scrollTo(id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                }
                
                
                 
                    
                   
                 
                    
            
               
                
            }
            
           
            .background(shadowOutline)
            .offset(y: 15)
            
            // Mark: Add Button
           
            
         
            
            
            
            
            
            
            
        }
       
        .frame(width: 370)
        .padding(.horizontal, 30)
        .padding(.vertical, 50)
     
        
    }
       
       
    private var addButton: some View {
        
        Button {
            
            // Create a Routine without parts
            addRoutine()
            // Copying the files to the documents directory, we add the destinationURL of those files to every part
            
            for (index,file) in selectedFiles.enumerated() {
                copyFileToDocuments(file: file, order: index+1)
            }
            
            modelContext.insert(newRoutine ?? Routine(title:"", routineDescription: ""))
            // Create 20 routines to request a review
            reviewManager.incrementActionCount()
            
            dismiss()
        } label: {
            
           
            Image(systemName: "plus.circle")
                
            
           
            
            
            
        }
       
        .disabled(!areFilesUploaded() || !areFieldsFilled() || areFilenamesEmpty())
        .buttonStyle(PressableButtonStyle(isDisabled: !areFilesUploaded() || !areFieldsFilled() || areFilenamesEmpty()))
     
    }

    
    // Returns True if the fields are not empty
    private func areFieldsFilled() -> Bool {
        
        return !routineTitle.isEmpty && !routineDescription.isEmpty
    }
    
    private func areFilesUploaded() -> Bool {
        return !selectedFiles.isEmpty
    }
    
    private func areFilenamesEmpty() -> Bool {
        for file in selectedFiles {
            let trimmedPartTitle = file.fileTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedPartTitle.isEmpty {
               
                return true
            }
        }
        return false
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
        .task { try? Tips.configure([
            .datastoreLocation(.applicationDefault)
        ])}
    
}

