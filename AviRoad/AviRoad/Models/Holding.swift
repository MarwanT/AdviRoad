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
  
  init(id: String, ticker: String, units: Int, unitPrice: Double) {
    self.id = id
    self.ticker = ticker
    self.units = units
    self.unitPrice = unitPrice
  }
  
  init(from entity: HoldingEntity) {
    self.id = entity.id ?? ""
    self.ticker = entity.ticker ?? ""
    self.units = Int(entity.units)
    self.unitPrice = Double(entity.unitPrice)
  }
}
