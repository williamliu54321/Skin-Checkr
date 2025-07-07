//
//  SuperwallSubscriptionRepository.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-07.
//

import Foundation
import SuperwallKit

// This class implements our protocol and is the ONLY place that talks to Superwall.
class SuperwallSubscriptionRepository: NSObject, SubscriptionRepository, SuperwallDelegate {
    
    private var statusContinuation: AsyncStream<SubscriptionStatus>.Continuation?
    private let statusStream: AsyncStream<SubscriptionStatus>

    override init() {
        self.statusStream = AsyncStream { continuation in
            self.statusContinuation = continuation
        }
        super.init()
        Superwall.configure(apiKey: "YOUR_SUPERWALL_API_KEY", delegate: self)
    }

    // Fulfills the protocol contract.
    func listenForStatusChanges() -> AsyncStream<SubscriptionStatus> {
        return statusStream
    }

    func presentPaywall(for event: String) {
        Superwall.shared.register(event: event)
    }
    
    // MARK: - SuperwallDelegate
    
    func subscriptionStatusDidChange(to newValue: SuperwallKit.SubscriptionStatus) {
        let domainStatus: SubscriptionStatus = newValue.isSubscribed ? .subscribed : .notSubscribed
        // Push the new value into our AsyncStream.
        statusContinuation?.yield(domainStatus)
    }
}
