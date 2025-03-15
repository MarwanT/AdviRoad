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
