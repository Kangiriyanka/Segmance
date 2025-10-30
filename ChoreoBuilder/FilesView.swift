//
//  FilesView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/13.
//

import SwiftUI

struct FilesView: View {
    
    @State private var files : [String] = []
    @Environment(\.modelContext)  var modelContext
    
    var body: some View {
        
        
        NavigationStack {
            Button("Yo") {
                showFiles()
            }
            Text("\(files)")
            
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
        
        
        
    }
    
    
    
    private func deleteAllModels() {
        do {
            try modelContext.delete(model: Routine.self)
        } catch {
            print("Failed to delete all routines")
        }
    }
    private func clearDocumentsDirectory() {
        
        let fileManager = FileManager.default
        
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not locate the Documents directory.")
            return
        }
      
        let fileURLs = try! fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
   
        for fileURL in fileURLs {
            print("URL to delete: \(fileURL)")
            do {
                try fileManager.removeItem(at: fileURL)
            }
                catch {
                    print("Error: \(error)")
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
            print("Error reading directory contents: \(error.localizedDescription)")
      
        }
    }
}
    

    


#Preview {
    FilesView()
}
