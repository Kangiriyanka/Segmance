//
//  ReviewManager.swift
//  Scenota
//
//  Created by Kangiriyanka The Single Leaf on 2025/12/09.
//

import Foundation
import StoreKit

// Notes: You get this prompt 3 times a year
class ReviewManager {
    static let shared = ReviewManager()
    
    private let defaults = UserDefaults.standard
    private let actionCountKey = "actionCount"
    private let lastReviewRequestKey = "lastReviewRequest"
    // If a user uploads a routine 25 times, it's a good time to ask
    private let actionThreshold = 25
    
    @MainActor func incrementActionCount() {
        let count = defaults.integer(forKey: actionCountKey) + 1
        defaults.set(count, forKey: actionCountKey)
        
        if shouldRequestReview(count: count) {
            requestReview()
        }
    }
    
    private func shouldRequestReview(count: Int) -> Bool {
        guard count >= actionThreshold else { return false }
        
       
        if let lastRequest = defaults.object(forKey: lastReviewRequestKey) as? Date {
            let daysSinceLastRequest = Calendar.current.dateComponents([.day], from: lastRequest, to: Date()).day ?? 0
            if daysSinceLastRequest < 120 {
                return false
            }
        }
        
        return true
    }
    
    @MainActor private func requestReview() {
        // Reset counter
        defaults.set(0, forKey: actionCountKey)
        defaults.set(Date(), forKey: lastReviewRequestKey)
        
        // Request review
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if #available(iOS 18.0, *) {
                AppStore.requestReview(in: scene)
            } else {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}
