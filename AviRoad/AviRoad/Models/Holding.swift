//
//  Holding.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import CoreData
import Foundation

struct Holding: Codable, Equatable, Identifiable, Hashable {
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

extension Holding: Searchable {
  var searchableText: String {
    return "\(ticker) \(units) \(unitPrice)"
      .trimmingCharacters(in: .whitespaces)
      .lowercased()
  }
}

//==============================================================================

extension HoldingEntity {
  convenience init(context: NSManagedObjectContext, structure: Holding) {
    self.init(context: context)
    id = structure.id
    ticker = structure.ticker
    units = Int16(structure.units)
    unitPrice = structure.unitPrice
  }
}

extension HoldingEntity: Updatable {
  func update(entity: HoldingEntity) {
    id = entity.id
    ticker = entity.ticker
    units = entity.units
    unitPrice = entity.unitPrice
  }
}
