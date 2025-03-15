//
//  Custodian.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import CoreData

struct Custodian: Codable, Equatable, Identifiable {
  let id: String
  let name: String
  let repId: String?
  
  init(id: String, name: String, repId: String? = nil) {
    self.id = id
    self.name = name
    self.repId = repId
  }
  
  init(from entity: CustodianEntity) {
    id = entity.id ?? ""
    name = entity.name ?? ""
    repId = entity.repId
  }
}

//==============================================================================

extension CustodianEntity {
  convenience init(context: NSManagedObjectContext, structure: Custodian) {
    self.init(context: context)
    id = structure.id
    name = structure.name
    repId = structure.repId
  }
}
