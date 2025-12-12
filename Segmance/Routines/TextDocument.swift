//
//  TextDocument.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/04/18.
//

import SwiftUI
import UniformTypeIdentifiers


struct TextDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.plainText, .html]
    }
    static var writableContentTypes: [UTType] {
        [.plainText, .html]
    }
    
    var text: String = ""
    
    init(text: String) {
        self.text = text
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            text = ""
        }
    }
    
    // Gets called when the system wants to write to our disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}
