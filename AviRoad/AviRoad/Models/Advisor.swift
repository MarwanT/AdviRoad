//
//  Advisor.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import Foundation
import CoreData

struct Advisor: Codable, Equatable, Identifiable {
  let id: String
  let firstName: String
  let lastName: String
  let totalAssets: Double
  let totalClients: Int
  let totalAccounts: Int
  let custodians: [Custodian]
  let accounts: [Account]?
  
  init(id: String, firstName: String, lastName: String, totalAssets: Double, totalClients: Int, totalAccounts: Int, custodians: [Custodian], accounts: [Account]?) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.totalAssets = totalAssets
    self.totalClients = totalClients
    self.totalAccounts = totalAccounts
    self.custodians = custodians
    self.accounts = accounts
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
