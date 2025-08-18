//
//  RequestReview.swift
//  BabyNap
//
//  Created by Gabriel Santos on 18/8/25.
//

import Foundation

let MAX_REVIEW_REQUESTS = 1

class RequestReview {
    static let shared = RequestReview()
    
    
    private var reviewRequestedCount: Int {
        didSet { UserDefaults.standard.set(reviewRequestedCount, forKey: "reviewRequestedCount") }
    }
    
    init() {
        self.reviewRequestedCount = UserDefaults.standard.integer(forKey: "reviewRequestedCount")
    }
    
    func shouldRequest() -> Bool {
        reviewRequestedCount < MAX_REVIEW_REQUESTS
    }
}
