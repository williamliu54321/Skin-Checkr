//
//  SubscriptionRepository.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-07.
//

protocol SubscriptionRepository {
    /// Provides a continuous stream of subscription status updates.
    func listenForStatusChanges() -> AsyncStream<SubscriptionStatus>
    
    /// Triggers the presentation of a paywall for a given event.
    func presentPaywall(for event: String)
}
