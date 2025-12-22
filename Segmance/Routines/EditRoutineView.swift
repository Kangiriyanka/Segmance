//
//  EditRoutineView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/04/23.
//

import SwiftUI
import SwiftData

// This is a way to only re-render the part you want to delete
// Re-render the body of only the part, and not the whole ScrollView



struct PartRowView: View {
    @Binding var part: Part
    let onDelete: () -> Void
    @State private var showingDeleteConfirm = false
    
    var body: some View {
        UploadedFileView(partName: $part.title) {
            showingDeleteConfirm = true
        }
        .confirmationDialog(
            "Are you sure you want to remove this part?",
            isPresented: $showingDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Remove Part \(part.title)", role: .destructive) {
                onDelete()
            }
        }
    }
}

struct EditRoutineView: View {
    
    @Bindable var routine: Routine
    @Query var routines: [Routine]
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var description: String
    @State private var parts: [Part]
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError: Bool = false
    @State private var characterLimit: Int = 30
    @State private var draggedPart: Part?
    @State private var isPresentingConfirm: Bool = false
    @State private var showingSaveConfirm: Bool = false
    @State private var isImporting: Bool = false
    @State private var error: Error?
    @State private var tempFiles: [UUID: URL] = [:]
    
    
    
    @Environment(\.modelContext)  var modelContext
    
