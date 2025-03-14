//
//  Holding.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import Foundation

struct Holding: Codable, Equatable, Identifiable {
  let id: String
  let ticker: String
  let units: Int
  let unitPrice: Double
}
