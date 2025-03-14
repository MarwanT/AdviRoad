//
//  Account.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import Foundation

struct Account: Codable, Equatable, Identifiable {
  let id: String
  let name: String
  let number: String
  let clientId: String
  let advisorId: String
  let custodianId: String
  let holdings: [Holding]
}