    @FocusState private var isFocused: Bool
    @FocusState private var focusedPartID: UUID?
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 13) {
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "note.text")
                                .foregroundStyle(.accent).opacity(0.7)
                                .font(.system(size: 16, weight: .semibold))
                            Text("Routine Details").font(.headline)
                        }
                        Spacer()
                        
                        
                    }
                    
                    Divider()
                    TextField("Enter a title", text: $title)
                        .bubbleStyle()
                        .limitText($title, to: characterLimit)
                        .focused($isFocused)
                    
                    
                    TextField("Enter a subtitle", text: $description)
                        .bubbleStyle()
                        .limitText($description, to: characterLimit)
                        .focused($isFocused)
                }
                .padding()
                .background(shadowOutline)
                
                
                
                VStack {
                    HStack(spacing: 6) {
                        Image(systemName: "rectangle.stack")
                            .foregroundStyle(.accent).opacity(0.7)
                            .font(.system(size: 16, weight: .semibold))
                        Text("Ordered Parts").font(.headline)
                        Spacer()
                        uploadButton
                        confirmationButton
                    }
                    
                    .padding()
                    
                    
                    Divider()
                    
                    ScrollViewReader { proxy in
                        ScrollView {
                            if parts.isEmpty {
                                ContentUnavailableView {
                                    Label("No parts", systemImage: "music.note")
                                } description: {
                                    Text("Upload audio files before continuing. Navigating back from this screen discards all changes.").padding([.top], 5)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            
                            ForEach($parts) { $part in
                                PartRowView(part: $part, onDelete: {
                                    withAnimation(.smoothReorder) {
                                        parts.removeAll { $0.id == part.id }
                                    }
                                })
                                
                                
                                .id(part.id)
                                .focused($focusedPartID, equals: part.id)
                                .onDrag {
                                    draggedPart = part
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: part, items: $parts, draggedItem: $draggedPart))
                            }
                            
                            
                            Spacer().frame(height: 10)
                        }
                        
                        .contentMargins(.vertical, 20)
                        .scrollIndicators(.hidden)
                        .clipped()
                        .onChange(of: focusedPartID) { _, newValue in
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
            .padding(.vertical, 35)
            .background(noSinBackgroundGradient)
            .alert(errorTitle, isPresented: $showingError) {
            } message: {
                Text(errorMessage)
            }
            
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.audio], allowsMultipleSelection: true) { result in
                
                switch result {
                case .success(let urls):
                    for url in urls {
                        
                        let fileName = url.lastPathComponent
                        
                        
                        // Check if file already exists in parts
                        if parts.contains(where: {
                            let components = $0.fileName.components(separatedBy: "_")
                            let fileNameWithoutRoutine = components.dropFirst().joined(separator: "_")
                            print(fileNameWithoutRoutine)
                            return fileNameWithoutRoutine == fileName
                        }) {
                            continue
                        }
                        
                        
                        
                        if tempFiles.values.contains(where: { $0.lastPathComponent == fileName }) {
                            continue
                        }
                        
                        // We can't directly use the documentsURL right now, because it means w would have to upload the files.
                        let newPart = Part(
                            title: (url.lastPathComponent as NSString).deletingPathExtension,
                            fileName: "",
                            order: parts.count + 1
                        )
                        parts.append(newPart)
                        // URL is the full filepath
                        tempFiles[newPart.id] = url
                    }
                    
                    
                    
                    
                case .failure(let err):
                    error = err
                    print("Error selecting files: \(err.localizedDescription)")
                }
                
            }
            
            
            
            .navigationTitle("Edit \(routine.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Delete Routine", systemImage: "trash", role: .destructive) {
                            isPresentingConfirm = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    
                }
            }
            .confirmationDialog(
                "Routine Deletion",
                isPresented: $isPresentingConfirm
            ) {
                Button("Delete permanently", role: .destructive) {
                    deleteRoutine(id: routine.id)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Deleting this routine will erase all of its content. Are you sure?")
            }
        
            
            
            
            
            
        }
       
       
        
        
    }
    
    var uploadButton: some View {
        Button {
            isImporting = true
        } label: {
            
            
            Image(systemName: "square.and.arrow.down")
            

            
        }
        
        .buttonStyle(PressableButtonStyle())
        
    }
    
    var confirmationButton: some View {
        Button {
            showingSaveConfirm = true
        } label: {
            Image(systemName: "checkmark.circle")
        }
        .disabled(parts.isEmpty)
        .confirmationDialog(
            "Are you sure you want to save changes?",
            isPresented: $showingSaveConfirm,
            titleVisibility: .visible
        ) {
            Button("Save", role: .none) {
                if validateDetails() {
                    routine.title = title
                    routine.routineDescription = description
                    
                    syncFiles()
                    for (index, part) in parts.enumerated() {
                        part.order = index + 1
                    }
                    routine.parts = parts
                    
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .buttonStyle(PressableButtonStyle(isDisabled: parts.isEmpty))
    }
    
    
    
    init(routine: Routine) {
        self.routine = routine
        var copiedParts: [Part] = []
        routine.parts.forEach { copiedParts.append($0.copy()) }
        
        _title = .init(initialValue: routine.title)
        _description = .init(initialValue: routine.routineDescription)
        _parts = .init(initialValue: copiedParts.sorted { $0.order < $1.order })
     
    }
    
    
    private func copyFileToDocuments(url: URL) -> URL? {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let destinationURL = documentsURL.appendingPathComponent("\(routine.title)_\(url.lastPathComponent)")
        let accessGranted = url.startAccessingSecurityScopedResource()
        
        guard accessGranted else { return nil }
        defer { url.stopAccessingSecurityScopedResource() }
        
        do {
            if !fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.copyItem(at: url, to: destinationURL)
            }
            return destinationURL
        } catch {
           
            return nil
        }
    }
    /// Delete the removed parts
    /// Add new parts from tempFiles
    /// Rename the files if the routine title changes
    /// Clear temp files
    ///
    /// 1. User renaming the part has no effect on the filename
    private func syncFiles() {
        let fileManager = FileManager.default
        
     
        let removedParts = routine.parts.filter { oldPart in
            !parts.contains(where: { $0.id == oldPart.id })
        }
        
        for part in removedParts {
            if let partURL = part.location {
                try? fileManager.removeItem(at: partURL)
            }
        }
        

        for part in parts {
            if let tempURL = tempFiles[part.id] {
                if let finalURL = copyFileToDocuments(url: tempURL) {
                    part.fileName = finalURL.lastPathComponent
                }
            }
        }
        
        for part in parts {
            if let oldURL = part.location {
                // Sample.mp3
                let bareFileName = oldURL.lastPathComponent.components(separatedBy: "_").dropFirst().joined(separator: "_")
                // mp3
                let fileExtension = (bareFileName as NSString).pathExtension
                
                // New routine title was changed before calling syncFiles
                let newFileName = "\(routine.title)_\(part.title).\(fileExtension)"
               
                
                if part.fileName != newFileName {
                    let newURL = oldURL.deletingLastPathComponent().appendingPathComponent(newFileName)
                    try? fileManager.moveItem(at: oldURL, to: newURL)
                    part.fileName = newFileName
                }
            }
        }
        
        tempFiles.removeAll()
    }
    
    
    /// Deletes the routines and associated parts
    /// It works well for this edge case: renaming a routine and uploading the same file
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
        dismiss()
        
        
        
        
    }
    
    private func validateDetails() -> Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            inputError(title: "Title Error", message: "Title cannot be empty.")
            return false
        }
        
        guard !trimmedDescription.isEmpty else {
            inputError(title: "Subtitle Error", message: "Subtitle cannot be empty.")
            return false
        }
        
        for part in parts {
            let trimmedPartTitle = part.title.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedPartTitle.isEmpty {
                inputError(title: "Part Error", message: "Each part must have a title.")
                return false
            }
        }
        
        return true
    }
    
    private func inputError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}



#Preview {
    let sample = Routine.firstExample
    EditRoutineView(routine: sample)
}
