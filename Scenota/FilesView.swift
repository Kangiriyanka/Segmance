//
//  FilesView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/13.
//

import SwiftUI


struct FilesView: View {
    
    @State private var files : [String] = []
    @State private var currentError: FilesViewError? = nil
    @State private var isShowingError: Bool = false
    @Environment(\.modelContext)  var modelContext
    
    var body: some View {
        
        
        NavigationStack {
            ScrollView {
                Button("Show Files") {
                    showFiles()
                }
                .bubbleStyle()
                Text(verbatim: files.joined(separator: "\n"))
                
                    .toolbar {
                        Button("Clear directory") {
                            clearDocumentsDirectory()
                        }
                    }
                    .toolbar {
                        Button("Delete Routine Model") {
                            deleteAllModels()
                        }
                    }
                    
            }
            .alert("Error", isPresented: $isShowingError, presenting: currentError) { _ in
                Button("OK", role: .cancel) { }
            } message: { error in
                Text(error.localizedDescription)
            }
        }
        
        
     
       
        
        
        
    }
    
    
    
    private func deleteAllModels() {
        do {
            try modelContext.delete(model: Routine.self)
        } catch {
            currentError = .deleteAllModelsFailed(underlying: error)
            isShowingError = true
        }
    }
    
    
    private func clearDocumentsDirectory() {
        
        let fileManager = FileManager.default
        
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            currentError = .documentsDirectoryNotFound
            isShowingError = true
            return
        }
      
        var fileURLs: [URL] = []
         do {
             fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
         } catch {
             currentError = .listDocumentsFailed(underlying: error)
             isShowingError = true
             return
         }
   
        for fileURL in fileURLs {
            print("URL to delete: \(fileURL)")
            do {
                try fileManager.removeItem(at: fileURL)
            }
            catch {
                currentError = .deleteFileFailed(fileName: fileURL.lastPathComponent, underlying: error)
                isShowingError = true
            }
        }
    }
    
     
     
        
    
    func showFiles() {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
       
        
        do {
            let items = try fileManager.contentsOfDirectory(atPath: documents.path)
            files = items
        } catch {
            currentError = .readDirectoryFailed(underlying: error)
            isShowingError = true
        }
    }
}
    

    


#Preview {
    FilesView()
}

