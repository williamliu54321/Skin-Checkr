
import Foundation
import SuperwallKit

protocol SubscriptionsRepository {

    /// Registers an event and returns whether a paywall should show
    func registerEvent(_ trigger: String) async throws -> Bool

    /// Returns whether the user is subscribed
    func isUserSubscribed() async -> Bool
}

struct MockSubscriptionsRepository: SubscriptionsRepository {
    private let subscription: Bool
    private let shouldShowPaywall: Bool

    init(subscription: Bool = false, shouldShowPaywall: Bool = true) {
        self.subscription = subscription
        self.shouldShowPaywall = shouldShowPaywall
    }

    func configure() {
        print("Mock configure called")
    }

    func registerEvent(_ trigger: String) async throws -> Bool {
        print("Mock registerEvent called with trigger: \(trigger)")
        return shouldShowPaywall
    }

    func isUserSubscribed() async -> Bool {
        subscription
    }
}

final class DefaultSubscriptionsRepository: SubscriptionsRepository {

    func registerEvent(_ trigger: String) async -> Bool {
        let status = await Superwall.shared.subscriptionStatus

        switch status {
        case .active:
            print("User is subscribed")
            return true
        default:
            print("User not subscribed—showing paywall")
            Superwall.shared.register(placement: trigger)
            return false
        }
    }

    func isUserSubscribed() async -> Bool {
        let status = await Superwall.shared.subscriptionStatus

        if case .active = status {
            return true
        } else {
            return false
        }
    }
}
