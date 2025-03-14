//
//  Advisor.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import Foundation

struct Advisor: Codable, Equatable, Identifiable {
  let id: String
  let firstName: String
  let lastName: String
  let totalAssets: Double
  let totalClients: Int
  let totalAccounts: Int
  let custodians: [Custodian]
}
