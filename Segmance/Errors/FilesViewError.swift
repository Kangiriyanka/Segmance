//
//  FilesViewError.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/11/20.
//

import SwiftUI

enum FilesViewError: LocalizedError, Identifiable {
    var id: String { localizedDescription }

    case documentsDirectoryNotFound
    case deleteAllModelsFailed(underlying: Error)
    case listDocumentsFailed(underlying: Error)
    case deleteFileFailed(fileName: String, underlying: Error)
    case readDirectoryFailed(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .documentsDirectoryNotFound:
            return "Could not locate the Documents directory."
        case .deleteAllModelsFailed(let underlying):
            return "Failed to delete all routines: \(underlying.localizedDescription)"
        case .listDocumentsFailed(let underlying):
            return "Failed to list documents directory: \(underlying.localizedDescription)"
        case .deleteFileFailed(let fileName, let underlying):
            return "Failed to delete file: \(fileName) — \(underlying.localizedDescription)"
        case .readDirectoryFailed(let underlying):
            return "Error reading directory contents: \(underlying.localizedDescription)"
        }
    }
}
