//
//  ListenForSubscriptionChangesUseCase.swift
//  Skin Checkr
//
//  Created by William Liu on 2025-07-07.
//

import SwiftUI

// This use case encapsulates the single action of listening for updates.
struct ListenForSubscriptionChangesUseCase {
    private let repository: SubscriptionRepository

    init(repository: SubscriptionRepository) {
        self.repository = repository
    }

    func execute() -> AsyncStream<SubscriptionStatus> {
        return repository.listenForStatusChanges()
    }
}
