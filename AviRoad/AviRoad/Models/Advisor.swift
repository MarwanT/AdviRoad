//
//  Advisor.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import Foundation
import CoreData

struct Advisor: Codable, Identifiable, Hashable {
  let id: String
  let firstName: String
  let lastName: String
  let totalAssets: Double
  let totalClients: Int
  let totalAccounts: Int
  let custodians: [Custodian]
  let accounts: [Account]?
  var securities: [Security]?
  
  init(id: String, firstName: String, lastName: String, totalAssets: Double,
       totalClients: Int, totalAccounts: Int, custodians: [Custodian], accounts: [Account]?) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.totalAssets = totalAssets
    self.totalClients = totalClients
    self.totalAccounts = totalAccounts
    self.custodians = custodians
    self.accounts = accounts
    securities = nil
  }
  
  init(from entity: AdvisorEntity) {
    id = entity.id ?? ""
    firstName = entity.firstName ?? ""
    lastName = entity.lastName ?? ""
    totalAssets = Double(entity.totalAssets)
    totalClients = Int(entity.totalClients)
    totalAccounts = Int(entity.totalAccounts)
    custodians = entity.custodians?.map { entity in
      Custodian(from: entity as! CustodianEntity)
    } ?? []
    accounts = entity.accounts?.map { entity in
      Account(from: entity as! AccountEntity)
    } ?? []
  }
}

extension Advisor {
  var name: String {
    "\(firstName) \(lastName)".capitalized.trimmingCharacters(in: .whitespaces)
  }
}

extension Advisor: Equatable {
  static func == (lhs: Advisor, rhs: Advisor) -> Bool {
    let equalProperties = lhs.id == rhs.id
    && lhs.firstName == rhs.firstName
    && lhs.lastName == rhs.lastName
    && lhs.totalAssets == rhs.totalAssets
    && lhs.totalClients == rhs.totalClients
    && lhs.totalAccounts == rhs.totalAccounts
    var equalCustodians: Bool = lhs.custodians.count == rhs.custodians.count
    lhs.custodians.forEach { lhsCustodian in
      equalCustodians = equalCustodians && rhs.custodians.contains(where: { lhsCustodian == $0 })
    }
    var equalAccounts: Bool = lhs.accounts?.count ?? 0 == rhs.accounts?.count ?? 0
    lhs.accounts?.forEach { lhsAccount in
      equalAccounts = equalAccounts && rhs.accounts?.contains(where: { lhsAccount == $0 }) ?? false
    }
    return equalProperties && equalCustodians && equalAccounts
  }
}

//==============================================================================

extension AdvisorEntity {
  convenience init(context: NSManagedObjectContext, structure: Advisor) {
    self.init(context: context)
    id = structure.id
    firstName = structure.firstName
    lastName = structure.lastName
    totalAssets = structure.totalAssets
    totalClients = Int16(structure.totalClients)
    totalAccounts = Int16(structure.totalAccounts)
    custodians = NSSet(array: structure.custodians.map({ CustodianEntity(context: context, structure: $0) }))
    let accountEntities = structure.accounts?.map({ AccountEntity(context: context, structure: $0) })
    accounts = accountEntities != nil ? NSSet(array: accountEntities!) : nil
  }
}

extension AdvisorEntity: Updatable {
  func update(entity: AdvisorEntity) {
    id = entity.id
    firstName = entity.firstName
    lastName = entity.lastName
    totalAssets = entity.totalAssets
    totalClients = entity.totalClients
    totalAccounts = entity.totalAccounts
    custodians = entity.custodians
    accounts = entity.accounts
  }
}
