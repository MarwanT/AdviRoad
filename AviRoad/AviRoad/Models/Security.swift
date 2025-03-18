//
//  Security.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import CoreData
import Foundation

struct Security: Codable, Equatable, Identifiable, Hashable {
  let id: String
  let ticker: String
  let name: String
  let category: String
  let dateAdded: Date
  
  init(id: String, ticker: String, name: String, category: String, dateAdded: Date) {
    self.id = id
    self.ticker = ticker
    self.name = name
    self.category = category
    self.dateAdded = dateAdded
  }
  
  init(from entity: SecurityEntity) {
    id = entity.id ?? ""
    ticker = entity.ticker ?? ""
    name = entity.name ?? ""
    category = entity.category ?? ""
    dateAdded = entity.dateAdded ?? Date(timeIntervalSince1970: 0)
  }
}

extension Security {
  enum CodingKeys: String, CodingKey {
    case id
    case ticker
    case name
    case category
    case dateAdded
  }
  
  // MARK: - Custom Decodable Initializer
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.ticker = try container.decode(String.self, forKey: .ticker)
    self.name = try container.decode(String.self, forKey: .name)
    self.category = try container.decode(String.self, forKey: .category)
    // Decode the date string and convert it to a Date object
    let dateString = try container.decode(String.self, forKey: .dateAdded)
    guard let date = Date.fromISO8601(dateString) else {
      throw DecodingError.dataCorruptedError(
        forKey: .dateAdded,
        in: container,
        debugDescription: "Date string does not match expected format."
      )
    }
    self.dateAdded = date
  }
  
  // MARK: - Custom Encodable Implementation
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(ticker, forKey: .ticker)
    try container.encode(name, forKey: .name)
    try container.encode(category, forKey: .category)
    try container.encode(dateAdded.ISO8601Format(), forKey: .dateAdded)
  }
}

//==============================================================================

extension SecurityEntity {  
  convenience init(context: NSManagedObjectContext, structure: Security) {
    self.init(context: context)
    id = structure.id
    ticker = structure.ticker
    name = structure.name
    category = structure.category
    dateAdded = structure.dateAdded
  }
}

extension SecurityEntity: Updatable {
  func update(entity: SecurityEntity) {
    id = entity.id
    ticker = entity.ticker
    name = entity.name
    category = entity.category
    dateAdded = entity.dateAdded
  }
}
