//
//  EditRoutineView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/04/23.
//

import SwiftUI
import SwiftData

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
    @State private var characterLimit: Int = 25
    @State private var draggedPart: Part?
    @State private var isPresentingConfirm: Bool = false
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
                            Text("Details").font(.headline)
                        }
                        Spacer()
                        Button {
                            if validateDetails() {
                                routine.title = title
                                routine.routineDescription = description
                                routine.parts = parts
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                        }
                        .buttonStyle(PressableButtonStyle())
                        
                    }
                    
                    Divider()
                    TextField("Enter a title", text: $title)
                        .bubbleStyle()
                        .limitText($title, to: characterLimit)
                        .focused($isFocused)
                    
                    
                    TextField("Enter a short description", text: $description)
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
                        Text("Rename & Arrange").font(.headline)
                        Spacer()
                    }
                    
                    .padding()
                    
                    Divider()
                    
                    ScrollViewReader { proxy in
                        ScrollView {
                            if parts.isEmpty {
                                ContentUnavailableView {
                                    Label("No parts", systemImage: "music.note")
                                } description: {
                                    Text("This routine has no parts").padding([.top], 5)
                                }
                            }
                            
                            ForEach($parts) { $part in
                                UploadedFileView(partName: $part.title)
                                    .id(part.id)
                                    .focused($focusedPartID, equals: part.id)
                                    .onDrag {
                                        draggedPart = part
                                        return NSItemProvider()
                                    }
                                    .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: part, items: $parts, draggedItem: $draggedPart))
                            }
                            
                            Spacer().frame(height: 1)
                        }
                        
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
            .background(backgroundGradient)
            .alert(errorTitle, isPresented: $showingError) {
            } message: {
                Text(errorMessage)
            }
            
            
            .navigationTitle("Edit \(routine.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            isPresentingConfirm = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .confirmationDialog("Deleting this choreography will erase all of its content. Are you sure?", isPresented: $isPresentingConfirm) {
                        Button("Delete permanently", role: .destructive) {
                            deleteRoutine(id: routine.id)
                        }
                    }
                }
            }
            
            
            
        }
       
       
        
        
    }
    
    init(routine: Routine) {
        self.routine = routine
        var copiedParts: [Part] = []
        routine.parts.forEach { copiedParts.append($0.copy()) }
        
        _title = .init(initialValue: routine.title)
        _description = .init(initialValue: routine.routineDescription)
        _parts = .init(initialValue: copiedParts.sorted { $0.order < $1.order })
    }
    
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
            inputError(title: "Description Error", message: "Description cannot be empty.")
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
