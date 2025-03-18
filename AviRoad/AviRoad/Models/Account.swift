//
//  Account.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import CoreData
import Foundation

struct Account: Codable, Identifiable, Hashable {
  let id: String
  let name: String
  let number: String
  let clientId: String
  let advisorId: String
  let custodianId: String
  let holdings: [Holding]
  
  init(id: String, name: String, number: String, clientId: String, advisorId: String, custodianId: String, holdings: [Holding]) {
    self.id = id
    self.name = name
    self.number = number
    self.clientId = clientId
    self.advisorId = advisorId
    self.custodianId = custodianId
    self.holdings = holdings
  }
  
  init(from entity: AccountEntity) {
    id = entity.id ?? ""
    name = entity.name ?? ""
    number = entity.number ?? ""
    clientId = entity.clientId ?? ""
    advisorId = entity.advisorId ?? ""
    custodianId = entity.custodianId ?? ""
    self.holdings = entity.holdings?.map({ element in
      Holding(from: element as! HoldingEntity)
    }) ?? []
  }
}

extension Account: Equatable {
  static func == (lhs: Account, rhs: Account) -> Bool {
    let equalProperties = lhs.id == rhs.id
    && lhs.name == rhs.name
    && lhs.number == rhs.number
    && lhs.clientId == rhs.clientId
    && lhs.advisorId == rhs.advisorId
    && lhs.custodianId == rhs.custodianId
    var holdingsAreEqual = lhs.holdings.count == rhs.holdings.count
    lhs.holdings.forEach { lhsHolding in
      holdingsAreEqual = holdingsAreEqual && rhs.holdings.contains(where: { lhsHolding == $0 })
    }
    return equalProperties && holdingsAreEqual
  }
}

extension Account: Searchable {
  var searchableText: String {
    var holdingsSearchable: String = holdings.map({ $0.searchableText }).joined(separator: " ")
    return "\(name) (\(number)) \(holdingsSearchable)"
      .trimmingCharacters(in: .whitespaces)
      .lowercased()
  }
}

//==============================================================================

extension AccountEntity {
  convenience init(context: NSManagedObjectContext, structure: Account) {
    self.init(context: context)
    id = structure.id
    name = structure.name
    number = structure.number
    clientId = structure.clientId
    advisorId = structure.advisorId
    custodianId = structure.custodianId
    holdings = NSSet(array: structure.holdings.map({ HoldingEntity(context: context, structure: $0) }))
  }
}

extension AccountEntity: Updatable {
  func update(entity: AccountEntity) {
    id = entity.id
    name = entity.name
    number = entity.number
    clientId = entity.clientId
    advisorId = entity.advisorId
    custodianId = entity.custodianId
    holdings = entity.holdings
  }
}
