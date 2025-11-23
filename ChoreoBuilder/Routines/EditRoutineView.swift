//
//  EditRoutineView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/04/23.
//

import SwiftUI

struct EditRoutineView: View {
    
    @Bindable var routine: Routine
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var description: String
    @State private var parts: [Part]
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError: Bool = false
    @State private var characterLimit: Int = 25
    @State private var draggedPart: Part?
    
    @FocusState private var isFocused: Bool
    @FocusState private var focusedPartID: UUID?
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Routine Details").font(.headline)
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
                    .bold()
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                }
                
                Divider()
                TextField("Enter the routine title", text: $title)
                    .limitText($title, to: characterLimit)
                    .focused($isFocused)
                
                Divider()
                TextField("Enter a short description", text: $description)
                    .limitText($description, to: characterLimit)
                    .focused($isFocused)
            }
            .padding()
            .background(shadowOutline)
         
       
            
            VStack {
                HStack {
                    Text("Arrange & Rename Parts").font(.headline)
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
        }
       
        .frame(width: 370)
       
        .padding()
        .background(backgroundGradient)
        .alert(errorTitle, isPresented: $showingError) {
        } message: {
            Text(errorMessage)
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
    
    private func validateDetails() -> Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            inputError(title: "Title Error", message: "Title cannot be empty")
            return false
        }
        
        guard !trimmedDescription.isEmpty else {
            inputError(title: "Description Error", message: "Description cannot be empty")
            return false
        }
        
        for part in parts {
            let trimmedPartTitle = part.title.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedPartTitle.isEmpty {
                inputError(title: "Part Error", message: "Each part must have a title")
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
