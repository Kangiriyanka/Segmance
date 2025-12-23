//
//  LimitedPicker.swift
//  Segmance
//
//  Created by Kangiriyanka The Single Leaf on 2025/12/22.
//

import Foundation
import SwiftUI
import Photos


struct LimitedLibraryPickerPresenter: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        DispatchQueue.main.async {
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: vc)
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
