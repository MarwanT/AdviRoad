//
//  MockManager.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 13/03/2025.
//

import CoreData
@testable import AviRoad

struct MockManager {
  static var firstMockAdvisor: Advisor {
    Advisor(
      id: "550e8400-e29b-41d4-a716-446655440001",
      firstName: "Randall",
      lastName: "Le Pouce",
      totalAssets: 1234567.89,
      totalClients: 12,
      totalAccounts: 15,
      custodians: [
        Custodian(id: "c5a06098-8736-4238-983c-2b191ff7f5de", name: "Schwab", repId: "1001"),
        Custodian(id: "77326e8c-08d0-4960-8271-ea430693593e", name: "Fidelity", repId: "8989")
      ],
      accounts: nil
    )
  }
}
